//
//  SeverOrderDetailController.m
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/4.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "SeverOrderDetailController.h"
#import "CheckOrderDetailCell.h"
#import "EdgeCell.h"

@interface SeverOrderDetailController ()

@property (nonatomic,weak)IBOutlet UITableView *tableView;
@property (nonatomic,weak)IBOutlet UILabel *headerStatusLabel;
@property (nonatomic,weak)IBOutlet UILabel *orderNumLabel;
@property (nonatomic,weak)IBOutlet UILabel *createDateLabel;

@property (nonatomic,weak)IBOutlet UILabel *codeLabel;


@property (nonatomic,weak)IBOutlet UIImageView *headerLineImageView;
//@property (nonatomic,weak)IBOutlet UIButton *footButton;
//@property (nonatomic,weak)IBOutlet NSLayoutConstraint *footButtonHeight;


@property (nonatomic,strong)OrderModel  *currentModel;

@end

@implementation SeverOrderDetailController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    self.title = @"订单详情";
    
    
    UIImage *image = [UIImage imageNamed:@"color_line"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
    _headerLineImageView.image  = image;
    
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
    
    if ([_currentModel.order_status  intValue] == OrderStatusType_UnPay) {
        
        _codeLabel.text = @"";
        _headerStatusLabel.text = @"未付款";
//        _footButtonHeight.constant = [Configure SYS_UI_SCALE:44];;
//        
//        [_footButton setTitle:@"等待买家付款" forState:UIControlStateNormal];
//        _footButton.enabled = NO;
//        _footButton.backgroundColor = [UIColor lightGrayColor];
//        [_footButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }
    else if([_currentModel.order_status intValue] == OrderStatusType_UnRecieve ||
            [_currentModel.order_status intValue] == OrderStatusType_UnSend){
        
        _headerStatusLabel.text = @"未消费";
        _codeLabel.text = @"";
//        _footButtonHeight.constant = [Configure SYS_UI_SCALE:44];
//        [_footButton setTitle:@"确认消费" forState:UIControlStateNormal];
//        _footButton.enabled = NO;
//        _footButton.backgroundColor = [UIColor lightGrayColor];
//        [_footButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }
    else if([_currentModel.order_status intValue] == OrderStatusType_Done){
        _codeLabel.text = _currentModel.exchange_code;
        _headerStatusLabel.text = @"交易完成";
//        _footButtonHeight.constant = 0;
    }
    
    _orderNumLabel.text = [NSString stringWithFormat:@"订单编号：%@",_currentModel.order_sn];
    _createDateLabel.text = [NSString stringWithFormat:@"提交时间：%@",[_currentModel dateStr]];
    
    [self.tableView reloadData];
    
}
//
//- (IBAction)clickFootButton:(id)sender{
//    
//    //发货
//    [self showHint:@""];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    [self orderVerifyExchangeCode:_currentModel.exchange_code
//                          success:^(NSString *orderId){
//                              [weakSelf hideHud];
//                              [weakSelf showHint:@"发货成功"];
//                              
//                              weakSelf.currentModel.order_status = [NSString stringWithFormat:@"%d",OrderStatusType_Done];
//                              [[NSNotificationCenter defaultCenter] postNotificationName:SYS_NOTI_SURE_SEND_ORDER object:weakSelf.currentModel.order_id];
//                              [weakSelf setUI];
//                              
//                          } failed:^(NSString *errorDes) {
//                             
//                              [weakSelf hideHud];
//                              [weakSelf showHint:errorDes];
//                              
//                          }];
//    
//}

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 2;
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
    
    if (section==0) {
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
    else{
        
        EdgeCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"CheckOrderDetailCell1"];
        if (!cell) {
            cell = [[EdgeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CheckOrderDetailCell1"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [Configure SYS_UI_COLOR_TEXT_GRAY];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = [Configure SYS_UI_COLOR_BG_RED];
            cell.textLabel.text = @"实际收入";
        }
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",self.currentModel.order_amount];
        return cell;
        
    }
    return nil;
    
}

@end
