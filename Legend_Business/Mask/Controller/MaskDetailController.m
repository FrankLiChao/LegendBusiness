//
//  MaskDetailController.m
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/6.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "MaskDetailController.h"

@interface MaskDetailController ()

@property (nonatomic,weak) IBOutlet UIImageView *headImageView;
@property (nonatomic,weak) IBOutlet UILabel *percentLabel;
@property (nonatomic,weak) IBOutlet UILabel *totalLabel;
@property (nonatomic,weak) IBOutlet UILabel *totalShareNumLabel;

@property (nonatomic,weak) IBOutlet UILabel *priceLabel;
@property (nonatomic,weak) IBOutlet UILabel *shareNumLabel;
@property (nonatomic,weak) IBOutlet UILabel *finshTimeLabel;
@property (nonatomic,weak) IBOutlet UILabel *maskDetailLabel;

@property (nonatomic,strong) MaskInfoModel *model;





@end

@implementation MaskDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    self.title = @"任务详情";
    
    __weak typeof(self) weakSelf = self;
    
    [self showHudInView:self.view hint:@""];
    [self getMaskInfo:_maskId
              success:^(MaskInfoModel *model) {
                  [weakSelf hideHud];
                  weakSelf.model = model;
                  
                  [weakSelf reloadUI];
                  
              } failed:^(NSString *errorDes) {
                  [weakSelf hideHud];
                  [weakSelf showHint:errorDes];
              }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadUI{

    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.content_img?_model.content_img:@""] placeholderImage:[UIImage imageNamed:@"默认"]];
    _percentLabel.text = [NSString stringWithFormat:@"%@",_model.finish_number];
    
    _totalLabel.text =  [NSString stringWithFormat:@"/%d",[_model.target_number intValue]];
    _totalShareNumLabel.text = [NSString stringWithFormat:@"%d次",[_model.total_share intValue]];
    _priceLabel.text = [NSString stringWithFormat:@"%@元",_model.unit_price];
    _shareNumLabel.text = [NSString stringWithFormat:@"%@次",_model.demand];
    _finshTimeLabel.text = [NSString stringWithFormat:@"%@天",_model.time_limit];
    _maskDetailLabel.text = [NSString stringWithFormat:@"%@天",_model.desc];
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
