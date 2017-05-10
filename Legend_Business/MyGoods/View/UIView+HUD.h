//
//  UIView+HUD.h
//  legend
//
//  Created by heyk on 16/1/13.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView(HUD)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

@end

