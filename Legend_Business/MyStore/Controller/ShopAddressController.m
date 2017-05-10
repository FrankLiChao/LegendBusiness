//
//  ShopAddressController.m
//  legend_business_ios
//
//  Created by Frank on 2016/12/14.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "ShopAddressController.h"
#import "RecieveAddressModel.h"
#import "CustomPickView.h"
#import "UserInfoModel.h"
#import "JSONParser.h"

@interface ShopAddressController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITextView *detailAdress;
@property (weak, nonatomic) IBOutlet UILabel *hideLab;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic, strong) RecieveAddressModel *currentModel;
@property (nonatomic,strong) NSMutableArray *addressArray;
@property (nonatomic,strong) UserInfoModel *userModel;

@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *street;

@end

@implementation ShopAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailAdress.delegate = self;
    self.saveBtn.layer.cornerRadius = 6;
    self.saveBtn.layer.masksToBounds = YES;
    self.addressArray = [NSMutableArray new];
    self.userModel = [SaveEngine getUserInfo];
    
    if (self.userModel.area_info.length > 0) {
        NSArray *addressA = [self.userModel.area_info componentsSeparatedByString:@","];
        if (addressA.count == 3) {
            self.province = addressA[0];
            self.city = addressA[1];
            self.area = addressA[2];
        }
        [self.selectBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.area] forState:UIControlStateNormal];
    }
    if (self.userModel.street_info.length > 0) {
        self.hideLab.hidden = YES;
        self.detailAdress.text = self.userModel.street_info?self.userModel.street_info:@"";
        self.street = self.userModel.street_info;
    }else {
        self.hideLab.hidden = NO;
    }
}



- (IBAction)selectEvent:(id)sender {
    [[CustomPickView getInstance] showProvicePick:self.currentModel.area_id valueChange:^(NSString *str, NSInteger component) {
        
    } select:^(id content) {
        self.currentModel = content;
        self.province = self.currentModel.provice;
        self.city = self.currentModel.city;
        self.area = self.currentModel.distrct;
        [self.selectBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.area] forState:UIControlStateNormal];
    } disSelect:^(id content) {
        
    }];
}


- (IBAction)saveButtonEvent:(id)sender {
    if ([self.selectBtn.titleLabel.text isEqualToString:@"省、市、区"]) {
        [self showHint:@"请选择区域"];
        return;
    }
    if (self.detailAdress.text.length < 1) {
        [self showHint:@"请输入详细地址"];
        return;
    }
    self.street = self.detailAdress.text;
    NSDictionary *dic = @{@"province":self.province,
                          @"city":self.city,
                          @"area":self.area,
                          @"street":self.street};
    NSString *addrStr = [JSONParser parseToStringWithDictionary:dic];
    [self changeUsrInfo:ChangeUserInfoType_Address value:addrStr comple:^(BOOL bSuccess, NSString *message) {
        [self showHint:@"店铺地址保存成功"];
        [self getUserInfo:^(UserInfoModel *model) {
            [self.navigationController popViewControllerAnimated:YES];
        } failed:^(NSString *errorDes) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }];
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

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.hideLab.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
