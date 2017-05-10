//
//  CustomInputAlterView.m
//  legend_business_ios
//
//  Created by heyk on 16/3/3.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "CustomInputAlterView.h"

@implementation CustomInputAlterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (void)showWithAlterDelegate:(id<UIAlertViewDelegate>)delegate{


  UIAlertView   *customAlertView = [[UIAlertView alloc] initWithTitle:@"请输入消费码"
                                                              message:nil
                                                             delegate:delegate
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
    
    [customAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    UITextField *nameField = [customAlertView textFieldAtIndex:0];
    nameField.backgroundColor = [UIColor clearColor];
    nameField.placeholder = @"消费码";
   // nameField.borderStyle = UITextBorderStyleRoundedRect;
    
    //[UitlCommon setFlatWithView:nameField radius:5 borderColor:[Configure SYS_UI_COLOR_LINE_COLOR] borderWidth:1];
    [customAlertView show];
}

@end
