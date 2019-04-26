//
//  ModefyBackNameViewController.m
//  legend
//
//  Created by heyk on 15/12/7.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "ModefyBackNameViewController.h"
#import "UIViewController+HUD.h"
#import "legend_business_ios-Swift.h"


@interface ModefyBackNameViewController (){

    UIButton *back_btn;
    
}

@end


@implementation ModefyBackNameViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackButton];
    
    _textFiled.font =  [UIFont systemFontOfSize:[Configure SYS_FONT_SCALE:14]];
    _tipNameLabel.font = [UIFont systemFontOfSize:[Configure SYS_FONT_SCALE:12]];
//
    self.title = _strtitle;
    _tipNameLabel.text = [NSString stringWithFormat:@"修改%@",_strtitle];
    
   // [self performSelector:@selector(showKeyBodr) withObject:nil afterDelay:1];
    [self addRightBarItemWithTitle:@"保存" method:@selector(done:)];

    back_btn = self.navigationItem.rightBarButtonItem.customView;
    if (_type != ModefyType_AddSeller_After_Address){
        back_btn.enabled = NO;
    }

    self.textFiledHeight.constant = [Configure SYS_UI_SCALE:44];
    
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, self.textFiledHeight.constant)];
    leftV.backgroundColor = [UIColor clearColor];
    _textFiled.leftViewMode = UITextFieldViewModeAlways;
    _textFiled.leftView = leftV;
    
    self.textFiled.text = self.oldValue;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)showKeyBodr{
    [self.textFiled becomeFirstResponder];
}

-(void)done:(UIButton*)button{

    
    [UitlCommon closeAllKeybord];
    
    if ([UitlCommon isNull:_textFiled.text]) {
        [self showHint:@"请输入有效内容"];
        return;
    }
    
    if(_type == ModefyType_AddSeller_After_Address){
       __weak typeof(self) weakSelf = self;
        [self showHint:@"处理中"];
        
        [self sellerAgreeAfter:_myID
                recieveAddress:_textFiled.text
                        comple:^(BOOL bSuccess, NSString *message) {
                            [weakSelf hideHud];
                            [weakSelf showHint:message];
                            if (bSuccess) {
                                       
                                [[NSNotificationCenter defaultCenter] postNotificationName:SYS_NOTI_REFUSE_BUYER_AFTER object:weakSelf.myID];
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }
                       
                        }];
        
    }
    else{
    
        ChangeUserInfoType changeType;
        
        
        if (_type == ModefyType_SotreName) {
            changeType = ChangeUserInfoType_Name;
        }
        else if(_type == ModefyType_SotrePhone){
            changeType = ChangeUserInfoType_Phone;
        }
        
        __weak typeof(self) weakSelf = self;
        
        [self changeUsrInfo:changeType
                      value:_textFiled.text
                     comple:^(BOOL bSuccess, NSString *message) {
                         
                         [weakSelf hideHud];
                         
                         if (bSuccess) {
                             [weakSelf showHint:@"修改成功"];
                             
                             if ( [NSStringFromClass([_contentModel class])  hasSuffix:@"UserInfoModel"]) {
                                 
                                 
                                 if (_type == ModefyType_SotreName) {
                                     [_contentModel  setValue:_textFiled.text forKey:@"seller_name"];
                                 }
                                 //                             else if(_type == ModefyType_SotreType){
                                 //
                                 //                                 [_contentModel  setValue:_textFiled.text forKey:@"seller_cat_name"];
                                 //                             }
                                 else if(_type == ModefyType_SotrePhone){
                                     
                                     [_contentModel  setValue:_textFiled.text forKey:@"telephone"];
                                 }
                                 [weakSelf.navigationController popViewControllerAnimated:YES];
                             }
                             
                             
                             
                         }
                         else {
                             [weakSelf showHint:message];
                         }
                     }];
        
        NSLog(@"%@",NSStringFromClass([_contentModel class]));

    }
 
}

//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark  WebEngine delegate
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  
    NSString *str = [UitlCommon getCurrentTextFiledText:textField.text newText:string];
    if(_type == ModefyType_AddSeller_After_Address){
        if (str.length>200) {
            return NO;
        }
    
    }
    else{
        if (str.length>20) {
            return NO;
        }
    }
 
 return YES;
}
-(void)textChanged{

    if ([UitlCommon isNull:_textFiled.text]) {
        back_btn.enabled = NO;
        [back_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    }
    else{
        back_btn.enabled = YES;
            [back_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}


@end
