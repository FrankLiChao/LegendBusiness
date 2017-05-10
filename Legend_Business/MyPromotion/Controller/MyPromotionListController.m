//
//  MyPromotionListController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/5.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "MyPromotionListController.h"
#import "MyPromotionListCell.h"
#import "AddPromotionController.h"

@interface MyPromotionListController ()<MyPromotionListCellDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UIButton  *addNewButton;
@property (nonatomic) int currentPage;


@end

@implementation MyPromotionListController

- (void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的推广";
    [self setBackButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveAddNewAdVSuccess) name:SYS_ADD_ADV_SUCESS_NOTIFY object:nil];
    
    
    [UitlCommon setFlatWithView:_addNewButton radius:[Configure SYS_CORNERRADIUS]];
    
    self.dataArray = [NSMutableArray array];
    
    _tableView.tableFooterView = [UIView new];
    
    __weak __typeof(self)weakSelf = self;
    [self.tableView addRefreshHeader:^(MJRefreshHeader * header) {
        
        
        if (weakSelf.tableView.mj_footer.state == MJRefreshStatePulling ||
            weakSelf.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            
            weakSelf.tableView.mj_header.state = MJRefreshStateIdle;
        }
        else {
            
            weakSelf.currentPage = 1;
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
            weakSelf.currentPage++;
            [weakSelf loadData];
        }
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark custom methods
- (void)refreshData{
    
    __weak typeof(self) weakSelf = self;
    
    [self getMyAdvList:_currentPage success:^(NSArray<PromotionListModel *> *advList, int totoalPage) {
        
        if (totoalPage == weakSelf.currentPage) {
            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        
        weakSelf.dataArray = [NSMutableArray arrayWithArray:advList ];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        
        
    } failed:^(NSString *errorDes) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf showHint:errorDes];
    }];
    
}

- (void)loadData{
    
    __weak typeof(self) weakSelf = self;
    
    
    [self getMyAdvList:_currentPage success:^(NSArray<PromotionListModel *> *advList, int totoalPage) {

        
        [weakSelf.dataArray addObjectsFromArray:advList];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        if (totoalPage <= weakSelf.currentPage) {
            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        
        
    } failed:^(NSString *errorDes) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf showHint:errorDes];
    }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return  [UIView new];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyPromotionListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyPromotionListCell"];
    cell.delegate = self;
    PromotionListModel *model =  model =[_dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setUIWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    MaskDetailController *vc = [[MaskDetailController alloc] initWithNibName:@"MaskDetailController" bundle:nil];
    //
    //    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark MyPromotionListCellDelegate
- (void)clickEditPromotion:(MyPromotionListCell*)cell{
    
    NSIndexPath *index = [_tableView   indexPathForCell:cell];
    if (index && index.row< _dataArray.count) {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Store" bundle:nil];
        PromotionListModel *model =  model =[_dataArray objectAtIndex:index.row];
        
        AddPromotionController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"AddPromotionController"];
        vc.listModel = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
    
}

#pragma mark notify
- (void)recieveAddNewAdVSuccess{

    
    [self.tableView.mj_header beginRefreshing];
}

@end
