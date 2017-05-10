//
//  CustomAlterView.m
//  legend
//
//  Created by msb-ios-dev on 15/10/30.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "CustomAlterView.h"
#import "DefineKey.h"
#import "legend_business_ios-swift.h"


static CustomAlterView *customAlterView = nil;

@implementation CustomAlterView{
    BOOL isShow;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (CustomAlterView*)getInstanceWithTitle:( NSString *)title message:( NSString *)message  leftButton:( NSString *)leftButtonTitle rightButtonTitles:( NSString *)rightButtonTitles click:(CustomAlterClickBlock)block{


    if (!customAlterView) {
        
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"CustomAlterView" owner:nil options:nil];
        for(id obj in objs) {
            if([obj isKindOfClass:[CustomAlterView class]]){
                customAlterView = (CustomAlterView *)obj;
                customAlterView.frame = [UIScreen   mainScreen].bounds;
                customAlterView.messageTextView.editable = NO;
                [UitlCommon setFlatWithView:customAlterView.contentView radius:8];
                break;
            }
        }

    }
    
    customAlterView.titleLabel.text = title;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
     customAlterView.messageTextView.attributedText = [[NSAttributedString alloc] initWithString:message attributes:attributes];
    
   // customAlterView.messageTextView.text = message;
    [customAlterView.leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
    [customAlterView.rightButton setTitle:rightButtonTitles forState:UIControlStateNormal];
    customAlterView.clickBlock = block;
    
    [customAlterView setUI];
    return customAlterView;
}

-(void)setUI{

    if (self.messageTextView.text) {
        self.messageTextView.hidden = NO;
        
        CGSize size = [self.messageTextView.text sizeWithFont:self.messageTextView.font byWidth:260];
        
        float heigt = 96 + size.height +100;
        if(heigt>300){
             size.height = 204;
            heigt = 96 + size.height ;
              self.messageTextView.scrollEnabled = YES;
        }
        else{
            self.messageTextView.scrollEnabled = NO;
        }
        
        self.contenHeight.constant = heigt;
    

    }
    else {
         self.messageTextView.hidden = YES;
         self.contenHeight.constant = 86 ;
    }
    
    if ([UitlCommon isNull:self.leftButton.titleLabel.text] && self.rightButton.titleLabel.text) {
        
        self.lineCenterX.constant = -140;
        self.leftButton.hidden = YES;
        self.rightButton.hidden = NO;
        self.spearteLine.hidden = YES;
    }
    else if(self.leftButton.titleLabel.text && !self.rightButton.titleLabel.text){
        self.lineCenterX.constant = 140;
       
        self.leftButton.hidden = NO;
        self.rightButton.hidden = YES;
        self.spearteLine.hidden = YES;
    }
    else{
        self.lineCenterX.constant = 0;
        self.leftButton.hidden = NO;
        self.rightButton.hidden = NO;
        self.spearteLine.hidden = NO;
    }
   
    
}

-(void)show{

    if (!isShow) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    }
}
-(void)dismiss{

    [self removeFromSuperview];
}


-(IBAction)clickLeftButton:(id)sender{

    self.clickBlock(1,self);
}

-(IBAction)clickRightButton:(id)sender{

    self.clickBlock(2,self);
}

@end
