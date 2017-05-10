//
//  MyGoodsListController.m
//  legend_business_ios
//
//  Created by heyk on 16/2/25.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "MyGoodsListController.h"
#import "legend_business_ios-swift.h"
#import "UIImageView+WebCache.h"
#import "ProductDetailsViewController.h"
#import "AddGoodsController.h"
#import "EditeGoodsController.h"
#import "AddPromotionController.h"
#import "StockWarningViewController.h"

@interface MyGoodsListController ()<GoodListCellDelegate,GoodsMoreViewDelegate,
UITableViewDataSource,
UITableViewDelegate>


@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) UIToolbar *toolBar;
@property (nonatomic, weak) UISegmentedControl *seg;

@property (nonatomic,strong)  NSMutableArray *warningArray;
@property (nonatomic,strong)  NSMutableArray *dataArray;
@property (nonatomic,strong)  NSMutableArray *downDataArray;

@property (nonatomic,strong)  NSMutableArray *searchResultArray;
@property (nonatomic) NSInteger   currentPage;

@end

@implementation MyGoodsListController

- (void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品库存";
    
    [self setBackButton];
    [self addRightBarItemWithTitle:@"添加" method:@selector(clickAddButton:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveAddNewGoodNotify) name:SYS_ADD_GOODS_SUCESS_NOTIFY object:nil];
    
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    self.toolBar = toolBar;
    [self.view addSubview:self.toolBar];
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"出售中",@"已下架"]];
    self.seg = seg;
    self.seg.selectedSegmentIndex = 0;
    [self.seg addTarget:self action:@selector(segValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.toolBar addSubview:self.seg];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(40, 0, 0, 0);
    [self.tableView registerClass:[GoodsListHeaderView class] forHeaderFooterViewReuseIdentifier:@"GoodsListHeaderView"];
    
    self.warningArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.downDataArray = [NSMutableArray array];
    
    self.searchResultArray = [NSMutableArray array];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    for (UIView *sub in self.navigationController.navigationBar.subviews) {
        for (UIView *subSub in sub.subviews) {
            if ([subSub isKindOfClass:[UIImageView class]] && subSub.frame.size.height == 0.5) {
                subSub.hidden = YES;
                return;
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (UIView *sub in self.navigationController.navigationBar.subviews) {
        for (UIView *subSub in sub.subviews) {
            if ([subSub isKindOfClass:[UIImageView class]] && subSub.frame.size.height == 0.5) {
                subSub.hidden = NO;
                return;
            }
        }
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.toolBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    self.seg.frame = CGRectMake(15, 5, CGRectGetWidth(self.toolBar.frame) - 30, CGRectGetHeight(self.toolBar.frame) - 10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Custom methods
- (void)refreshData {
    __weak __typeof(self)weakSelf = self;
    self.currentPage = 1;
    if (self.seg.selectedSegmentIndex == 0) {
        [self getGoodsList:self.currentPage goodsType:4 success:^(NSArray<ProductListModel *> *array1, NSInteger totalPage1, NSInteger saleCount1, NSInteger downCount1) {
            weakSelf.warningArray = [array1 mutableCopy];
            [weakSelf getGoodsList:self.currentPage goodsType:1 success:^(NSArray<ProductListModel *> *array, NSInteger totalPage, NSInteger saleCount, NSInteger downCount) {
                weakSelf.dataArray = [array mutableCopy];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
                
                if (totalPage == weakSelf.currentPage) {
                    weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                } else {
                    weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
                }
                [weakSelf.seg setTitle:[NSString stringWithFormat:@"出售中(%ld)", (long)saleCount] forSegmentAtIndex:0];
                [weakSelf.seg setTitle:[NSString stringWithFormat:@"已下架(%ld)", (long)downCount] forSegmentAtIndex:1];
            } failed:^(NSString *errorDes) {
                [weakSelf.tableView.mj_header endRefreshing];
            }];
        } failed:^(NSString *errorDes) {
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    } else {
        [self getGoodsList:self.currentPage goodsType:2 success:^(NSArray<ProductListModel *> *array, NSInteger totalPage, NSInteger saleCount, NSInteger downCount) {
            weakSelf.downDataArray = [array mutableCopy];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            
            if (totalPage == weakSelf.currentPage) {
                weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            } else {
                weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
            }
            [weakSelf.seg setTitle:[NSString stringWithFormat:@"出售中(%ld)", (long)saleCount] forSegmentAtIndex:0];
            [weakSelf.seg setTitle:[NSString stringWithFormat:@"已下架(%ld)", (long)downCount] forSegmentAtIndex:1];
        } failed:^(NSString *errorDes) {
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }
}

- (void)loadData{
    __weak __typeof(self)weakSelf = self;
    NSInteger goToPage = self.currentPage + 1;
    if (self.seg.selectedSegmentIndex == 0) {
        [self getGoodsList:goToPage
                 goodsType:1
                   success:^(NSArray<ProductListModel *> *array, NSInteger totalPage, NSInteger saleCount, NSInteger downCount) {
                       [weakSelf.dataArray addObjectsFromArray:array];
                       
                       weakSelf.currentPage = goToPage;
                       
                       [weakSelf.tableView reloadData];
                       [weakSelf.tableView.mj_footer endRefreshing];
                       
                       if (totalPage == weakSelf.currentPage) {
                           weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                       } else {
                           weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
                       }
                       [weakSelf.seg setTitle:[NSString stringWithFormat:@"出售中(%ld)", (long)saleCount] forSegmentAtIndex:0];
                       [weakSelf.seg setTitle:[NSString stringWithFormat:@"已下架(%ld)", (long)downCount] forSegmentAtIndex:1];
                   } failed:^(NSString *errorDes) {
                       [weakSelf.tableView.mj_footer endRefreshing];
                   }];
    } else {
        [self getGoodsList:goToPage
                 goodsType:2
                   success:^(NSArray<ProductListModel *> *array, NSInteger totalPage, NSInteger saleCount, NSInteger downCount) {
                       [weakSelf.downDataArray addObjectsFromArray:array];
                       
                       weakSelf.currentPage = goToPage;
                       
                       [weakSelf.tableView reloadData];
                       [weakSelf.tableView.mj_footer endRefreshing];
                       
                       if (totalPage == weakSelf.currentPage) {
                           weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                       } else {
                           weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
                       }
                       [weakSelf.seg setTitle:[NSString stringWithFormat:@"出售中(%ld)", (long)saleCount] forSegmentAtIndex:0];
                       [weakSelf.seg setTitle:[NSString stringWithFormat:@"已下架(%ld)", (long)downCount] forSegmentAtIndex:1];
                   } failed:^(NSString *errorDes) {
                       [weakSelf.tableView.mj_footer endRefreshing];
                   }];
    }
}

- (ProuductListType)currentListType{
    if (self.seg.selectedSegmentIndex == 0) {
        return ProuductListType_Selling;
    }
   return ProuductListType_Down;
}

- (void)segValueChanged:(UISegmentedControl*)seg{
    [self.tableView reloadData];
    [UIView animateWithDuration:0.25 animations:^{
        [self.tableView setContentOffset:CGPointMake(0, -40)];
    } completion:^(BOOL finished) {
        [self.tableView.mj_header beginRefreshing];
    }];
}

- (void)clickAddButton:(UIButton*)button{
    AddOrEditGoodsViewController *add = [[UIStoryboard storyboardWithName:@"Store" bundle:nil] instantiateViewControllerWithIdentifier:@"AddOrEditGoodsViewController"];
    [self.navigationController pushViewController:add animated:YES];
}


- (void)seeMoreWarning:(UIButton *)sender {
    StockWarningViewController *warning = [[UIStoryboard storyboardWithName:@"Store" bundle:nil] instantiateViewControllerWithIdentifier:@"StockWarningViewController"];
    [self.navigationController pushViewController:warning animated:YES];
}

#pragma mark - GoodListCellDelegate
- (void)goodsListCellTapEditBtnWithCell:(GoodListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ProductListModel *model = nil;
    if (self.seg.selectedSegmentIndex == 0) {
        if (indexPath.section == 0 && self.warningArray.count > 0) {
            model = [self.warningArray objectAtIndex:indexPath.row];
        } else {
            model = [self.dataArray objectAtIndex:indexPath.row];
        }
    } else {
        model = [self.downDataArray objectAtIndex:indexPath.row];
    }
    AddOrEditGoodsViewController *edit = [[UIStoryboard storyboardWithName:@"Store" bundle:nil] instantiateViewControllerWithIdentifier:@"AddOrEditGoodsViewController"];
    edit.goods_id = [model.goods_id integerValue];
    [self.navigationController pushViewController:edit animated:YES];
}

- (void)goodsListCellTapUpBtnWithCell:(GoodListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    __block ProductListModel *model = nil;
    __block NSMutableArray *array = nil;
    if (self.seg.selectedSegmentIndex == 0) {
        if (indexPath.section == 0 && self.warningArray.count > 0) {
            model = [self.warningArray objectAtIndex:indexPath.row];
            array = self.warningArray;
        } else {
            model = [self.dataArray objectAtIndex:indexPath.row];
            array = self.dataArray;
        }
    } else {
        model = [self.downDataArray objectAtIndex:indexPath.row];
        array = self.downDataArray;
    }
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
    if (self.seg.selectedSegmentIndex == 0) {
        if (indexPath.section == 0 && self.warningArray.count > 0) {
            model = [self.warningArray objectAtIndex:indexPath.row];
            array = self.warningArray;
        } else {
            model = [self.dataArray objectAtIndex:indexPath.row];
            array = self.dataArray;
        }
    } else {
        model = [self.downDataArray objectAtIndex:indexPath.row];
        array = self.downDataArray;
    }
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
    ProductListModel *model = nil;
    if (self.seg.selectedSegmentIndex == 0) {
        if (indexPath.section == 0 && self.warningArray.count > 0) {
            model = [self.warningArray objectAtIndex:indexPath.row];
        } else {
            model = [self.dataArray objectAtIndex:indexPath.row];
        }
    } else {
        model = [self.downDataArray objectAtIndex:indexPath.row];
    }
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Store" bundle:nil];
    AddPromotionController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"AddPromotionController"];
    vc.goodModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goodsListCellTapDeleteBtnWithCell:(GoodListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    __block ProductListModel *model = nil;
    __block NSMutableArray *array = nil;
    if (self.seg.selectedSegmentIndex == 0) {
        if (indexPath.section == 0 && self.warningArray.count > 0) {
            model = [self.warningArray objectAtIndex:indexPath.row];
            array = self.warningArray;
        } else {
            model = [self.dataArray objectAtIndex:indexPath.row];
            array = self.dataArray;
        }
    } else {
        model = [self.downDataArray objectAtIndex:indexPath.row];
        array = self.downDataArray;
    }
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

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.seg.selectedSegmentIndex == 0) {
        if (self.warningArray.count <= 0) {
            return 1;
        }
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.seg.selectedSegmentIndex == 0) {
        if (section == 0 && self.warningArray.count > 0) {
            return MIN(5, self.warningArray.count);
        }
        return self.dataArray.count;
    }
    return self.downDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.seg.selectedSegmentIndex == 0) {
        if (section == 0 && self.warningArray.count > 0) {
            return self.warningArray.count > 0 ? 30 : 0;
        }
        return self.dataArray.count > 0 ? 30 : 0;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.seg.selectedSegmentIndex == 0) {
        if (section == 0 && self.warningArray.count > 0) {
            if (self.warningArray.count > 5) {
                return 40;
            }
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.seg.selectedSegmentIndex == 0) {
        if (section == 0 && self.warningArray.count > 0) {
            if (self.warningArray.count > 5) {
                UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 40)];
                UIButton *seeMoreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                seeMoreBtn.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 30);
                seeMoreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                seeMoreBtn.backgroundColor = [UIColor clearColor];
                [seeMoreBtn setTintColor:[UIColor lightGrayColor]];
                [seeMoreBtn setTitle:@"查看全部库存预警商品 >" forState:UIControlStateNormal];
                [seeMoreBtn addTarget:self action:@selector(seeMoreWarning:) forControlEvents:UIControlEventTouchUpInside];
                [footer addSubview:seeMoreBtn];
                return footer;
            }
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GoodsListHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"GoodsListHeaderView"];
    if (section == 0 && self.warningArray.count > 0) {
        header.isWarning = YES;
    } else {
        header.isWarning = NO;
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ProductListModel *model = nil;
    if (self.seg.selectedSegmentIndex == 0) {
        if (indexPath.section == 0 && self.warningArray.count > 0) {
            model = [self.warningArray objectAtIndex:indexPath.row];
            cell.preSaleLabel.hidden = NO;
        } else {
            model = [self.dataArray objectAtIndex:indexPath.row];
            cell.preSaleLabel.hidden = YES;
        }
        [cell.downBtn setTitle:@"下架" forState:UIControlStateNormal];
        [cell.downBtn setImage:[UIImage imageNamed:@"下架"] forState:UIControlStateNormal];
    } else {
        model = [self.downDataArray objectAtIndex:indexPath.row];
        cell.preSaleLabel.hidden = YES;
        [cell.downBtn setTitle:@"上架" forState:UIControlStateNormal];
        [cell.downBtn setImage:[UIImage imageNamed:@"上架"] forState:UIControlStateNormal];
    }
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
    ProductListModel *model = nil;
    if (self.seg.selectedSegmentIndex == 0) {
        if (indexPath.section == 0 && self.warningArray.count > 0) {
            model = [self.warningArray objectAtIndex:indexPath.row];
        } else {
            model = [self.dataArray objectAtIndex:indexPath.row];
        }
    } else {
        model = [self.downDataArray objectAtIndex:indexPath.row];
    }
    WebViewViewController *vc = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:nil];
    vc.title = @"商品详情";
    vc.type = WebType_GoodesDetail;
    vc.url = model.preview_url;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark notify
- (void)recieveAddNewGoodNotify{
    [self.tableView.mj_header beginRefreshing];
}


@end
