//
//  AdvDatePickView.m
//  legend_business_ios
//
//  Created by heyk on 16/3/7.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "AdvDatePickView.h"
@interface AdvDatePickView()

@property (nonatomic,copy) AdvDatePickViewSelect selectBlock;

@end


@implementation AdvDatePickView{


    UIView *contentView;
    UITapGestureRecognizer *tap;

    UIDatePicker *datePicker;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

+(AdvDatePickView*)getInstance{
    
    static AdvDatePickView *customPickView = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        customPickView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
    });
    return customPickView;
    
}

- (void)showWithValue:(NSString*)value selectBlock:(AdvDatePickViewSelect)block{
    
    self.selectBlock = block;

    [self setUIWithValue:value];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = contentView.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height -[Configure SYS_UI_SCALE:180]-[Configure SYS_UI_BUTTON_HEIGHT];
        contentView.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)setUIWithValue:(NSString*)value{

    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    if (contentView) {
        [contentView removeFromSuperview];
        contentView = nil;
    }
    if (tap) {
        [self removeGestureRecognizer:tap];
        tap = nil;
    }
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           [UIScreen mainScreen].bounds.size.height,
                                                           [UIScreen mainScreen].bounds.size.width,
                                                            224)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
   
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,44, [UIScreen mainScreen].bounds.size.width, 180)];
    [contentView addSubview:datePicker];
    
    
    NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
    [datePicker setTimeZone:systemTimeZone];//设置时区
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    datePicker.minimumDate = [NSDate date];
    
    NSDate *use_date = [NSDate date];
    

    if (value.length > 0) {
   
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        use_date= [dateFormatter dateFromString:value];
    }
    [datePicker setDate:use_date];

    
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    topBar.backgroundColor = [UitlCommon UIColorFromRGB:0xeeeeee];
    [contentView addSubview:topBar];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UitlCommon UIColorFromRGB:0x999999] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:[Configure SYS_FONT_SCALE:14]];
    
    button.frame = CGRectMake(contentView.frame.size.width- 60,
                              0,
                             60,
                              44);
    
    [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:button];
    
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UitlCommon UIColorFromRGB:0x999999] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:[Configure SYS_FONT_SCALE:14]];
    
    cancel.frame = CGRectMake(0,
                              0,
                              60,
                              44);
    
    [cancel addTarget:self action:@selector(tapBack) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:cancel];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];

}

- (void)selectClick:(UIButton*)select{

    
    if (self.selectBlock) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
        self.selectBlock(dateStr);
        
    }
    
    [self dismiss];
    
}

- (void)tapBack{

    
    [self dismiss];
}
-(void)dismiss{
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         CGRect frame = contentView.frame;
                         frame.origin.y = [UIScreen mainScreen].bounds.size.height;
                         contentView.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                         [contentView removeFromSuperview];
                         contentView = nil;
                         
                         [self removeGestureRecognizer:tap];
                         tap = nil;
                         
                         [self removeFromSuperview];
                     }];
}


@end
