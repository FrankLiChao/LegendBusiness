//
//  CustomSegView.h
//  legend_business_ios
//
//  Created by heyk on 16/3/3.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton

@end


@protocol CustomSegViewDelegate <NSObject>

- (void)segValueChanged:(NSInteger)index;



@end

@interface CustomSegView : UIView

@property (nonatomic,weak) IBOutlet UIView *contentView;
@property (nonatomic,weak) IBOutlet MyButton *firstButton;
@property (nonatomic,weak) IBOutlet MyButton *secondButton;
@property (nonatomic,weak) IBOutlet MyButton *thirdButton;
@property (nonatomic,weak) IBOutlet MyButton *fourthButton;

@property (nonatomic)NSInteger selectIndex;//0-3


@property (nonatomic,assign)id<CustomSegViewDelegate>delegate;

+ (CustomSegView*)createWithNib;


@end
