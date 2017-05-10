//
//  TypeSelectController.h
//  legend_business_ios
//
//  Created by heyk on 16/3/7.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum {

    SelectViewType_Adv,//发布广告类型
    SelectViewType_StoryType,//经营类目
    
}SelectViewType;

@protocol TypeSelectControllerDelegate <NSObject>

@optional
-(void)selectTypeModel:(id)model;


@end


@interface TypeSelectController : BaseViewController

@property (nonatomic)SelectViewType type;
@property (nonatomic,weak)id<TypeSelectControllerDelegate>delegate;

@end



