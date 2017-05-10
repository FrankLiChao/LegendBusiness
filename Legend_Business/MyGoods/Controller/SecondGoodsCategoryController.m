//
//  SecondGoodsCategoryController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/2.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "SecondGoodsCategoryController.h"
#import "AddGoodsCell.h"


@interface SecondGoodsCategoryController (){


    NSIndexPath *selectIndex;
}
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@end

@implementation SecondGoodsCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    self.title = @"商品分类";
    
    _tableView.tableFooterView = [UIView new];
    
    
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
    
    selectIndex = indexPath;
    [tableView reloadData];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectGoodsCategoryModel:parentModel:)]){
    
        GoodsCategoryModel *model = [_dataArray objectAtIndex:indexPath.row];
        
        [self.delegate selectGoodsCategoryModel:model parentModel:_parentModel];
    }
    
    NSLog(@"%@",[self.navigationController viewControllers]);
    
    NSArray *vcArray = [self.navigationController viewControllers];
    
   [self.navigationController popToViewController:[vcArray objectAtIndex:vcArray.count - 3] animated:YES];
    
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
//    
    AddGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (!cell) {
        
       cell = [AddGoodsCell3 createCellWithNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (selectIndex == indexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    GoodsCategoryModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.myTitleLabel.text = model.cat_name;
    
    
    return cell;
    
}




@end
