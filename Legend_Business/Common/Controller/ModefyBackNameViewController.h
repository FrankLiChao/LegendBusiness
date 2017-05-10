//
//  ModefyBackNameViewController.h
//  legend
//
//  Created by heyk on 15/12/7.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class BaseViewController;

typedef enum {
    ModefyType_SotreName,
    ModefyType_SotreType,
    ModefyType_SotrePhone,
    ModefyType_AddSeller_After_Address,//添加商家退货地址
}ModefyType;


@interface ModefyBackNameViewController : BaseViewController

@property (nonatomic,weak)IBOutlet UILabel *tipNameLabel;
@property (nonatomic,weak)IBOutlet UITextField *textFiled;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *textFiledHeight;

@property (nonatomic,strong)NSString *oldValue;
@property (nonatomic,strong)NSString *myID;
@property (nonatomic,strong)NSString *strtitle;//必传
@property (nonatomic,assign)ModefyType type;//必传

@property (nonatomic,strong)id contentModel;

@end
