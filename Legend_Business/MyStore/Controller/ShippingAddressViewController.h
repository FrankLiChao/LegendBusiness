//
//  ShippingAddressViewController.h
//  LegendWorld
//
//  Created by wenrong on 16/9/27.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"
#import "ShippingAddressViewController.h"
#import "RecieveAddressModel.h"


@interface ShippingAddressViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *hideLab;
@property (weak, nonatomic) IBOutlet UITextField *shippingUserNameTF;
@property (weak, nonatomic) IBOutlet UITextField *cellPhoneTF;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UITextField *mailCodeTF;
@property (weak, nonatomic) IBOutlet UITextView *detailTV;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

//@property (nonatomic,strong) NSString *jumpTag; //1表示订单页面的调转 2、表示地址管理页面的跳转 3、表示编辑地址管理
@property (nonatomic, strong) NSString *after_address;
@property (nonatomic, strong) RecieveAddressModel *currentModel;
@property (nonatomic,weak) id delegate;

@end
