//
//  TypeSelectController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/7.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "TypeSelectController.h"
#import "AddGoodsCell.h"
#import "PromotionModel.h"

@interface TypeSelectController ()

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)id selectModel;

@end

@implementation TypeSelectController

- (void)dealloc{
    
    NSLog(@"FirstGoddsCategoryController 释放");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    
    if (_type == SelectViewType_StoryType){
        self.title = @"选择经营类目";
        [self addRightBarItemWithTitle:@"保存" method:@selector(clickSave:)];
        
        [self showHudInView:self.view hint:@""];
        
        __weak __typeof(self)weakSelf = self;
        
        [self getSellerCategoryList:^(NSArray<SellerCategoryModel *> *array) {
  
            [weakSelf hideHud];
            weakSelf.dataArray = array;
            [weakSelf.tableView reloadData];
            
        } failed:^(NSString *errorDes) {
            [self hideHud];
        }];
        
        
    }
    else if(_type == SelectViewType_Adv){
        self.title = @"选择广告类型";
        
        CategoryModel *model = [CategoryModel new];
        model.cat_id = [NSNumber numberWithInt:AdvType_Share];
        model.cat_name = @"分享类广告";
        
        CategoryModel *model1 = [CategoryModel new];
        model1.cat_id = [NSNumber numberWithInt:AdvType_Answer];
        model1.cat_name = @"问答类广告";
        
        self.dataArray = [NSArray arrayWithObjects:model,model1, nil];
        
        
    }
    
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickSave:(UIButton*)button{
    if (_type == SelectViewType_StoryType) {
        if (self.selectModel) {
            __weak typeof(self) weakSelf = self;
            [self showHint:@"保存中"];
            [self changeUsrInfo:ChangeUserInfoType_Category
                          value:((SellerCategoryModel*)_selectModel).seller_cat_id
                         comple:^(BOOL bSuccess, NSString *message) {
                             [weakSelf hideHud];
                             if (bSuccess) {
                                 [weakSelf showHint:@"修改成功"];
                                 if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(selectTypeModel:)]){
                                     
                                     [weakSelf.delegate selectTypeModel:weakSelf.selectModel];
                                 }
                                 [weakSelf.navigationController popViewControllerAnimated:YES];
                             } else {
                                 [weakSelf showHint:message];
                             }
                         }];
        } else {
            [self showHint:@"请选择经营类目"];
        }
    }
}

#pragma mark tableVIew delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _dataArray.count - 1) {
        return 44;
    }
    return 45;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    id model = [_dataArray objectAtIndex:indexPath.row];
    self.selectModel = model;
    
    

    if (_type == SelectViewType_Adv) {
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(selectTypeModel:)]){
            
            [self.delegate selectTypeModel:model];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        
        [tableView reloadData];
        
    }


}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *cellIdentifier = @"AddGoodsCell3";
    if (indexPath.row == _dataArray.count - 1) {
        cellIdentifier = @"AddGoodsCell2";
    }
    
    AddGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (!cell) {
        
        if (indexPath.row == _dataArray.count - 1) {
            cell = [AddGoodsCell9 createCellWithNib];
        }
        else{
            
            cell = [AddGoodsCell10 createCellWithNib];
        }
        
    }
    
    if (_type == SelectViewType_StoryType) {
        SellerCategoryModel *model = [_dataArray objectAtIndex:indexPath.row];
        cell.myTitleLabel.text = model.seller_cat_name;
    }
    else {
        CategoryModel *model = [_dataArray objectAtIndex:indexPath.row];
        cell.myTitleLabel.text = model.cat_name;
    
    }
    if (_selectModel == [_dataArray objectAtIndex:indexPath.row]) {
       cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
    
}


@end



