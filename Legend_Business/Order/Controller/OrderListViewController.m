//
//  OrderListViewController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/3.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListCell.h"
#import "CustomSegView.h"
#import "CustomInputAlterView.h"
#import "OrderDetailController.h"
#import "SeverOrderDetailController.h"

@interface OrderListViewController ()<
UISearchDisplayDelegate,
UISearchControllerDelegate,
UISearchResultsUpdating,
UISearchBarDelegate,
UITableViewDataSource,
UITableViewDelegate,
CustomSegViewDelegate,
UIAlertViewDelegate >{
    
    
    UISearchController   * searchDisplayController;
    UISearchController          * searchController;
    UISearchBar                 * searchBar;
    CustomSegView               * sectionHeaderView;
}

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong)  NSMutableArray *dataArray;
@property (nonatomic,strong)  NSMutableArray *searchResultArray;
@property (nonatomic) NSInteger currentSegIndex;

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
//    [self addRightBarItem:@"消费码" method:@selector(enterCode:)];
    
    self.title = @"我的订单";
    self.dataArray = [NSMutableArray array];
    self.searchResultArray = [NSMutableArray array];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveOrderSendNotify:) name:SYS_NOTI_SURE_SEND_ORDER object:nil];
    
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
    
    self.currentSegIndex = 0;
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark custom methods

- (void)refreshData{
    
  
    __weak __typeof(self)weakSelf = self;
    __block OrderStatusType type = [self orderType:_currentSegIndex];
    
    [self getOrderList:@"0"
           orderStatus:type
               success:^(NSArray<OrderListModel *> *array) {
                   
                   if (type == [weakSelf orderType:weakSelf.currentSegIndex]) {
                       
                       weakSelf.dataArray = [NSMutableArray arrayWithArray:array];

                       [weakSelf.tableView reloadData];
                       [weakSelf.tableView.mj_header endRefreshing];
                        weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
                   }
                   
               } failed:^(NSString *errorDes) {
                  
                   if (type == [weakSelf orderType:weakSelf.currentSegIndex]) {
                       [weakSelf.tableView reloadData];
                       [weakSelf.tableView.mj_header endRefreshing];
                   }
                   
               }];
}

- (void)loadData{

    __weak __typeof(self)weakSelf = self;
    __block OrderStatusType type = [self orderType:_currentSegIndex];
    OrderListModel *model = [self.dataArray lastObject];
    
    [self getOrderList:model.order_id
           orderStatus:type
               success:^(NSArray<OrderListModel *> *array) {
                   
                   if (type == [weakSelf orderType:weakSelf.currentSegIndex]) {
                       
                       if (!array || array.count == 0){
                           [weakSelf.tableView.mj_footer endRefreshing];
                            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                       }
                       else{
                           [weakSelf.dataArray addObjectsFromArray:array];
                           [weakSelf.tableView reloadData];
                               [weakSelf.tableView.mj_footer endRefreshing];
                       }
                      
                   
                   }
                   
               } failed:^(NSString *errorDes) {
                   
                   if (type == [weakSelf orderType:weakSelf.currentSegIndex]) {
                       [weakSelf.tableView.mj_footer endRefreshing];
                   }
                   
               }];
    
    
}

- (OrderStatusType)orderType:(NSInteger)index{

    if (index == 0) {
        return OrderStatusType_UnPay;
    }
    else if(index == 1)return OrderStatusType_UnSend;
    else if (index == 2)return OrderStatusType_UnRecieve;
    else if(index == 3)return OrderStatusType_Done;
    else return OrderStatusType_All;
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    if(tableView != self.tableView) return _searchResultArray.count;
    else return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(tableView != self.tableView) return 0;
    else return 54;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (!sectionHeaderView) {
        sectionHeaderView = [CustomSegView createWithNib];
        sectionHeaderView.delegate = self;
        sectionHeaderView.selectIndex = self.currentSegIndex;
    }
 
    return  sectionHeaderView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell"];
    
    OrderListModel *model = nil;
    
    if (tableView != self.tableView)
    {
        model = [_searchResultArray objectAtIndex:indexPath.row];
    } else {
        model =[_dataArray objectAtIndex:indexPath.row];
    }
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb] placeholderImage:[UIImage imageNamed:@"默认"]];
    cell.orderNumLabel.text = model.order_sn;
    cell.reciverNameLabel.text = model.consignee;
    cell.dateLabel.text = [model dateStr];
    
    if ([model.order_status intValue] == OrderStatusType_UnPay) {
          cell.statusLabel.text = @"待付款";
    }
    else if ([model.order_status intValue] == OrderStatusType_UnSend ){
         cell.statusLabel.text = @"待发货";
    }
    else if ([model.order_status intValue] == OrderStatusType_UnRecieve){
        cell.statusLabel.text = @"已发货";
    }
    else if ([model.order_status intValue] == OrderStatusType_UnComment ||
             [model.order_status intValue] == OrderStatusType_HaveComments ){
        cell.statusLabel.text = @"已完成";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderListModel *model =[_dataArray objectAtIndex:indexPath.row];
    
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


#pragma mark - UISearchDisplayDelegate

- (void) searchDisplayControllerDidEndSearch:(UISearchController *)controller{
    
}

#pragma mark - UISearchControllerDelegate
- (void)presentSearchController:(UISearchController *)searchController{
    
    
    //    UIBarButtonItem *cancle = [searchBar valueForKey:@"_cancelBarButtonItem"];
    //    if(cancle){
    //        cancle.title = @"取消";
    //    }
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    //    UIBarButtonItem *cancle = [searchBar valueForKey:@"_cancelBarButtonItem"];
    //    if(cancle){
    //        cancle.title = @"取消";
    //    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)hsearchBar
{
    
    
    
}


#pragma mark custom methods
//输入消费码
//- (void)enterCode:(UIButton*)button{
//
//    [CustomInputAlterView showWithAlterDelegate:self];
//}

#pragma mark CustomSegViewDelegate


- (void)segValueChanged:(NSInteger)index{

    self.currentSegIndex = index;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
       UITextField *nameField = [alertView textFieldAtIndex:0];
        
        if ([UitlCommon isNull:nameField.text]) {
            return;
        }
        
           __weak __typeof(self)weakSelf = self;
        
        [self showHudInView:self.view hint:@"验证中"];
        [self orderVerifyExchangeCode:nameField.text
                              success:^(NSString *orderId){
                                  [weakSelf hideHud];
                                  [weakSelf showHint:@"验证成功,已消费"];
                                  
                                  SeverOrderDetailController *vc = [[SeverOrderDetailController alloc] initWithNibName:@"SeverOrderDetailController" bundle:nil];
                                  vc.orderId = orderId;
                                  [weakSelf.navigationController pushViewController:vc animated:YES];
                                  
                              } failed:^(NSString *errorDes) {
                                  [weakSelf hideHud];
                                  [weakSelf showHint:errorDes];
                                  
                              }];
        
        
    }
}


#pragma mark  recieveOrderSendNotify


- (void)recieveOrderSendNotify:(NSNotification*)notify{


    NSString *orderId = [notify  object ];
    
    [self.dataArray enumerateObjectsUsingBlock:^(OrderListModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([orderId isEqualToString:obj.order_id]) {
            [self.dataArray removeObject:obj];
            [self.tableView reloadData];
            *stop = YES;
            
        }
    }];
}

@end
