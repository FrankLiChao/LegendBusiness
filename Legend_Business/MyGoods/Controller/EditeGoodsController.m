//
//  EditeGoodsController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/4.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "EditeGoodsController.h"
#import "AddGoodsCell.h"
#import "CustomUploadImageView.h"
#import "FirstGoddsCategoryController.h"
#import "GoodsDescribeController.h"
#import "GoodsPictureViewController.h"
#import "ProductModel.h"
#import "UIImage+Scale.h"

#define AddGoods_FirstRow @"AddGoods_FirstRow" //第一行
#define AddGoods_Category @"AddGoods_Category" //商品分类
#define AddGoods_Describe @"AddGoods_Describe" //商品描述
#define AddGoods_PicDetail @"AddGoods_PicDetail" //图文详情
#define AddGoods_SellerTip @"AddGoods_SellerTip" //商家提示
#define AddGoods_Default_Spec @"AddGoods_Default_Spec" //默认商品属性
#define AddGoods_Spec @"AddGoods_Spec" //规格
#define AddGoods_FanDian @"AddGoods_FanDian" //返点
#define AddGoods_Add_Spec @"AddGoods_Add_Spec"//添加商品规格
#define AddGoods_Pre_Sale_Switch @"AddGoods_Pre_Sale_Switch"//预售
#define AddGoods_Pre_Sale_Day @"AddGoods_Pre_Sale_Day"//预售时间


typedef enum {
    
    GoodType_Severce = 47,//服务类
    GoodType_Normal = 49,//普通商品
    
    
}GoodType;//商品分类



@interface EditeGoodsController ()<
AddGoodsCellDelegate,
FirstGoddsCategoryControllerDelegate,
GoodsDescribeControllerDelegate,
GoodsPictureViewControllerDelegate,
UIAlertViewDelegate>{
    
    GoodType selectGoodsType;//当前选中的商品类型
    
    NSInteger sectionNum;
    
   
    BOOL bOpen_pre_sale;//是否开启了预售
}

@property (nonatomic,strong)NSMutableDictionary *cellViewDic;

@property (nonatomic,strong)GoodsCategoryModel *selectGoodFirstGategory;//第一级
@property (nonatomic,strong)GoodsCategoryModel *selectGoodChildGategory;//子级
@property (nonatomic,strong)NSString *goodsDes;//商品描述
@property (nonatomic,strong)NSString *sellerNotice;//商家提示
@property (nonatomic,strong)NSMutableArray<CustomUploadImageView*> *currentGoodPicViews;//商品图文详情
@property (nonatomic,strong)NSMutableArray *specArray;//规格信息数组

@property (nonatomic,strong)NSString *goodsId;
@property (nonatomic,strong) UIButton *currentEidteImageButton;//正在编辑的图片
@property (nonatomic,strong) NSString *goodsthumb;


@end

@implementation EditeGoodsController


+ (EditeGoodsController*)createWithEditModel:(NSString*)goodsId;
{
    
    EditeGoodsController *vc =  [[EditeGoodsController alloc] initWithNibName:@"EditeGoodsController" bundle:nil];
    
    if (vc) {
        
        vc.goodsId = goodsId;
    }
    
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    self.title = @"添加商品";
    
    self.specArray = [NSMutableArray array];
    self.cellViewDic = [NSMutableDictionary dictionary];
    self.currentGoodPicViews = [NSMutableArray array];
    
    
    _footView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [Configure SYS_UI_BUTTON_HEIGHT] + 20);
    _saveButton.titleLabel.font = [Configure SYS_UI_BUTTON_FONT];
    [UitlCommon setFlatWithView:_saveButton radius:[Configure   SYS_CORNERRADIUS]];
    
    
    sectionNum = 6;
    
    [self showHudInView:self.view hint:@""];
    
    __weak __typeof(self)weakSelf = self;
    [self getGoodInfo:self.goodsId
              success:^(ProductDetailModel *model) {
                  [weakSelf hideHud];
                  [weakSelf initUIWithModel:model];
                  
              } failed:^(NSString *errorDes) {
                  [weakSelf hideHud];
                  [weakSelf showHint:errorDes];
              }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initUIWithModel:(ProductDetailModel*)model{

    
    AddGoodsCell1 *cell1 = [AddGoodsCell1 createCellWithNib];
    cell1.delegate = self;
    cell1.titleField.text = model.goods_name;

    if (model.goods_img) {
        CustomUploadImageView *view = [CustomUploadImageView createDownImageView:model.goods_img tag:cell1.homePageImageView];
        
        view.tag = 1;
        view.bHiddenDeleteButton = YES;
        view.userInteractionEnabled = NO;
        
        [cell1.homePageImageView.subviews enumerateObjectsUsingBlock:^( UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag == 1) {
                [obj removeFromSuperview];
                *stop = YES;
            }
        }];
        
        [cell1.homePageImageView addSubview:view];
        [view autoPinEdgesToSuperviewEdges];
        
        [view autoSetDimension:ALDimensionHeight toSize:60];
        [view autoSetDimension:ALDimensionWidth toSize:60];
    }
    
    if (model.gallery_img && model.gallery_img.count>0) {
        NSString *url = [model.gallery_img lastObject];
        
        CustomUploadImageView *view = [CustomUploadImageView createDownImageView:url tag:cell1.coverpImageView];
        view.tag = 1;
        view.bHiddenDeleteButton = YES;
        view.userInteractionEnabled = NO;
        
        [cell1.coverpImageView.subviews enumerateObjectsUsingBlock:^( UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag == 1) {
                [obj removeFromSuperview];
                *stop = YES;
            }
        }];
        
        [cell1.coverpImageView addSubview:view];
        [view autoPinEdgesToSuperviewEdges];
        
        [view autoSetDimension:ALDimensionHeight toSize:60];
        [view autoSetDimension:ALDimensionWidth toSize:60];
    }
    [_cellViewDic setObject:cell1 forKey:AddGoods_FirstRow];
    
    self.goodsthumb = model.goods_thumb;
    
    self.selectGoodFirstGategory = [GoodsCategoryModel new];
    _selectGoodFirstGategory.cat_id = model.parent_id;
    
    self.selectGoodChildGategory = [GoodsCategoryModel new];
    _selectGoodChildGategory.cat_id = model.cat_id;
    _selectGoodChildGategory.cat_name = model.cat_name;
    
    self.goodsDes = model.goods_brief;
    self.sellerNotice = model.goods_tips;
    
    for (NSString *url in model.goods_desc) {
        
        CustomUploadImageView *imageV = [CustomUploadImageView createDownImageView:url tag:nil];
        [_currentGoodPicViews addObject:imageV];
    }
    
    if (![UitlCommon isNull:[NSString stringWithFormat:@"%@",model.shop_price]]) {
        
        AddGoodsCell5 *cell5 = [AddGoodsCell5 createCellWithNib];
        [_cellViewDic setObject:cell5 forKey:AddGoods_Default_Spec];
     
        cell5.priceField.text = [NSString stringWithFormat:@"%@",model.shop_price];
        cell5.stockField.text = [NSString stringWithFormat:@"%@",model.goods_number];
    }
    
    
   AddGoodsCell7* cell7 = [AddGoodsCell7 createCellWithNib];
    cell7.sperateLine.hidden = YES;
    cell7.contentField.placeholder = @"10";
    [_cellViewDic setObject:cell7 forKey:AddGoods_FanDian];
    cell7.contentField.text = [NSString stringWithFormat:@"%@", model.share_money? model.share_money:@""];
   
    
    if ([model.is_prepare boolValue] ) {
        bOpen_pre_sale = YES;
        
        AddGoodsCell8 *cell8 = [AddGoodsCell8 createCellWithNib];
        cell8.delegate = self;
        cell8.control.on = YES;
        [_cellViewDic setObject:cell8 forKey:AddGoods_Pre_Sale_Switch];
        
    }
    else{//预售天数
        
        AddGoodsCell7 *cell9 = [AddGoodsCell7 createCellWithNib];
        cell9.myTitleLabel.text = @"时间";
        cell9.contentField.placeholder = @"10天";
        [_cellViewDic setObject:cell9 forKey:AddGoods_Pre_Sale_Day];
        double day = [model.prepare_time doubleValue]/24.0*60>60;
        cell9.contentField.text = [NSString stringWithFormat:@"%0.1f",day];
        
    }
    
    
    
    for (ProductAttrModel *attr in model.goods_size) {
        
        AddGoodsCell4 *cell = [AddGoodsCell4 createCellWithNib];;
        cell.delegate = self;
        cell.specsField.text = attr.attr_name;
        cell.attrId = attr.attr_id;
        cell.priceField.text = [NSString stringWithFormat:@"%@",attr.price];
        cell.stockField.text = [NSString stringWithFormat:@"%@",attr.goods_number];
        [self.specArray addObject:cell];
    }
    
    [self refreshSectionNum];
    [self.tableView reloadData];

}
#pragma mark custom methods

- (IBAction)clikSaveButton:(id)sender{
    
    [UitlCommon closeAllKeybord];
    
    AddGoodsCell1 *cell1 = [_cellViewDic objectForKey:AddGoods_FirstRow];
    float minPrice = 0;
    
    if ([UitlCommon isNull:cell1.titleField.text]) {
        
        [self showHint:@"请添加商品标题"];
        return;
    }
    
    if (!cell1.homePageImage) {
        [self showHint:@"请添加首页图"];
        return;
    }
    if (cell1.homePageImage.status == ImageUploadStatus_Uploading) {
        [self showHint:@"首页图还没有上传完成，请稍后"];
        return;
    }
    if (cell1.homePageImage.status == ImageUploadStatus_Failed) {
        [self showHint:@"首页图上传失败，请重新上传"];
        return;
    }
    
    if (!cell1.coverImage) {
        [self showHint:@"请添加封面图"];
        return;
    }
    if (cell1.coverImage.status == ImageUploadStatus_Uploading|| [UitlCommon isNull:self.goodsthumb]) {
        [self showHint:@"封面图还没有上传完成，请稍后"];
        return;
    }
    if (cell1.coverImage.status == ImageUploadStatus_Failed) {
        [self showHint:@"封面图上传失败，请重新上传"];
        return;
    }
    
    
    if (!self.selectGoodFirstGategory || !self.selectGoodChildGategory) {
        [self showHint:@"请选择产品分类"];
        return;
    }
    
    
    if (!self.currentGoodPicViews || self.currentGoodPicViews.count == 0) {
        [self showHint:@"请添加图文详情"];
        return;
    }
    
    if ([self showSellerTip] && [UitlCommon isNull:_sellerNotice]) {
        [self showHint:@"请添加商家提示"];
        return;
    }
    
    
    float price = 0.0;
    int stock = 0;
    
    NSMutableArray *spesArray = [NSMutableArray array];
    
    if (self.specArray.count>0) {
        
        for (AddGoodsCell4 *cell in self.specArray) {
            
            if ([cell.priceField.text floatValue]<minPrice || minPrice == 0) {
                
                minPrice = [cell.priceField.text floatValue];
            }
            
            if ([UitlCommon isNull:cell.priceField.text]) {
                [self showHint:@"请完善商品价格"];
                return;
            }
            
            if ([UitlCommon isNull:cell.stockField.text]) {
                [self showHint:@"请完善商品库存"];
                return;
            }
            if ([UitlCommon isNull:cell.specsField.text]) {
                [self showHint:@"请完善商品规格"];
                return;
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:cell.priceField.text,@"price",cell.stockField.text,@"goods_number",cell.specsField.text,@"attr_name", nil];
            if (cell.attrId) {
                [dic setObject:cell.attrId forKey:@"attr_id"];
            }
            [spesArray addObject:dic];
        }
    }
    else{
        AddGoodsCell5 *cell5 = [_cellViewDic objectForKey:AddGoods_Default_Spec];
        
        minPrice = [cell5.priceField.text floatValue];
        price = [cell5.priceField.text floatValue];
        stock = [cell5.stockField.text intValue];
        
        
        if ([UitlCommon isNull:cell5.priceField.text]||price<0) {
            [self showHint:@"请添加正确商品价格，商品价格应不小于0元"];
            return;
        }
        
        if ([UitlCommon isNull:cell5.stockField.text]||stock<=0) {
            [self showHint:@"请添加正确的库存商品库存，库存数量应不小于等于0件"];
            return;
        }
        
    }
    
    
    AddGoodsCell7 *cell6 = [_cellViewDic objectForKey:AddGoods_FanDian];
    if ([cell6.contentField.text floatValue]>minPrice) {
        [self showHint:@"请填写正确的返点数，返点数大于了商品单价"];
        return;
    }
    
    AddGoodsCell7 *cell7 = [_cellViewDic objectForKey:AddGoods_Pre_Sale_Day];
    
    if(bOpen_pre_sale){//开启了预售
        
        if([UitlCommon isNull:cell7.contentField.text]|| [cell7.contentField.text intValue]<=0){
            
            [self showHint:@"请填正确的预售时间，时间必须大于等于1天"];
            return;
        }
    }
    
    
    NSMutableArray *goodsPics = [NSMutableArray array];
    for (CustomUploadImageView *view in  _currentGoodPicViews) {
        [goodsPics addObject:view.url];
    }
    
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:@"添加中，请稍后"];
    [self editGoods:self.goodsId goodsName:cell1.titleField.text categoryId:self.selectGoodChildGategory.cat_id price:price goodsNum:stock shareMoney:[cell6.contentField.text floatValue] goodsBrief:_goodsDes goodsPicDes:goodsPics galleryImage:nil goodsImage:cell1.homePageImage.url goodsThumb:self.goodsthumb attrList:spesArray isPrepare:bOpen_pre_sale prepareTime:[cell7.contentField.text floatValue]*24*60*60 sellerTip:_sellerNotice isEndorse:NO shippingFee:@"" shippingFree:@"" success:^(NSString *goodId) {
        [weakSelf hideHud];
        [weakSelf showHint:@"修改商品成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:SYS_ADD_GOODS_SUCESS_NOTIFY object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failed:^(NSString *errorDes) {
        [weakSelf hideHud];
        [weakSelf showHint:errorDes];
    }];
}

- (void)refreshSectionNum{
    
    if([self showOpenPreSale]){//开启预售
        
        sectionNum =  6 + (self.specArray.count>0 ? self.specArray.count : 1);
        
    }
    else{
        sectionNum = 5 + (self.specArray.count>0 ? self.specArray.count : 1);
    }
}

/**
 *  规格信息行数
 *
 *  @return
 */
- (NSInteger)specCellCount{
    
    if (self.specArray.count>0) {
        return self.specArray.count;
    }
    return 1;
}

/**
 *  根据当前cell的index获取cell在specArray中的index
 *
 *  @param index cell在specArray中的index
 *
 *  @return
 */
- (NSInteger)customSpecIndex:(NSIndexPath*)index{
    
    NSInteger currentIndex = index.section - 3;
    
    return currentIndex;
}

/**
 *  是否显示预售
 *
 *  @return
 */
- (BOOL)showOpenPreSale{
    
    if([self.selectGoodFirstGategory.cat_id intValue] == GoodType_Normal){
        return YES;
    }
    else return NO;
}

/**
 *  是否显示商家提示
 *
 *  @return
 */
- (BOOL)showSellerTip{
    
    if([self.selectGoodFirstGategory.cat_id intValue] == GoodType_Severce){
        return YES;
    }
    else return NO;
}

#pragma mark tableVIew delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) { return [Configure SYS_UI_SCALE:128];}
    else if(indexPath.section == 1){  return [Configure SYS_UI_SCALE:44];}
    else if(indexPath.section == 2){  return [Configure SYS_UI_SCALE:44];}
    else if(indexPath.section == 3 + [self specCellCount]){  return [Configure SYS_UI_SCALE:44];}//添加商品规格
    else if(indexPath.section == 4 + [self specCellCount]){  return [Configure SYS_UI_SCALE:44];}//返点
    else if(indexPath.section == 5 + [self specCellCount]){  return [Configure SYS_UI_SCALE:44];}//预售
    else  {
        return  [Configure SYS_UI_SCALE:90];}
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0){return 0;}
    
    else if(section ==  3 + [self specCellCount]){
        return 0;
    }
    else if (section == 4 + [self specCellCount]){
        return 0;
    }
    
    return [Configure SYS_UI_SCALE:10];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [UitlCommon closeAllKeybord];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 1 && indexPath.row == 0) {//商品分类
        FirstGoddsCategoryController *vc = [[FirstGoddsCategoryController alloc] initWithNibName:@"FirstGoddsCategoryController" bundle:nil];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {//商品描述
        
        GoodsDescribeController *vc =  [[GoodsDescribeController alloc] initWithNibName:@"GoodsDescribeController" bundle:nil];
        vc.contentTag = [tableView cellForRowAtIndexPath:indexPath];
        vc.delegate = self;
        vc.strTitle = @"商品描述";
        vc.content = _goodsDes;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.section == 2 && indexPath.row == 0 ){//图文详情
        
        GoodsPictureViewController *vc = [[GoodsPictureViewController alloc] initWithNibName:@"GoodsPictureViewController" bundle:nil];
        vc.delegate = self;
        vc.currentPicsView = [NSMutableArray arrayWithArray:self.currentGoodPicViews];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.section == 2 && indexPath.row == 1 ){//商家提示
        
        
        GoodsDescribeController *vc =  [[GoodsDescribeController alloc] initWithNibName:@"GoodsDescribeController" bundle:nil];
        vc.delegate = self;
        vc.strTitle = @"商家提示";
        vc.content = _sellerNotice;
        vc.contentTag = [tableView cellForRowAtIndexPath:indexPath];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}



#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return sectionNum;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) { return 1;}
    else if(section == 1){  return 2;}
    else if(section == 2){
        
        if ([self showSellerTip]) {
            return 2;
        }
        return 1;
    }
    else if(section == 3 + [self specCellCount]){ return 1;}//添加商品规格
    else if(section == 4 + [self specCellCount]){  return 1;}//返点
    else if(section == 5 + [self specCellCount]){//预售
        
        if (bOpen_pre_sale) {
            return 2;
        }
        return 1;
    }
    else return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0) {//商品title
        
        AddGoodsCell *cell = [_cellViewDic objectForKey:AddGoods_FirstRow];
        
        
        if (!cell) {
            cell = [AddGoodsCell1 createCellWithNib];
            cell.delegate = self;
            
            [_cellViewDic setObject:cell forKey:AddGoods_FirstRow];
        }
        
        return cell;
        
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {//商品分类
        
        AddGoodsCell *cell = [_cellViewDic objectForKey:AddGoods_Category];
        
        if (!cell) {
            
            cell = [AddGoodsCell3 createCellWithNib];
            [_cellViewDic setObject:cell forKey:AddGoods_Category];
        }
        
        cell.myTitleLabel.text = @"商品分类";
        
        cell.myDetailLabel.text = self.selectGoodChildGategory.cat_name?self.selectGoodChildGategory.cat_name:@"未添加";
        
        return cell;
        
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {//商品描述
        
        
        AddGoodsCell *cell = [_cellViewDic objectForKey:AddGoods_Describe];
        
        if (!cell) {
            cell = [AddGoodsCell2 createCellWithNib];
            [_cellViewDic setObject:cell forKey:AddGoods_Describe];
        }
        cell.myTitleLabel.text = @"商品描述";
        if (![UitlCommon isNull:self.goodsDes]) {
            cell.myDetailLabel.text = @"已添加";
        }
        else {
            cell.myDetailLabel.text = @"未添加";
        }
        
        return cell;
        
    }
    else  if (indexPath.section == 2 && indexPath.row == 0){//图文详情
        
        AddGoodsCell *cell = [_cellViewDic objectForKey:AddGoods_PicDetail];
        
        if (!cell) {
            cell = [AddGoodsCell3 createCellWithNib];
            [_cellViewDic setObject:cell forKey:AddGoods_PicDetail];
            
        }
        cell.myTitleLabel.text = @"图文详情";
        if (self.currentGoodPicViews && self.currentGoodPicViews.count>0) {
            cell.myDetailLabel.text = @"已添加";
        }
        else {
            cell.myDetailLabel.text = @"未添加";
        }
        
        return cell;
        
    }
    
    else  if (indexPath.section == 2 && indexPath.row == 1){//商家提示
        
        
        AddGoodsCell *cell = [_cellViewDic objectForKey:AddGoods_SellerTip];
        
        
        if (!cell) {
            cell = [AddGoodsCell2 createCellWithNib];
            [_cellViewDic setObject:cell forKey:AddGoods_SellerTip];
            
        }
        cell.myTitleLabel.text = @"商家提示";
        if (![UitlCommon isNull:_sellerNotice ]) {
            cell.myDetailLabel.text = @"已添加";
        }
        else {
            cell.myDetailLabel.text = @"未添加";
        }
        
        return cell;
        
    }
    
    else if(indexPath.section == (3 + [self specCellCount])){//添加商品规格
        AddGoodsCell *cell = [_cellViewDic objectForKey:AddGoods_Add_Spec];
        if (!cell) {
            cell = [AddGoodsCell6 createCellWithNib];
            cell.delegate = self;
            [_cellViewDic setObject:cell forKey:AddGoods_Add_Spec];
        }
        return cell;
    }
    else if(indexPath.section == (4 + [self specCellCount])){//返点
        
        AddGoodsCell7 *cell = [_cellViewDic objectForKey:AddGoods_FanDian];
        if (!cell) {
            cell = [AddGoodsCell7 createCellWithNib];
            cell.sperateLine.hidden = YES;
            cell.contentField.placeholder = @"10";
            [_cellViewDic setObject:cell forKey:AddGoods_FanDian];
        }
        return cell;
    }
    else if(indexPath.section == (5 + [self specCellCount])){//预售
        
        if(indexPath.row == 0){//显示预算开关
            AddGoodsCell *cell = [_cellViewDic objectForKey:AddGoods_Pre_Sale_Switch];
            if (!cell) {
                cell = [AddGoodsCell8 createCellWithNib];
                cell.delegate = self;
                [_cellViewDic setObject:cell forKey:AddGoods_Pre_Sale_Switch];
            }
            return cell;
            
        }
        else{//预售天数
            
            AddGoodsCell7 *cell = [_cellViewDic objectForKey:AddGoods_Pre_Sale_Day];
            if (!cell) {
                cell = [AddGoodsCell7 createCellWithNib];
                cell.myTitleLabel.text = @"时间";
                cell.contentField.placeholder = @"10天";
                [_cellViewDic setObject:cell forKey:AddGoods_Pre_Sale_Day];
            }
            return cell;
            
        }
    }
    else{//商品规格
        
        if(self.specArray.count>0){
            
            
            NSInteger index = [self customSpecIndex:indexPath];
            
            AddGoodsCell *cell = [self.specArray objectAtIndex:index];
            cell.delegate = self;
            return cell;
            
        }
        else{//默认规格
            
            AddGoodsCell *cell = [_cellViewDic objectForKey:AddGoods_Default_Spec];
            if (!cell) {
                cell = [AddGoodsCell5 createCellWithNib];
                [_cellViewDic setObject:cell forKey:AddGoods_Default_Spec];
            }
            return cell;
        }
        
        
    }
    
    
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}



#pragma mark AddGoodsCell delegate


- (void)clickAddHomePageImage{
    
    AddGoodsCell1 *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    
    _currentEidteImageButton = cell.homePageImageView;
    
    __weak typeof(self) weakSelf = self;
    
    [self takePicWithScale:288.0/640 selectBlock:^(UIImage *image) {
        
        if (image) {
            CustomUploadImageView *view = [CustomUploadImageView createUploadImageView:image
                                                                                  type:UploadImageType_Edit
                                                                                   tag:weakSelf.currentEidteImageButton
                                                                            uploadDone:^(NSString *url, UIImage *image, id tag) {
                                                                                
                                                                            }];
            
            
            view.tag = 1;
            view.bHiddenDeleteButton = YES;
            view.userInteractionEnabled = NO;
            
            
            [weakSelf.currentEidteImageButton.subviews enumerateObjectsUsingBlock:^( UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.tag == 1) {
                    [obj removeFromSuperview];
                    *stop = YES;
                }
            }];
            
            
            [weakSelf.currentEidteImageButton addSubview:view];
            [view autoPinEdgesToSuperviewEdges];
            
            [view autoSetDimension:ALDimensionHeight toSize:60];
            [view autoSetDimension:ALDimensionWidth toSize:60];

        }
    }];
    
    
    
    
}
- (void)clickAddCoverImage{
    
    
    AddGoodsCell1 *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    _currentEidteImageButton = cell.coverpImageView;
    
    __weak typeof(self) weakSelf = self;
    
    [self takeEditPick:^(UIImage *image) {
        
        if (image) {
            
            weakSelf.goodsthumb = nil;
            
            UIImage *scaleImage = [image scaleToSize:CGSizeMake(200, 200)];
            
            [CustomUploadImageView createUploadImageView:scaleImage
                                                    type:UploadImageType_Edit
                                                     tag:nil
                                              uploadDone:^(NSString *url, UIImage *image, id tag) {
                                                  
                                                  weakSelf.goodsthumb = url;
                                              }];
            
            
            CustomUploadImageView *view = [CustomUploadImageView createUploadImageView:image
                                                                                  type:UploadImageType_Edit
                                                                                   tag:weakSelf.currentEidteImageButton
                                                                            uploadDone:^(NSString *url, UIImage *image, id tag) {
                                                                                
                                                                            }];
            
            
            view.tag = 1;
            view.bHiddenDeleteButton = YES;
            view.userInteractionEnabled = NO;
            
            
            [weakSelf.currentEidteImageButton.subviews enumerateObjectsUsingBlock:^( UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.tag == 1) {
                    [obj removeFromSuperview];
                    *stop = YES;
                }
            }];
            
            
            [weakSelf.currentEidteImageButton addSubview:view];
            [view autoPinEdgesToSuperviewEdges];
            
            [view autoSetDimension:ALDimensionHeight toSize:60];
            [view autoSetDimension:ALDimensionWidth toSize:60];
            
        }
    }];
}

- (void)deleteAttributionCell{
    
}
- (void)addNewAttributin{
    
    AddGoodsCell *cell = [AddGoodsCell4 createCellWithNib];
    [self.specArray addObject:cell];
    
    [self refreshSectionNum];
    [self.tableView reloadData];
    
}
- (void)deleteAttributionCell:(AddGoodsCell*)cell{
    
    
    if ([self.specArray containsObject:cell]) {
        
        [self.specArray removeObject:cell];
    }
    [self refreshSectionNum];
    [self.tableView reloadData];
}


- (void)switchValueChanged:(BOOL)bOpen{
    bOpen_pre_sale = bOpen;
    [self.tableView reloadData];
    
}
//#pragma mark UIImagePickerController delegate
//
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    
//    UIImage *editeImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    
//    NSLog(@"w = %f,h = %f",editeImage.size.width,editeImage.size.height);
//    
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    
//    CustomUploadImageView *view = [CustomUploadImageView createUploadImageView:editeImage
//                                                                          type:UploadImageType_Edit
//                                                                           tag:currentEidteImageButton
//                                                                    uploadDone:^(NSString *url, UIImage *image, id tag) {
//                                                                        
//                                                                    }];
//    
//    
//    view.tag = 1;
//    view.bHiddenDeleteButton = YES;
//    view.userInteractionEnabled = NO;
//    
//    
//    [currentEidteImageButton.subviews enumerateObjectsUsingBlock:^( UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.tag == 1) {
//            [obj removeFromSuperview];
//            *stop = YES;
//        }
//    }];
//    
//    
//    [currentEidteImageButton addSubview:view];
//    [view autoPinEdgesToSuperviewEdges];
//    
//    [view autoSetDimension:ALDimensionHeight toSize:60];
//    [view autoSetDimension:ALDimensionWidth toSize:60];
//    
//    
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//
#pragma mark FirstGoddsCategoryControllerDelegate
-(void)selectGoodsCategoryModel:(GoodsCategoryModel*)model parentModel:(GoodsCategoryModel*)parentModel{
    
    //类有修改
    if (self.selectGoodChildGategory && ![model.cat_id isEqualToString:self.selectGoodChildGategory.cat_id]) {
        
        //每次选择类型后都重置预售和商家提示
        bOpen_pre_sale = NO;
        [self.cellViewDic removeObjectForKey:AddGoods_Pre_Sale_Day];
        [self.cellViewDic removeObjectForKey:AddGoods_Pre_Sale_Switch];
        [self.cellViewDic removeObjectForKey:AddGoods_SellerTip];
        
    }
    
    self.selectGoodFirstGategory = parentModel;
    self.selectGoodChildGategory = model;
    
    
    
    
    
    [self refreshSectionNum];
    [self.tableView reloadData];
}

#pragma mark GoodsDescribeControllerDelegate
-(void)addGoodDesrible:(NSString*)dex contentTag:(id)tag{
    
    AddGoodsCell *cell = tag;
    
    if (cell == [_cellViewDic objectForKey:AddGoods_Describe]) {
        if ([UitlCommon isNull:dex]){//商品描述
            _goodsDes = nil;
        }
        else {
            _goodsDes = dex;
        }
    }
    else if(cell == [_cellViewDic objectForKey:AddGoods_SellerTip]){//商家提示
        
        if ([UitlCommon isNull:dex]){//商品描述
            _sellerNotice = nil;
        }
        else {
            _sellerNotice = dex;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark GoodsPictureViewControllerDelegate
-(void)addGoodsPic:(NSArray<CustomUploadImageView*>*)goodPicsView{
    
    self.currentGoodPicViews = [NSMutableArray arrayWithArray:goodPicsView];
    
    [self.tableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        _goodsDes = nil;
        _sellerNotice = nil;
        bOpen_pre_sale = NO;
        [_cellViewDic removeAllObjects];
        [_specArray removeAllObjects];
        
        self.currentGoodPicViews = [NSMutableArray array];
        
        self.selectGoodFirstGategory = nil;
        self.selectGoodChildGategory = nil;
        
        
        [self refreshSectionNum];
        
        [_tableView reloadData];
        
    }
    else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
