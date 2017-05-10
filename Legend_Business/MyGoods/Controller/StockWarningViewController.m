//
//  StockWarningViewController.m
//  legend_business_ios
//
//  Created by Tsz on 2016/11/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "StockWarningViewController.h"
#import "AddPromotionController.h"


@interface StockWarningViewController () <UITableViewDataSource, UITableViewDelegate, GoodListCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic) NSInteger currentPage;
@end

@implementation StockWarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"库存预警";
    
    self.data = [NSMutableArray array];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    
    __weak __typeof(self)weakSelf = self;
    [self.tableView addRefreshHeader:^(MJRefreshHeader * header) {
        if (weakSelf.tableView.mj_footer.state == MJRefreshStatePulling ||
            weakSelf.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            weakSelf.tableView.mj_header.state = MJRefreshStateIdle;
        } else {
            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            [weakSelf refreshData];
        }
    }];
    [self.tableView addRefreshFooter:^(MJRefreshFooter * footer) {
        if (weakSelf.tableView.mj_header.state == MJRefreshStatePulling ||
            weakSelf.tableView.mj_header.state == MJRefreshStateRefreshing) {
            
            weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
        } else {
            [weakSelf loadData];
        }
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    __weak __typeof(self) weakSelf = self;
    self.currentPage = 1;
    [self getGoodsList:self.currentPage goodsType:4 success:^(NSArray<ProductListModel *> *array1, NSInteger totalPage1, NSInteger saleCount1, NSInteger downCount1) {
        weakSelf.data = [array1 mutableCopy];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failed:^(NSString *errorDes) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadData{
    __weak __typeof(self)weakSelf = self;
    NSInteger goToPage = self.currentPage + 1;
    [self getGoodsList:goToPage
             goodsType:4
               success:^(NSArray<ProductListModel *> *array, NSInteger totalPage, NSInteger saleCount, NSInteger downCount) {
                   [weakSelf.data addObjectsFromArray:array];
                   
                   weakSelf.currentPage = goToPage;
                   
                   [weakSelf.tableView reloadData];
                   [weakSelf.tableView.mj_footer endRefreshing];
                   
                   if (totalPage == weakSelf.currentPage) {
                       weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                   } else {
                       weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
                   }
               } failed:^(NSString *errorDes) {
                   [weakSelf.tableView.mj_footer endRefreshing];
               }];
    
}

#pragma mark - GoodListCellDelegate
- (void)goodsListCellTapEditBtnWithCell:(GoodListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ProductListModel *model = [self.data objectAtIndex:indexPath.row];
    AddOrEditGoodsViewController *edit = [[UIStoryboard storyboardWithName:@"Store" bundle:nil] instantiateViewControllerWithIdentifier:@"AddOrEditGoodsViewController"];
    edit.goods_id = [model.goods_id integerValue];
    [self.navigationController pushViewController:edit animated:YES];
}

- (void)goodsListCellTapUpBtnWithCell:(GoodListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    __block ProductListModel *model = nil;
    __block NSMutableArray *array = nil;
    model = [self.data objectAtIndex:indexPath.row];
    array = self.data;
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:@"上架中..."];
    [self changeGoodsStatus:3
                    goodsID:model.goods_id
                    success:^{
                        [weakSelf hideHud];
                        [weakSelf showHint:@"上架成功"];
                        [array removeObject:model];
                        [weakSelf.tableView reloadData];
                    } failed:^(NSString *errorDes) {
                        [weakSelf hideHud];
                        [weakSelf showHint:errorDes];
                    }];
}

- (void)goodsListCellTapDownBtnWithCell:(GoodListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    __block ProductListModel *model = nil;
    __block NSMutableArray *array = nil;
    model = [self.data objectAtIndex:indexPath.row];
    array = self.data;
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:@"下架中..."];
    [self changeGoodsStatus:1
                    goodsID:model.goods_id
                    success:^{
                        [weakSelf hideHud];
                        [weakSelf showHint:@"下架成功"];
                        [array removeObjectAtIndex:indexPath.row];
                        
                        [weakSelf.tableView reloadData];
                    } failed:^(NSString *errorDes) {
                        [weakSelf hideHud];
                        [weakSelf showHint:errorDes];
                    }];
}

- (void)goodsListCellTapPromoteBtnWithCell:(GoodListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ProductListModel *model = [self.data objectAtIndex:indexPath.row];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Store" bundle:nil];
    AddPromotionController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"AddPromotionController"];
    vc.goodModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goodsListCellTapDeleteBtnWithCell:(GoodListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    __block ProductListModel *model = nil;
    __block NSMutableArray *array = nil;
    model = [self.data objectAtIndex:indexPath.row];
    array = self.data;
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:@"删除中..."];
    [self changeGoodsStatus:2
                    goodsID:model.goods_id
                    success:^{
                        [weakSelf hideHud];
                        [weakSelf showHint:@"删除成功"];
                        [array removeObject:model];
                        [weakSelf.tableView reloadData];
                    } failed:^(NSString *errorDes) {
                        [weakSelf hideHud];
                        [weakSelf showHint:errorDes];
                    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ProductListModel *model = [self.data objectAtIndex:indexPath.row];;
    cell.preSaleLabel.hidden = NO;
    cell.preSaleLabel.text = @"库存预警";
    [cell.downBtn setTitle:@"下架" forState:UIControlStateNormal];
    [cell.downBtn setImage:[UIImage imageNamed:@"下架"] forState:UIControlStateNormal];
    cell.delegate = self;
    [cell.iconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:model.goods_thumb] placeholderImage:[UIImage imageNamed:@"默认"]];
    cell.titleLabel.text = model.goods_name;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.shop_price];
    cell.stockLabel.text = [NSString stringWithFormat:@"%@",model.goods_number];
    cell.sellCountLabel.text = [NSString stringWithFormat:@"%d",[model.total_sell_num intValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductListModel *model = [self.data objectAtIndex:indexPath.row];
    WebViewViewController *vc = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:nil];
    vc.title = @"商品详情";
    vc.type = WebType_GoodesDetail;
    vc.url = model.preview_url;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
