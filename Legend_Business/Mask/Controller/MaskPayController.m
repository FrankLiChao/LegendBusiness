//
//  MaskPayController.m
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/6.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "MaskPayController.h"
#import "EnterPasswordView.h"
#import "MaskReleaseFinishController.h"
#import "AdvReleaseFinshController.h"
#import "PaySever.h"
#import "legend_business_ios-swift.h"

@implementation SelectButton

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self setImage:[UIImage imageNamed:@"select_red"] forState:UIControlStateNormal];
    }
    else [self setImage:[UIImage imageNamed:@"unSelect_red"] forState:UIControlStateNormal];
}

@end

@interface MaskPayController (){
    
    
}

@property (nonatomic,weak) IBOutlet UIImageView *goodsIcomImageV;
@property (nonatomic,weak) IBOutlet UILabel *maskInfoLabel;
@property (nonatomic,weak) IBOutlet UILabel *priceLabel;
@property (nonatomic,weak) IBOutlet UILabel *maskNumLabel;
@property (nonatomic,weak) IBOutlet UILabel *yueTipLabel;
@property (nonatomic,weak) IBOutlet UILabel *yueTitleLabel;
@property (nonatomic,weak) IBOutlet SelectButton *yueSelectButton;
@property (nonatomic,weak) IBOutlet SelectButton *zhifubaoSelectButton;
@property (nonatomic,weak) IBOutlet SelectButton *wechatSelectButton;
@property (nonatomic,weak) IBOutlet UILabel *totalPricrLabel;
@property (nonatomic,weak) IBOutlet UIButton *surePayButton;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *surePayButtonHeight;




@end

@implementation MaskPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    self.title = @"支付";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPayFailed:) name:SYS_WECHAT_PAY_FAILED_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPaySuccess:) name:SYS_WECHAT_PAY_SUCCESS_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatCancel:) name:SYS_WECHAT_PAY_CANCEL_NOTIFY object:nil];
    
    [UitlCommon setFlatWithView:_surePayButton radius:[Configure SYS_CORNERRADIUS]];
    
    [self.goodsIcomImageV sd_setImageWithURL:[NSURL URLWithString:self.list_image] placeholderImage:[UIImage imageNamed:@"默认"]];
    if (_type == PayControllerType_Mask) {
        self.maskInfoLabel.text = [NSString stringWithFormat:@"%@天内，累计分享次数达到%@次，即可获得%@元现金奖励",self.time_limit,self.demand,self.unit_price];
    }
    else if(_type == PayControllerType_Adv_Share){
        self.maskInfoLabel.text = [NSString stringWithFormat:@"累计分享即可获得%@元现金奖励",self.unit_price];
        
    }
    else if(_type == PayControllerType_Adv_Answer){
        self.maskInfoLabel.text = [NSString stringWithFormat:@"回答对问题即可获得%@元现金奖励",self.unit_price];
    }
    
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",self.unit_price];
    self.maskNumLabel.text =  [NSString stringWithFormat:@"%@件",self.target_number];
    
    _surePayButtonHeight.constant = [Configure SYS_UI_BUTTON_HEIGHT];
    _surePayButton.titleLabel.font = [Configure SYS_UI_BUTTON_FONT];
    
    _yueSelectButton.selected = YES;
    
    self.totalPricrLabel.text = [NSString stringWithFormat:@"%@元",self.orderMoney];
    if ([_myMoney floatValue]<[_orderMoney floatValue]) {
        self.yueTipLabel.hidden = NO;
        
    }
    else{
        self.yueTipLabel.hidden = YES;
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)advPay:(PayType)type password:(NSString*)password{
    
    [self showHudInView:self.view hint:nil];
    __weak typeof(self) weakSelf = self;
    
    [self advPay:type
        password:password
         orderID:self.orderId
         success:^(Order *order, int type) {
             
             if ( type == PayType_Yue) {
                 
                 [weakSelf hideHud];
                 [weakSelf dealYuePaySuccess];
                 
             }
             else if(type == PayType_Alipay){
                 
                 [weakSelf dealAlipaySuccess:order];
             }
             else if(type == PayType_Wechat){
                 
                 [self dealWechatPayScuess:order];
             }
             
         } failed:^(NSString *errorDes) {
             [weakSelf hideHud];
             
             if (type == PayType_Yue) {
                 [weakSelf dealYuePayFailed:errorDes];
             }
             else{
                 [weakSelf showHint:errorDes];
             }
         }];
    
}

- (void)maskPay:(PayType)type password:(NSString*)password{
    
    [self showHudInView:self.view hint:nil];
    __weak typeof(self) weakSelf = self;
    
    [self maskPay:type
         password:password
          orderNo:self.orderId
          success:^(Order *order, PayType type) {
              
              if ( type == PayType_Yue) {
                  
                  [weakSelf hideHud];
                  [weakSelf dealYuePaySuccess];
                  
              }
              else if(type == PayType_Alipay){
                  
                  [weakSelf dealAlipaySuccess:order];
              }
              else if(type == PayType_Wechat){
                  
                  [self dealWechatPayScuess:order];
              }
              
          } failed:^(NSString *errorDes) {
              [weakSelf hideHud];
              
              if (type == PayType_Yue) {
                  [weakSelf dealYuePayFailed:errorDes];
              }
              else{
                  [weakSelf showHint:errorDes];
              }
              
          }];
}


- (void)dealYuePaySuccess{
    
    if(_type == PayControllerType_Mask){
        MaskReleaseFinishController *vc = [[MaskReleaseFinishController alloc] initWithNibName:@"MaskReleaseFinishController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        
        AdvReleaseFinshController *vc = [[AdvReleaseFinshController alloc] initWithNibName:@"AdvReleaseFinshController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)dealYuePayFailed:(NSString*)errorDes{
    
    if ([errorDes containsString:@"支付密码错误"] || [errorDes containsString:@"密码错误"]) {
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付密码错误" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"忘记密码", nil];
        [alter show];
    }
    else{
        [self showHint:errorDes];
    }
}


- (void)dealWechatPayScuess:(Order*)order{
    
    [PaySever weChatPay:order comple:^(BOOL bsuccess) {
        [self hideHud];
        if (!bsuccess) {
            [self showHint:@"支付失败，请稍后再试"];
        }
    }];
}

- (void)dealAlipaySuccess:(Order*)order{
    
    [PaySever aliPay:order comple:^(BOOL bsuccess,NSString *message) {
        [self hideHud];
        if (!bsuccess) {
            [self showHint:message];
        }
        else{
            [self weChatPaySuccess:nil];
        }
    }];
}


- (IBAction)clickPay:(id)sender{
    
    if ([_myMoney floatValue]<[_orderMoney floatValue] && _yueSelectButton.selected) {
        [self showHint:@"余额不足，请选择其他支付方式"];
        return;
    }
    else if(_yueSelectButton.selected){//余额支付
        
        [self enterMyPayPassword];
    }
    else if(_wechatSelectButton.selected){//微信支付
        
        if(_type == PayControllerType_Mask){//任务支付
            [self maskPay:PayType_Wechat password:nil];
        }
        else {//广告支付
            
            [self advPay:PayType_Wechat password:nil];
        }
        
    }
    else if(_zhifubaoSelectButton.selected){//支付宝支付
        
        if(_type == PayControllerType_Mask){//任务支付
            [self maskPay:PayType_Alipay password:nil];
        }
        else{
            [self advPay:PayType_Alipay password:nil];
        }
    }
    
}


-(void)enterMyPayPassword{
    
    UserInfoModel *model = [SaveEngine getUserInfo];
    
    if ([model.payment_pwd boolValue]) {//密码验证
        
        [EnterPasswordView showWithContent:[NSString stringWithFormat:@"%@",self.orderMoney] comple:^(NSString *password) {
            
            if(_type == PayControllerType_Mask){//任务支付
                
                [self maskPay:PayType_Yue password:password];
                
            }
            else{
                [self advPay:PayType_Yue password:password];
                
            }
            
        }];
    }
    else{
        [self showSetPasswordVC];
    }
    
}



#pragma makr UIAlertView delegate
-(void)showSetPasswordVC{
    
    CashPasswordFirstSetingViewController *password = [[CashPasswordFirstSetingViewController alloc] initWithNibName:@"CashPasswordFirstSetingViewController" bundle:nil];
    password.type = SMSType_SetPayPWD;
    [self.navigationController pushViewController:password animated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self performSelector:@selector(showSetPasswordVC) withObject:nil afterDelay:0.1];
    }
    else{
        [self enterMyPayPassword];
    }
}


- (IBAction)clickSelectPayWay:(SelectButton*)sender{
    
    if (sender == _zhifubaoSelectButton) {
        [self showHint:@"支付宝支付暂未开通"];
        return;
    }
    _yueSelectButton.selected = NO;
    _zhifubaoSelectButton.selected = NO;
    _wechatSelectButton.selected = NO;
  
    sender.selected = YES;
}

#pragma mark kTHREE_TRADE_FINISH_NOTIFY
-(void)weChatPaySuccess:(NSNotification*)notify{
    
    if(_type == PayControllerType_Mask){
        MaskReleaseFinishController *vc = [[MaskReleaseFinishController alloc] initWithNibName:@"MaskReleaseFinishController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        
        AdvReleaseFinshController *vc = [[AdvReleaseFinshController alloc] initWithNibName:@"AdvReleaseFinshController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)wechatPayFailed:(NSNotification*)notify{
    
    [self hideHud];
    [self showHint:@"支付失败"];
    
}
- (void)wechatCancel:(NSNotification*)notify{
    
    [self hideHud];
    [self showHint:@"支付取消"];
    
}

@end
