//
//  OrderDetailController.m
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/3.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "OrderDetailController.h"
#import "CheckOrderDetailCell.h"
#import "EdgeCell.h"
#import "ExpressTableViewCell.h"
#import "ScanQRViewController.h"
#import "legend_business_ios-Swift.h"

@interface OrderDetailController ()<UIAlertViewDelegate>

@property (nonatomic,weak)IBOutlet UITableView *tableView;
@property (nonatomic,weak)IBOutlet UILabel *headerStatusLabel;
@property (nonatomic,weak)IBOutlet UILabel *orderNumLabel;
@property (nonatomic,weak)IBOutlet UILabel *createDateLabel;

@property (nonatomic,weak)IBOutlet UILabel *nameLabel;
@property (nonatomic,weak)IBOutlet UILabel *phoneLanel;
@property (nonatomic,weak)IBOutlet UILabel *addressLabel;

@property (nonatomic,weak)IBOutlet UIImageView *headerLineImageView;

@property (nonatomic,weak)IBOutlet UIButton *footButton;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *footButtonHeight;

@property (nonatomic,strong)OrderModel  *currentModel;

@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    self.title = @"订单详情";
    
    
    UIImage *image = [UIImage imageNamed:@"color_line"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
    _headerLineImageView.image  = image;
    [self.tableView registerNib:[UINib nibWithNibName:@"ExpressTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExpressTableViewCell"];
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    
    
    [self showHudInView:self.view hint:nil];
    
    __weak typeof(self) weakSelf = self;
    [self getOrderDetail:self.orderId
                 success:^(OrderModel *model) {
                     [weakSelf hideHud];
                     
                     weakSelf.currentModel = model;
                     [weakSelf setUI];
                     
                 
                 } failed:^(NSString *errorDes) {
                     [weakSelf hideHud];
                     
                 }];
}

- (void)setUI{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    ExpressTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([_currentModel.order_status  intValue] == OrderStatusType_UnPay) {
        _headerStatusLabel.text = @"未付款";
        _footButtonHeight.constant = [Configure SYS_UI_SCALE:44];;
        
        [_footButton setTitle:@"等待买家付款" forState:UIControlStateNormal];
        _footButton.enabled = NO;
        _footButton.backgroundColor = [UIColor lightGrayColor];
        [_footButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }
    else if([_currentModel.order_status intValue] == OrderStatusType_UnRecieve){
        cell.expressTx.text = _currentModel.shipping_number;
        _headerStatusLabel.text = @"已发货";
        _footButtonHeight.constant = [Configure SYS_UI_SCALE:44];
        [_footButton setTitle:@"等待客户确认" forState:UIControlStateNormal];
        _footButton.enabled = NO;
        _footButton.backgroundColor = [UIColor lightGrayColor];
        [_footButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }
    else if([_currentModel.order_status intValue] == OrderStatusType_UnSend){
        
        _headerStatusLabel.text = @"等待发货";

        _footButtonHeight.constant = [Configure SYS_UI_SCALE:44];
        [_footButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _footButton.backgroundColor = [Configure SYS_UI_COLOR_BG_RED];
        [_footButton setTitle:@"发货" forState:UIControlStateNormal];
        
    }
    else if([_currentModel.order_status intValue] == OrderStatusType_UnComment ||
            [_currentModel.order_status intValue] == OrderStatusType_HaveComments){
        
        _headerStatusLabel.text = @"交易完成";
        _footButtonHeight.constant = 0;
    }
    
    _orderNumLabel.text = [NSString stringWithFormat:@"订单编号：%@",_currentModel.order_sn];
    _createDateLabel.text = [NSString stringWithFormat:@"提交时间：%@",[_currentModel dateStr]];
    
    _nameLabel.text = _currentModel.consignee;
    _phoneLanel.text = _currentModel.mobile;
    _addressLabel.text = [NSString stringWithFormat:@"%@%@",_currentModel.area?_currentModel.area:@"",_currentModel.address];
    
    [self.tableView reloadData];
    
}

- (IBAction)clickFootButton:(id)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    ExpressTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.expressTx.text.length <= 0) {
        [self showHint:@"请填写物流单号"];
        return;
    }
    UIAlertView *ater = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认发货" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [ater show];
}

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {//行高
    
    if (indexPath.section == 0) {
        return [CheckOrderDetailCell cellHeight:self.currentModel];
    }
    return 44;
}


#pragma mark - UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- ( UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==0 || section == 1) {
        return 0;
    }
    return 10;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        
        CheckOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckOrderDetailCell"];
        if (!cell) {
            cell = [[CheckOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckOrderDetailCell"];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
             [cell setUIWithModel:self.currentModel];
        });
       
        
        return cell;
    }
    else if (indexPath.section == 1){
        
        EdgeCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"CheckOrderDetailCell1"];
        if (!cell) {
            cell = [[EdgeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CheckOrderDetailCell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [Configure SYS_UI_COLOR_TEXT_GRAY];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = [Configure SYS_UI_COLOR_BG_RED];
            cell.textLabel.text = @"实际收入";
        }
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",self.currentModel.true_income];
        return cell;
        
    }
    else {
        ExpressTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"ExpressTableViewCell"];
        if ([self.currentModel.order_status integerValue] == 1 || [self.currentModel.order_status integerValue] == 0) {
            cell.scanExpressBtn.hidden = NO;
            cell.expressTx.enabled = YES;
        }else{
            cell.scanExpressBtn.hidden = YES;
            cell.expressTx.enabled = NO;
        }
        cell.expressTx.text = self.currentModel.shipping_number?self.currentModel.shipping_number:@"";
        [cell.scanExpressBtn addTarget:self action:@selector(clickScanEvent) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
    
}

-(void)clickScanEvent{
    ScanQRViewController *scanQRVc = [ScanQRViewController new];
    scanQRVc.delegate = self;
    [self.navigationController pushViewController:scanQRVc animated:YES];
}

-(void)refreshUI:(NSString *)expressOrderId{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    ExpressTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.expressTx.text = expressOrderId?expressOrderId:@"";
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        ExpressTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        //发货
        [self showHudInView:self.view hint:@""];
        
        __weak typeof(self) weakSelf = self;
        [self modifyOrderStatus:_currentModel.order_id
                        expressId:cell.expressTx.text
                         status:1
                        success:^{
                            [weakSelf hideHud];
                            [weakSelf showHint:@"发货成功"];
                            
                            weakSelf.currentModel.order_status = [NSString stringWithFormat:@"%d",OrderStatusType_UnRecieve];
                            weakSelf.currentModel.shipping_number = cell.expressTx.text;
                            [[NSNotificationCenter defaultCenter] postNotificationName:SYS_NOTI_SURE_SEND_ORDER object:weakSelf.currentModel.order_id];
                            [weakSelf setUI];
                            
                        } failed:^(NSString *errorDes) {
                            [weakSelf hideHud];
                            [weakSelf showHint:errorDes];
                        }];
        
    }

}


@end
