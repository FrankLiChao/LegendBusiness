//
//  PostInfoController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/16.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "PostInfoController.h"

@interface PostInfoController ()

@property (nonatomic,weak) IBOutlet UITextField *postCompanyField;
@property (nonatomic,weak) IBOutlet UITextField *postNumField;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *buttonHeight;
@property (nonatomic,weak) IBOutlet UIButton *button;


@end

@implementation PostInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    self.title = @"请填写运单信息";
    _buttonHeight.constant = [Configure SYS_UI_BUTTON_HEIGHT];
    _button.titleLabel.font = [Configure SYS_UI_BUTTON_FONT];
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

- (IBAction)clickDone:(id)sender{

    
    if ([UitlCommon isNull:_postCompanyField.text]) {
        [self showHint:@"请填写重新发货的快递公司名称"];
        return;
    }
    if ([UitlCommon isNull:_postNumField.text]) {
        [self showHint:@"请填写重新发货的快递单号"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self showHint:@"处理中"];
    
    [self afterSureAndSendRecive:self.afterId
                     postCompany:_postCompanyField.text
                         postNum:_postNumField.text
                          comple:^(BOOL bSuccess, NSString *message) {
                              
                              [weakSelf hideHud];
                              [weakSelf showHint:message];
                              if (bSuccess) {
                                  
                                  [[NSNotificationCenter defaultCenter] postNotificationName:SYS_NOTI_REFUSE_BUYER_AFTER object:weakSelf.afterId];
                                  [weakSelf.navigationController popViewControllerAnimated:YES];
                              }

                          }];
    
}


@end
