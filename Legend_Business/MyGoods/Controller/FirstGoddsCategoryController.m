//
//  FirstGoddsCategoryController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/2.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "FirstGoddsCategoryController.h"
#import "AddGoodsCell.h"
#import "SecondGoodsCategoryController.h"


@interface FirstGoddsCategoryController ()<SecondGoodsCategoryControllerDelegate>

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArray;

@end

@implementation FirstGoddsCategoryController

- (void)dealloc{

    NSLog(@"FirstGoddsCategoryController 释放");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    self.title = @"商品分类";
    
    _tableView.tableFooterView = [UIView new];
    
    
    
    [self showHudInView:self.view hint:@""];
    
    __weak __typeof(self)weakSelf = self;
    
    [self getGoodCategoryList:^(NSArray<GoodsCategoryModel *> *array) {
      
        [weakSelf hideHud];
         weakSelf.dataArray = array;
        [weakSelf.tableView reloadData];
        
    } failed:^(NSString *errorDes) {
          [self hideHud];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark tableVIew delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _dataArray.count - 1) {
        return 44;
    }
    return 45;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GoodsCategoryModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    SecondGoodsCategoryController *vc = [[SecondGoodsCategoryController alloc] initWithNibName:@"SecondGoodsCategoryController" bundle:nil];
    vc.delegate = self;
    vc.dataArray = model.child;
    vc.parentModel = model;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *cellIdentifier = @"AddGoodsCell3";
//    if (indexPath.row == _dataArray.count - 1) {
//        cellIdentifier = @"AddGoodsCell2";
//    }
    
    AddGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (!cell) {
        
//        if (indexPath.row == _dataArray.count - 1) {
//             cell = [AddGoodsCell2 createCellWithNib];
//        }
//        else{
        
            cell = [AddGoodsCell3 createCellWithNib];
        //}
        
    }
    
    GoodsCategoryModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.myTitleLabel.text = model.cat_name;

    return cell;
    
}

//SecondGoodsCategoryControllerDelegate
-(void)selectGoodsCategoryModel:(GoodsCategoryModel*)model1 parentModel:(GoodsCategoryModel*)model2{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectGoodsCategoryModel:parentModel:)]){
        
        [self.delegate selectGoodsCategoryModel:model1 parentModel:model2];
    }
}

@end
