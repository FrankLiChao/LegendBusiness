//
//  CustomerSeviceController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/3.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "CustomerSeviceController.h"
#import "CustomerSeverListCell.h"
#import "EnterRefuseReasonController.h"
#import "SeverOrderDetailController.h"
#import "OrderDetailController.h"
#import "ModefyBackNameViewController.h"
#import "CheckBigImageController.h"
#import "PostInfoController.h"

@interface CustomerSeviceController ()<CustomerSeverListCellDelegate,UIAlertViewDelegate>{
    
    UISegmentedControl *seg;
    
}
@property (nonatomic,weak)IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)SellerAfterListModel *selectModel;
@property (nonatomic,strong)NSString *returnAddr;

@end


@implementation CustomerSeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    
    seg = [[UISegmentedControl alloc] initWithItems:@[@"未处理",@"处理中"]];
    [seg addTarget:self action:@selector(segValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
    
    seg.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200)/2, seg.frame.origin.y, 200, seg.frame.size.height);
    _tableView.tableFooterView = [UIView new];
    seg.selectedSegmentIndex = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciverAfterRefuseNotify:) name:SYS_NOTI_REFUSE_BUYER_AFTER object:nil];
    
    __weak __typeof(self)weakSelf = self;
    [self.tableView addRefreshHeader:^(MJRefreshHeader * header) {
        
        
        if (weakSelf.tableView.mj_footer.state == MJRefreshStatePulling ||
            weakSelf.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            
            weakSelf.tableView.mj_header.state = MJRefreshStateIdle;
        }
        else {
            
            
            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            [weakSelf refreshData];
            
        }
    }];
    [self.tableView addRefreshFooter:^(MJRefreshFooter * footer) {
        if (weakSelf.tableView.mj_header.state == MJRefreshStatePulling ||
            weakSelf.tableView.mj_header.state == MJRefreshStateRefreshing) {
            
            weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
        }
        else{
            [weakSelf loadData];
        }
    }];
    
    [_tableView.mj_header beginRefreshing];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark custom methods
- (void)segValueChanged:(UISegmentedControl*)seg{
    
  [_tableView.mj_header beginRefreshing];
    
    
}

- (int)currentStatus{
    
    if (seg.selectedSegmentIndex == 0) {
        return 1;
    }
    else return 2;
}
- (void)refreshData{
    
    __weak typeof(self) weakSelf = self;
    [self getSellerAfterList:@"0"
                      status:[self currentStatus]
                     success:^(NSArray<SellerAfterListModel *> *array,NSString *returnAddr,int status) {
                         
                         if (status == [weakSelf currentStatus]) {
                             
                            
                             weakSelf.returnAddr = returnAddr;
                             weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
                             [weakSelf.tableView reloadData];
                             [weakSelf.tableView.mj_header endRefreshing];
                             
                             weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
                         }
                         
                     } failed:^(NSString *errorDes,int status) {
                         
                         if (status == [weakSelf currentStatus]) {
                             [self showHint:errorDes];
                             [weakSelf.tableView.mj_header endRefreshing];
                         }
                         
                     }];
}

- (void)loadData{
    
    __weak typeof(self) weakSelf = self;
    SellerAfterListModel *model = [self.dataArray lastObject];
    
    
    [self getSellerAfterList:model.after_id
                      status:[self currentStatus]
                     success:^(NSArray<SellerAfterListModel *> *array,NSString *returnAddr,int status) {
                         
                         weakSelf.returnAddr = returnAddr;
                         
                         if (status == [weakSelf currentStatus]) {
                             
                             if (!array || array.count <=0) {
                                 
                                 [weakSelf.tableView.mj_footer endRefreshing];
                                 weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                             }
                             else{
                                 [weakSelf.dataArray addObjectsFromArray: array];
                                 [weakSelf.tableView reloadData];
                                 [weakSelf.tableView.mj_footer endRefreshing];
                             }
                             
                             
                         }
                         
                     } failed:^(NSString *errorDes,int status) {
                         
                         if (status == [weakSelf currentStatus]) {
                             [self showHint:errorDes];
                             [weakSelf.tableView.mj_footer endRefreshing];
                         }
                         
                     }];
    
}


#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SellerAfterListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    return [CustomerSeverListCell cellHeight:model];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomerSeverListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerSeverListCell"];
    cell.delegate = self;
    
    SellerAfterListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    if (seg.selectedSegmentIndex == 0) {//未处理
        [cell showUnDealCellWithModel:model];
    }
    else {
        [cell showDealingCellWithModel:model];
    }
    
    return cell;
}

#pragma mark CustomerSeverListCellDelegate
- (void)sureReciveAction:(CustomerSeverListCell*)cell{

    NSIndexPath *index = [_tableView  indexPathForCell:cell];
    self.selectModel =[_dataArray objectAtIndex:index.row];
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"是否确定已收到货"
                                                   delegate:self
                                          cancelButtonTitle:@"不"
                                          otherButtonTitles:@"确定", nil];
    [alter show];
    
    
 }


- (void)agreeRetueAction:(CustomerSeverListCell*)cell{
    
    NSIndexPath *index = [_tableView  indexPathForCell:cell];
    
    __block SellerAfterListModel *model =[_dataArray objectAtIndex:index.row];
    
    ModefyBackNameViewController *vc = [[ModefyBackNameViewController alloc] initWithNibName:@"ModefyBackNameViewController" bundle:nil];
    vc.oldValue = self.returnAddr;
    vc.myID = model.after_id;
    vc.type = ModefyType_AddSeller_After_Address;
    vc.strtitle = @"收货信息地址(姓名，电话，地址)";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)refuseAction:(CustomerSeverListCell*)cell{

    NSIndexPath *index = [_tableView  indexPathForCell:cell];
    
    SellerAfterListModel *model =[_dataArray objectAtIndex:index.row];
    
    EnterRefuseReasonController *vc = [[EnterRefuseReasonController alloc] initWithNibName:@"EnterRefuseReasonController" bundle:nil];
    
    vc.ID = model.after_id;
    vc.type = InPutTextViewType_AfterRefuse;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)checkOrderDetail:(CustomerSeverListCell*)cell{

    NSIndexPath *index = [_tableView  indexPathForCell:cell];
    
    SellerAfterListModel *model =[_dataArray objectAtIndex:index.row];
    
    if([model goodsType] == ProuductType_Server){//服务类
        
        SeverOrderDetailController *vc = [[SeverOrderDetailController alloc] initWithNibName:@"SeverOrderDetailController" bundle:nil];
        vc.orderId = model.order_id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else{
        OrderDetailController *vc = [[OrderDetailController alloc] initWithNibName:@"OrderDetailController" bundle:nil];
        vc.orderId = model.order_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)checkPicDetail:(NSString*)imageUrl{
    
    CheckBigImageController *vc = [[CheckBigImageController alloc] initWithURL:imageUrl];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark notify
- (void)reciverAfterRefuseNotify:(NSNotification*)nofity{

    NSString *afterId = [nofity object];
    
    [self.dataArray enumerateObjectsUsingBlock:^(SellerAfterListModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ( [obj.after_id isEqualToString:afterId]) {
            
            [self.dataArray  removeObject:obj];
            [self.tableView reloadData];
            
            *stop = YES;
        }
    }];
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{


    if (buttonIndex == 1) {
        
        if ([self.selectModel.after_type intValue] == 1) {//退货
            __weak typeof(self) weakSelf = self;
            [self showHint:@"处理中"];
            [self afterSureRecive:self.selectModel.after_id
                           comple:^(BOOL bSuccess, NSString *message) {
                               [weakSelf hideHud];
                               [weakSelf showHint:message];
                               if (bSuccess) {
                                   
                                   [[NSNotificationCenter defaultCenter] postNotificationName:SYS_NOTI_REFUSE_BUYER_AFTER object:weakSelf.selectModel.order_id];
                                   weakSelf.selectModel = nil;
                               }
                               
                           }];
         
        }
        else if([_selectModel.after_type intValue] == 2){//换货
           
            PostInfoController *vc = [[PostInfoController alloc] initWithNibName:@"PostInfoController" bundle:nil];
            vc.afterId = _selectModel.after_id;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        


    }
}

@end
