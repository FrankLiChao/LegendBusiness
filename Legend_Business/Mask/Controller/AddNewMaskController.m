//
//  AddNewMaskController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/5.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "AddNewMaskController.h"
#import "SelectGoodsController.h"
#import "MaskPayController.h"


@interface AddNewMaskController ()<SelectGoodsControllerDelegate>

@property (nonatomic,weak) IBOutlet UITextView *maskContentTextView;
@property (nonatomic,weak) IBOutlet UILabel *maskContentPlacehoder;
@property (nonatomic,weak) IBOutlet UITextField *priceLabel;
@property (nonatomic,weak) IBOutlet UITextField *shareTimesLabel;//每个人要做多少次
@property (nonatomic,weak) IBOutlet UITextField *timeLabel;
@property (nonatomic,weak) IBOutlet UITextField *maskNumLabel;//任务份数
@property (nonatomic,weak) IBOutlet UITextField *goodsNameLabel;

@property (nonatomic,weak) IBOutlet UIButton *doneButton;
@property (nonatomic,weak) IBOutlet UIButton *phoneButton;

@property (nonatomic,strong) ProductListModel *selectGoodsModel;


@end

@implementation AddNewMaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    self.title = @"发布新任务";
    
    [UitlCommon setFlatWithView:_doneButton radius:[Configure SYS_CORNERRADIUS ] ];
    [UitlCommon setFlatWithView:_phoneButton radius:10];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChange:) name:UITextViewTextDidChangeNotification object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     if ([segue.destinationViewController isKindOfClass:[SelectGoodsController class]]) {
         [UitlCommon closeAllKeybord];
         SelectGoodsController *vc = segue.destinationViewController;
         vc.delegate = self;
      }
 }
 

#pragma mark custom methods


- (IBAction)clickDoneButton:(id)sender{
    
    [UitlCommon closeAllKeybord];
    
    if ([UitlCommon isNull:_maskContentTextView.text]) {
        [self showHint:@"请输入任务描述"];
        return;
    }
    if([_priceLabel.text floatValue]<=0.0){
    
        [self showHint:@"请输入正确的单价"];
        return;
    }
    if([_shareTimesLabel.text intValue]<=0.0){
        
        [self showHint:@"请输入正确的数量"];
        return;
    }
    if([_timeLabel.text floatValue]<=0.0){
        
        [self showHint:@"请输入正确的完成时间"];
        return;
    }
    if([_maskNumLabel.text intValue]<=0.0){
        
        [self showHint:@"请输入正确的任务数量"];
        return;
    }
    if (!_selectGoodsModel){
    
        [self showHint:@"请选择要做任务的商品"];
        return;
        
    }

    
    [self showHudInView:self.view hint:@"加载数据"];
    __weak typeof(self) weakSelf = self;
    
    [self addMask:self.goodsNameLabel.text
              des:self.maskContentTextView.text
        targetnum:[_maskNumLabel.text intValue]
       uinitPrice:[_priceLabel.text floatValue]
        timeLimit:[_timeLabel.text floatValue]
           damand:[_shareTimesLabel.text floatValue]
          goodsId:_selectGoodsModel.goods_id
          success:^(NSString *orderId, NSNumber *myMoney, NSNumber *oderPrice) {
              
              [weakSelf hideHud];
              MaskPayController *vc = [[MaskPayController alloc] initWithNibName:@"MaskPayController" bundle:nil];
              vc.orderId = orderId;
              vc.myMoney = myMoney;
              vc.orderMoney =oderPrice;
              vc.list_image = weakSelf.selectGoodsModel.goods_thumb;
              vc.time_limit = weakSelf.timeLabel.text;
              vc.demand = weakSelf.shareTimesLabel.text;
              vc.unit_price = weakSelf.priceLabel.text;
              vc.target_number = weakSelf.maskNumLabel.text;
              vc.type = PayControllerType_Mask;
              
              [weakSelf.navigationController pushViewController:vc animated:YES];
              
              
          } failed:^(NSString *errorDes) {
              
              [weakSelf hideHud];
              [weakSelf showHint:errorDes];
              
          }];
    
    
    
}

- (IBAction)clickPhoneSeverce:(UIButton*)button{

    NSMutableString *phoneNum = [NSMutableString stringWithString:button.titleLabel.text];
    [phoneNum replaceOccurrencesOfString:@"-" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, phoneNum.length)];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]]];
}


#pragma mark notify
- (void)textValueChange:(NSNotification*)notify{


    if ([notify object] == _maskContentTextView) {
        if (!_maskContentTextView.text || [_maskContentTextView.text isEqualToString:@""] ) {
            _maskContentPlacehoder.hidden = NO;
        }
        else _maskContentPlacehoder.hidden = YES;
    }
    if (_maskContentTextView.text.length>200) {
        
        NSMutableString *content = [NSMutableString stringWithString:_maskContentTextView.text];
        [content replaceCharactersInRange:NSMakeRange( 200,content.length - 200) withString:@""];
        _maskContentTextView.text = content;
    }
}


#pragma mark SelectGoodsControllerDelegate
- (void)selectGoods:(ProductListModel*)model{

    self.selectGoodsModel = model;
    self.goodsNameLabel.text = model.goods_name;

}

@end
