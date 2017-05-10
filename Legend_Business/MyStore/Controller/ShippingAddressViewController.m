//
//  ShippingAddressViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/9/27.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ShippingAddressViewController.h"
#import "RecieveAddressModel.h"
#import "CustomPickView.h"
#import "JSONParser.h"

@interface ShippingAddressViewController ()<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;
@property (strong, nonatomic) NSString *addressStr;

@property (strong,nonatomic) UserInfoModel *userInfoModel;
@property (strong,nonatomic) AddressModel *addressModel;

@end

@implementation ShippingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"售后地址";
    self.currentModel = [RecieveAddressModel new];
    self.saveBtn.layer.cornerRadius = 6;
    self.saveBtn.layer.masksToBounds = YES;
    self.shippingUserNameTF.delegate = self;
    self.cellPhoneTF.delegate = self;
    self.cellPhoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.mailCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    self.mailCodeTF.delegate = self;
    self.detailTV.delegate = self;
    [self reloadData];
}

-(void)reloadData{
    [self getUserInfo:^(UserInfoModel *model) {
        self.userInfoModel = model;
        [self refreshUI];
    } failed:^(NSString *errorDes) {
        [self showHint:errorDes];
    }];
}

-(void)saveAddress{
    self.addressModel.consignee = self.shippingUserNameTF.text;
    self.addressModel.mobile = self.cellPhoneTF.text;
    self.addressModel.address = self.detailTV.text;
    NSDictionary *addressDic = @{@"consignee":self.addressModel.consignee,
                                 @"mobile":self.addressModel.mobile,
                                 @"postcode":self.addressModel.postcode,
                                 @"province":self.addressModel.province,
                                 @"city":self.addressModel.city,
                                 @"area":self.addressModel.area,
                                 @"address":self.addressModel.address};
    NSString *addressStr = [JSONParser parseToStringWithDictionary:addressDic];
    [self changeUsrInfo:ChangeUserInfoType_AfterSaleAddress value:addressStr comple:^(BOOL bSuccess, NSString *message) {
        [self showHint:@"地址保存成功"];
        self.userInfoModel.after_address = addressStr;
        [SaveEngine saveUserInfo:self.userInfoModel];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)refreshUI{
    NSDictionary *addrDic = [JSONParser parseToDictionaryWithString:self.userInfoModel.after_address];
    
    self.addressModel = [AddressModel getAddressModel:addrDic];
    self.shippingUserNameTF.text = self.addressModel.consignee;
    self.cellPhoneTF.text = self.addressModel.mobile;
    self.cityLab.text = [NSString stringWithFormat:@"%@ %@ %@",self.addressModel.province,self.addressModel.city,self.addressModel.area];
    self.mailCodeTF.text = self.addressModel.postcode;
    if (self.addressModel.address.length > 0) {
        self.detailTV.text = self.addressModel.address;
        self.hideLab.hidden = YES;
    }else{
        self.hideLab.hidden = NO;
    }
    if (addrDic == nil) {
        self.cityLab.text = @"省、市、区";
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self saveAct:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)chooseCityAct:(UIButton *)sender {
    __weak ShippingAddressViewController *weakSelf = self;
    [[CustomPickView getInstance] showProvicePick:weakSelf.currentModel.area_id valueChange:^(NSString *str, NSInteger component) {
        
    } select:^(id content) {
        RecieveAddressModel *model = content;
        weakSelf.currentModel.distrct = model.distrct;
        weakSelf.currentModel.provice = model.provice;
        weakSelf.currentModel.city = model.city;
        weakSelf.currentModel.area_id = model.area_id;
        weakSelf.addressModel.province = model.provice;
        weakSelf.addressModel.city = model.city;
        weakSelf.addressModel.area = model.distrct;
        weakSelf.addressModel.postcode = model.area_id;
        
        weakSelf.currentModel.area = [NSString stringWithFormat:@"%@ %@ %@",model.provice,model.city,model.distrct];
        weakSelf.cityLab.text = weakSelf.currentModel.area;
        weakSelf.mailCodeTF.text = [NSString stringWithFormat:@"%@",model.area_id];
    } disSelect:^(id content) {
        
    }];
}

- (IBAction)saveAct:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.shippingUserNameTF.text.length < 1) {
        [self showHint:@"请填写姓名"];
        return;
    }
    if (self.cellPhoneTF.text.length < 1) {
        [self showHint:@"请填写手机号码"];
        return;
    }
    if (![self isValidateMobile:_cellPhoneTF.text]) {
        [self showHint:@"手机号码有误"];
        return;
    }
    if (self.cityLab.text.length < 1) {
        [self showHint:@"请选择区域"];
        return;
    }
    if (self.mailCodeTF.text.length < 1) {
        [self showHint:@"请输入邮政编码"];
        return;
    }
    if (self.detailTV.text.length < 1) {
        [self showHint:@"请输入详细地址"];
        return;
    }
    [self saveAddress];
}

- (BOOL) isValidateMobile:(NSString *)mobile {
    if (mobile && mobile.length == 11 && [mobile characterAtIndex:0] == '1') {
        return YES;
    }
    return NO;
}

#pragma mark - UITextFieldDelegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length > 0) {
        _hideLab.hidden = YES;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        _hideLab.hidden = NO;
    }
}
@end
