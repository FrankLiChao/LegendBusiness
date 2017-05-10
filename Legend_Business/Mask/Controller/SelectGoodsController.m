//
//  SelectGoodsController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/5.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "SelectGoodsController.h"
#import "MaskSelectGoodsCell.h"



@interface SelectGoodsController (){

   
}

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic)  int currentPage;
@end

@implementation SelectGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择商品";
    [self setBackButton];
    
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
    
    [self getGoodsList:_currentPage
             goodsType:ProuductListType_All
               success:^(NSArray<ProductListModel *> *array, NSInteger totalPage, NSInteger saleCount, NSInteger downCount) {
                   
                   if (totalPage<=weakSelf.currentPage) {
                       weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                   }
                   
                   weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
                   [weakSelf.tableView reloadData];
                   
                   [weakSelf.tableView.mj_header endRefreshing];
                   
               } failed:^(NSString *errorDes) {
                   
                   [weakSelf showHint:errorDes];
                   [weakSelf.tableView.mj_header endRefreshing];
               }];
    
}

- (void)loadData{

        __weak typeof(self) weakSelf = self;
    
    [self getGoodsList:_currentPage
             goodsType:ProuductListType_All
               success:^(NSArray<ProductListModel *> *array, NSInteger totalPage, NSInteger saleCount, NSInteger downCount) {
                   
                   [weakSelf.dataArray addObjectsFromArray:array];
                   [weakSelf.tableView reloadData];
                   [weakSelf.tableView.mj_footer endRefreshing];
                   
                   if (totalPage<=weakSelf.currentPage) {
                       weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                   }
                   
               } failed:^(NSString *errorDes) {
                   
                   [weakSelf showHint:errorDes];
                   [weakSelf.tableView.mj_footer endRefreshing];
                   
               }];
    
}


#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MaskSelectGoodsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MaskSelectGoodsCell"];
    
    ProductListModel *model =  model =[_dataArray objectAtIndex:indexPath.row];
    
    [cell.headImageView sd_setImageWithURL:[[NSURL alloc] initWithString:model.goods_thumb] placeholderImage:[UIImage imageNamed:@"默认"]];
    cell.desLabel.text = model.goods_name;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.shop_price?model.shop_price:@"0"];
    if ([model.is_prepare boolValue]) {
        cell.preSaleLabel.hidden = NO;
    }
    else cell.preSaleLabel.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    ProductListModel *model =  model =[_dataArray objectAtIndex:indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectGoods:) ]) {
        [self.delegate selectGoods:model];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
