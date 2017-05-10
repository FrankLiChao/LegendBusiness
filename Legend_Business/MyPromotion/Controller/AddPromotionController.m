//
//  AddPromotionController.m
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/6.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "AddPromotionController.h"
#import "AddAdverCell.h"
#import "SelectGoodsController.h"
#import "TypeSelectController.h"
#import "AdvDatePickView.h"
#import "MaskPayController.h"

@interface AddPromotionController ()<AddAdverCellDelegate,SelectGoodsControllerDelegate,TypeSelectControllerDelegate>

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UIButton *doneButton;
@property (nonatomic,strong) PromotionModel *model;
@end

@implementation AddPromotionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    self.title = @"发布广告";
    
    
    [UitlCommon setFlatWithView:_doneButton radius:[Configure SYS_CORNERRADIUS]];
    if (_listModel) {
        _model = [[PromotionModel alloc] initWithListModel:_listModel];
    }
    else if(_goodModel){
        _model = [[PromotionModel alloc]  initWithGoodsModel:_goodModel];
    }
    else{
        
        _model = [PromotionModel new];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark custom methods
- (IBAction)clickDoneButton{
    
    [UitlCommon closeAllKeybord];
    
    if ([UitlCommon isNull:_model.title]) {
        
        [self showHint:@"请填写广告标题"];
        return;
    }
    
    if (!_model.goodId) {
        [self showHint:@"请选择要做广告商品"];
        return;
    }
    if ([UitlCommon isNull:_model.beginTime]) {
        [self showHint:@"请选择广告开始时间"];
        return;
    }
    if([UitlCommon isNull:_model.endTime]){
        [self showHint:@"请选择广告结束时间"];
        return;
    }
    
    if ([[_model beginDate] timeIntervalSince1970] >= [[_model endDate] timeIntervalSince1970]) {
        
        [self showHint:@"结束时间不应该比开始时间早"];
        return;
    }
    
    if([UitlCommon isNull:_model.unit_price] || [_model.unit_price floatValue]<=0){
        [self showHint:@"请填写每份广告的单价"];
        return;
    }
    if([UitlCommon isNull:_model.target_money]|| [_model.target_money floatValue]<=0){
        [self showHint:@"请填写广告的总价"];
        return;
    }
    if([UitlCommon isNull:_model.tpl_type]){
        [self showHint:@"请选择广告类型"];
        return;
    }
    
    if([_model advType] == AdvType_Answer){
        
        if (!_model.advInfoArray || _model.advInfoArray.count==0) {
            
            [self showHint:@"请只是填写一组问题和答案"];
            return;
        }
        for (AnsweAdvInfo *info in _model.advInfoArray) {
            if ([UitlCommon isNull:info.answer] || [UitlCommon isNull:info.question]) {
                
                [self showHint:@"还有问题答案没有填写完成哦"];
                return;
            }
        }
    }
    
    if ([_model.target_number intValue] <= 0){
    
            [self showHint:@"数量要大于0哦"];
            return;
    }

    
    __weak typeof(self) weakSelf = self;
    [weakSelf showHudInView:self.view hint:@"处理中，请稍后"];
    [self relaseAdver:_model.title
                 desc:_model.desc
              goodsId:_model.goodId
            unitPrice:[_model.unit_price floatValue]
            targetNum:[_model.target_number intValue]
          targetMoney:[_model.target_money floatValue]
            startTime:_model.beginTime
              endTime:_model.endTime
              tplType:[_model.tpl_type intValue]
            shareDesc:_model.shareInfo
                extra:[AnsweAdvInfo mj_keyValuesArrayWithObjectArray:_model.advInfoArray]
              success:^(NSString *orderId, NSNumber *myMoney, NSNumber *oderPrice) {
                  [weakSelf hideHud];
                  
                  MaskPayController *vc = [[MaskPayController alloc] initWithNibName:@"MaskPayController" bundle:nil];
                  vc.orderId = orderId;
                  vc.myMoney = myMoney;
                  vc.orderMoney =oderPrice;
                  vc.list_image = weakSelf.model.goods_thumb;
                  
                  vc.unit_price = weakSelf.model.unit_price;
                  vc.target_number = weakSelf.model.target_number;
                  
                  if([weakSelf.model advType] == AdvType_Answer) {
                      vc.type = PayControllerType_Adv_Answer;
                  }
                  else{
                      vc.type = PayControllerType_Adv_Share;
                  }
                  
                  
                  [weakSelf.navigationController pushViewController:vc animated:YES];
                  
                  
              } failed:^(NSString *errorDes) {
                  [weakSelf hideHud];
                  [weakSelf showHint:errorDes];
                  
              }];
    
}

/**
 *  根据当前cell 的index获取在advInfoArray中的index
 *
 *  @param indexPath cell index
 *
 *  @return
 */
- (NSInteger)attrIndex:(NSIndexPath*)indexPath{
    
    NSInteger index = indexPath.section - 5;
    return index;
    
}
#pragma mark tableVIew delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section ==  0 ||section == 4){return 0;}
    else if([_model advType] == AdvType_Answer && section == 5+_model.advInfoArray.count){return 0;}
    return [Configure SYS_UI_SCALE:10];
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([_model advType] == AdvType_None) {
        return 5;
    }
    else if([_model advType] == AdvType_Share){
        return 6;
    }
    else if([_model advType] == AdvType_Answer){
        return 6+_model.advInfoArray.count;
    }
    else  return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (section == 2) {
        return 2;
    }
    else if(section == 3) return 3;
    return 1;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_model advType] == AdvType_Share && indexPath.section == 5) {return 80;}
    else if([_model advType] == AdvType_Answer && indexPath.section >4 && indexPath.section <  5+_model.advInfoArray.count){return 90;}
    return 45;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return  [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {//标题
        AddAdverCell2 *cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddAdverCell2"];
        cell1.delegate = self;
        cell1.keyLabel.text = @"标 题";
        cell1.valueFiled.text = _model.title;
        return cell1;
    }
    else if(indexPath.section == 1){
        
        AddAdverCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddAdverCell1"];
        cell1.delegate = self;
        cell1.keyLabel.text = @"商 品";
        cell1.valueLabel.text = _model.goodsTitle;
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell1;
    }
    else if(indexPath.section == 2){
        
        AddAdverCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddAdverCell1"];
        cell1.delegate = self;
        if(indexPath.row == 0){
            cell1.keyLabel.text = @"开始时间";
            cell1.valueLabel.text = _model.beginTime;
        }
        else if(indexPath.row == 1){
            cell1.keyLabel.text = @"结束时间";
            cell1.valueLabel.text = _model.endTime;
        }
        
        cell1.accessoryType = UITableViewCellAccessoryNone;
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell1;
    }
    else if(indexPath.section == 3){
        
        AddAdverCell *cell1 = nil;
        cell1.delegate = self;
        if(indexPath.row == 0){
            cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddAdverCell2"];
            cell1.delegate = self;
            cell1.keyLabel.text = @"单 价";
            cell1.valueFiled.text = _model.unit_price;
        }
        else if(indexPath.row == 1){
            cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddAdverCell2"];
            cell1.delegate = self;
            cell1.keyLabel.text = @"预 算";
            cell1.valueFiled.text = [NSString stringWithFormat:@"%@",_model.target_money?_model.target_money:@""];
        }
        else if(indexPath.row == 2){
            cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddAdverCell3"];
            cell1.delegate = self;
            cell1.keyLabel.text = @"数 量 :";
            cell1.valueFiled.text =[NSString stringWithFormat:@"%@",_model.target_number?_model.target_number:@""];
        }
        cell1.accessoryType = UITableViewCellAccessoryNone;
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell1;
    }
    else if(indexPath.section == 4){
        
        AddAdverCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddAdverCell1"];
        cell1.delegate = self;
        cell1.keyLabel.text = @"类 型";
        cell1.valueLabel.text = [_model advTypeName];
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell1;
    }
    
    if ([_model advType] == AdvType_Share){
        
        if (indexPath.section == 5) {
            
            AddAdverCell5 *cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddAdverCell5"];
            cell1.delegate = self;
            if([UitlCommon isNull:_model.shareInfo]){
                
                cell1.keyLabel.hidden = NO;
                cell1.valueTextView.text = @"";
            }
            else{
                cell1.keyLabel.hidden = YES;
                cell1.valueTextView.text = _model.shareInfo;
            }
            
            return cell1;
            
        }
        
    }
    else if([_model advType] == AdvType_Answer){
        
        if (indexPath.section == 5+_model.advInfoArray.count) {//最后一行
            
            AddAdverCell4 *cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddAdverCell4"];
            cell1.delegate = self;
            return cell1;
        }
        else{
            AddAdverCell6 *cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddAdverCell6"];
            cell1.delegate = self;
            
            NSInteger index = [self attrIndex:indexPath];
            AnsweAdvInfo *info = [_model.advInfoArray objectAtIndex:index];
            cell1.questionValueFiled.text = info.question;
            cell1.answerValueFiled.text = info.answer;
            
            return cell1;
        }
        
    }
    
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [UitlCommon closeAllKeybord];
    
    if (indexPath.section == 1) {//商品选择
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Store" bundle:nil];
        SelectGoodsController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SelectGoodsController"];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (indexPath.section == 4){
        
        TypeSelectController *selct = [[TypeSelectController alloc] initWithNibName:@"TypeSelectController" bundle:nil];
        selct.delegate = self;
        selct.type = SelectViewType_Adv;
        [self.navigationController pushViewController:selct animated:YES];
        
    }
    else if(indexPath.section == 2){
        
        [UitlCommon closeAllKeybord];
        __weak typeof(self) weakSelf = self;
        if (indexPath.row == 0) {
            [[AdvDatePickView getInstance] showWithValue:_model.beginTime selectBlock:^(id content) {
                weakSelf.model.beginTime = content;
                [weakSelf.tableView reloadData];
            }];
        }
        else if (indexPath.row == 1) {
            [[AdvDatePickView getInstance] showWithValue:_model.endTime selectBlock:^(id content) {
                weakSelf.model.endTime = content;
                [weakSelf.tableView reloadData];
            }];
        }
    }
}

#pragma mark AddAdverCell delegate
- (void)nomalCellValueChanged:(NSString*)value cell:(AddAdverCell*)cell{
    NSIndexPath *index = [_tableView indexPathForCell:cell];
    if (!index) {
        return;
    }
    if (index.section == 0) {//title
        _model.title = value;
    }
    
    else if (index.section == 3){
        if (index.row == 0) {//单价
            _model.unit_price = value;
        }
        else if(index.row == 1){//金额
            _model.target_money = value;
        }
        
        AddAdverCell *numCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:3]];
        numCell.valueLabel.text = [NSString stringWithFormat:@"%d",[_model getCount]];
        _model.target_number =  numCell.valueLabel.text;
    }
    
    else if ([_model advType] == AdvType_Share && index.section == 5){
        
        _model.shareInfo = value;
    }
    
}

- (void)addNewQuestionCell:(AddAdverCell*)cell{
    
    if ([_model advType] == AdvType_Answer) {
        
        AnsweAdvInfo *info = [AnsweAdvInfo new];
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:_model.advInfoArray];
        [array addObject:info];
        _model.advInfoArray = array;
    }
    
    [_tableView reloadData];
    
}

//添加问题及答案，问答类广告才有
- (void)questionChanged:(NSString*)question answer:(NSString*)answer cell:(AddAdverCell*)cell{
    
    NSIndexPath *indexPath = [_tableView    indexPathForCell:cell];
    NSInteger index = [self attrIndex:indexPath];
    AnsweAdvInfo *info = [_model.advInfoArray objectAtIndex:index];
    info.question = question;
    info.answer = answer;
    
}

- (void)deleteQustion:(AddAdverCell*)cell{
    
    NSIndexPath *indexPath = [_tableView  indexPathForCell:cell];
    NSInteger  index = [self attrIndex:indexPath];
    NSMutableArray *array = [NSMutableArray arrayWithArray:_model.advInfoArray];
    [array removeObjectAtIndex:index];
    _model.advInfoArray = array;
    
    [_tableView reloadData];
}

#pragma mark SelectGoodsController
- (void)selectGoods:(ProductListModel*)model{
    
    _model.goodId = model.goods_id;
    _model.goodsTitle = model.goods_name;
    _model.goods_thumb = model.goods_thumb;
    
    AddAdverCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1 ]];
    cell.valueLabel.text = model.goods_name;
    
}

#pragma mark TypeSelectControllerDelegate
-(void)selectTypeModel:(CategoryModel*)model{
    
    _model.tpl_type = [model.cat_id stringValue];
    
    AddAdverCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4 ]];
    cell.valueLabel.text = model.cat_name;
    
    
    if ([_model advType] == AdvType_Answer) {
        
        AnsweAdvInfo *info = [AnsweAdvInfo new];
        
        _model.advInfoArray = @[info];
    }
    
    [_tableView reloadData];
}

@end
