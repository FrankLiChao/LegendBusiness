//
//  CustomSegView.m
//  legend_business_ios
//
//  Created by heyk on 16/3/3.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "CustomSegView.h"

@implementation MyButton

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self setTitleColor:[Configure SYS_UI_COLOR_BG_RED] forState:UIControlStateNormal];
    }
    else {
        
        [self setTitleColor:[Configure SYS_UI_COLOR_TEXT_BLACK] forState:UIControlStateNormal];
    }
}

@end


@implementation CustomSegView

+ (CustomSegView*)createWithNib{

    CustomSegView *view = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"CustomSegView" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[CustomSegView class]]){
            view = (CustomSegView *)obj;
            view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 54);
            view.backgroundColor = [Configure SYS_UI_COLOR_BG_COLOR];
            
            break;
        }
    }
    return view;
}

- (void)setSelectIndex:(NSInteger)selectIndex{


    _selectIndex = selectIndex;
    
    NSInteger tag = _selectIndex + 1;
    MyButton *button = [self viewWithTag:tag];
   
    if (button) {
        
        button.selected = YES;
        [self clcikButton:button];
    }

}

- (IBAction)clcikButton:(MyButton*)sender{

    [self changeButtonSelectStatus];
    sender.selected = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segValueChanged:)]) {
        
        [self.delegate segValueChanged:sender.tag - 1];
    }
}

- (void)changeButtonSelectStatus{
    
    
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[MyButton class]]) {
            ((MyButton*)view).selected = NO;
        }
    }
}

@end
