//
//  EnterRefuseReasonController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/4.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "EnterRefuseReasonController.h"

@interface EnterRefuseReasonController ()

@property (nonatomic,weak) IBOutlet UIView *textBackView;
@property (nonatomic,weak) IBOutlet UITextView *textView;
@property (nonatomic,weak) IBOutlet UIButton *doneButton;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *doneButtonHeight;

@end

@implementation EnterRefuseReasonController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    
    switch (_type) {
        case InPutTextViewType_AfterRefuse:
        {
            self.title = @"拒绝理由";
        }break;
        case InPutTextViewType_Comments:
        {
            self.title = @"评价回复";
        }break;
        case InPutTextViewType_Modify_Seller_Info:
        {
            self.title = @"店铺介绍";
            self.textView.text = ((UserInfoModel*)_content).content;
        }break;
        default:
            break;
    }
    [UitlCommon setFlatWithView:_doneButton radius:[Configure SYS_CORNERRADIUS]];
    _doneButtonHeight.constant = [Configure SYS_UI_BUTTON_HEIGHT];
    _doneButton.titleLabel.font = [Configure SYS_UI_BUTTON_FONT];
    [UitlCommon setFlatWithView:_textBackView radius:[Configure SYS_CORNERRADIUS] borderColor:[Configure SYS_UI_COLOR_LINE_COLOR] borderWidth:1];
    
    
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
    
    [_textView  resignFirstResponder];
    if ([UitlCommon isNull:_textView.text]){
    
        [self showHint:@"请输入内容"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    switch (_type) {
        case InPutTextViewType_AfterRefuse:
        {
            
            [self showHudInView:self.view hint:@""];
            [self refuseAfter:_ID
                       reason:_textView.text
                       comple:^(BOOL bSuccess, NSString *message) {
                           [weakSelf hideHud];
                           [weakSelf showHint:message];
                           if (bSuccess) {
                               
                               [[NSNotificationCenter defaultCenter] postNotificationName:SYS_NOTI_REFUSE_BUYER_AFTER object:weakSelf.ID];
                               
                               [weakSelf.navigationController popViewControllerAnimated:YES];
                           }
                           
                       }];
            
            
        }
            break;
        case InPutTextViewType_Comments:
        {
            [self showHudInView:self.view hint:@""];
            [self addCmmentsReply:_ID
                     replyContent:_textView.text
                          success:^{
                              
                              [weakSelf hideHud];
                              [weakSelf showHint:@"回复成功"];
                              NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:weakSelf.textView.text,@"content",weakSelf.ID,@"ID", nil];
                              
                              [[NSNotificationCenter defaultCenter] postNotificationName:SYS_NOTI_ADD_COMMNET_REPLY object:dic];
                              [weakSelf.navigationController popViewControllerAnimated:YES];
                              
                              
                          } failed:^(NSString *errorDes) {
                              
                              [weakSelf hideHud];
                              [weakSelf showHint:errorDes];
                          }];
            
        }
            break;
            
        case InPutTextViewType_Modify_Seller_Info:
        {
            [self showHudInView:self.view hint:@""];
            [self changeUsrInfo:ChangeUserInfoType_Content
                          value:_textView.text
                         comple:^(BOOL bSuccess, NSString *message) {
                
                             if (bSuccess) {
                                 
                                 [weakSelf hideHud];
                                 [weakSelf showHint:@"修改成功"];
                                
                                 ((UserInfoModel*)_content).content = weakSelf.textView.text;
                                 
                                 [weakSelf.navigationController popViewControllerAnimated:YES];
                                 
                             }
                             else{
                                 [weakSelf hideHud];
                                 [weakSelf showHint:message];
                             }
                         }];
        }
            break;
        default:
            break;
    }
    
    
}

@end
