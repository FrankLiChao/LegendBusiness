//
//  CustomerSeverListCell.m
//  legend_business_ios
//
//  Created by heyk on 16/3/4.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "CustomerSeverListCell.h"
#import "CommentsCell.h"




@implementation CustomerSeverListCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    CustomerSeverListCell *cell = [self appearance];
    
    cell.reasonFont = [UIFont systemFontOfSize:14];
    cell.expressFont = [UIFont systemFontOfSize:13];
    cell.imageHeight = 70;
    cell.buyerInfoHeight = 70;
    cell.footBarHeight = 50;
}



- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showUnDealCellWithModel:(SellerAfterListModel*)model{

    
    _agreeRetureButton.hidden = NO;
    _refuseButton.hidden = NO;
    
    _sureRetureButton.hidden = YES;
    _expressNumberLabel.hidden = YES;
    
    [UitlCommon setFlatWithView:_agreeRetureButton radius:[Configure SYS_CORNERRADIUS] borderColor:[Configure SYS_UI_COLOR_LINE_COLOR] borderWidth:0.5];
    [UitlCommon setFlatWithView:_refuseButton radius:[Configure SYS_CORNERRADIUS] borderColor:[Configure SYS_UI_COLOR_LINE_COLOR] borderWidth:0.5];
    
    
    [self setUIWithModel:model];

    
}
- (void)showDealingCellWithModel:(SellerAfterListModel*)model{

    _agreeRetureButton.hidden = YES;
    _refuseButton.hidden = YES;
    
    _sureRetureButton.hidden = NO;
    _expressNumberLabel.hidden = NO;
    
    
    NSString *str1 = @"运单号 : ";
    NSString *str2 = model.express_num?model.express_num:@"";
    
    NSString *express = [NSString stringWithFormat:@"%@%@",str1,str2];
    
    NSMutableAttributedString *attrExpress = [[NSMutableAttributedString alloc] initWithString:express];
    
    [attrExpress addAttribute:NSForegroundColorAttributeName  value:[Configure SYS_UI_COLOR_TEXT_GRAY]  range:NSMakeRange(0, str1.length)];
    [attrExpress addAttribute:NSForegroundColorAttributeName  value:[Configure SYS_UI_COLOR_TEXT_BLACK]  range:NSMakeRange(str1.length, str2.length)];
    CustomerSeverListCell *cell = [CustomerSeverListCell appearance];
    [attrExpress addAttribute:NSFontAttributeName value:cell.expressFont range:NSMakeRange(0, str1.length + str2.length)];
    self.expressNumberLabel.attributedText = attrExpress;

    [UitlCommon setFlatWithView:_sureRetureButton radius:[Configure SYS_CORNERRADIUS] borderColor:[Configure SYS_UI_COLOR_LINE_COLOR] borderWidth:0.5];

    [self setUIWithModel:model];
    
    if ([model.after_type intValue] == 1) {//退货
        
        [self.sureRetureButton setTitle:@"确认收货" forState:UIControlStateNormal];
    }
    else if([model.after_type intValue] == 2){//换货
        [self.sureRetureButton setTitle:@"确认收货并重新发货" forState:UIControlStateNormal];
        self.sureRetureButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    
}

- (void)setUIWithModel:(SellerAfterListModel*)model{

    self.reasonLabel.attributedText = [CustomerSeverListCell reason:model];
    
    if (model.after_img.count > 0) {
        
        for (UIImageView *view in _imageScrollView.subviews) {
            [view removeFromSuperview];
        }
        
        for (int i = 0;i<model.after_img.count;i++) {
            
            NSString *url = [model.after_img objectAtIndex:i];
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i*(60+10), 10, 60, 60)];
            [imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"默认"]];
            [_imageScrollView addSubview:imageV];
            
            CustomButton  *button = [CustomButton buttonWithType:UIButtonTypeCustom];
            button.imageUrl = url;
            button.frame = imageV.frame;
            [button addTarget:self action:@selector(checkBigImage:) forControlEvents:UIControlEventTouchUpInside];
            [_imageScrollView addSubview:button];
            
        }
        _imageScrollView.contentSize = CGSizeMake(model.after_img.count * 70 , 0);
        
        CustomerSeverListCell *cell = [CustomerSeverListCell appearance];
         self.imageConstaitHeight.constant =  cell.imageHeight;
    }
    else self.imageConstaitHeight.constant = 0;
    
    [UitlCommon setFlatWithView:_buyerInfoView radius:[Configure SYS_CORNERRADIUS]];
    
    [self.buyerHeadView sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb] placeholderImage:[UIImage imageNamed:@"默认"]];
    self.orderLabel.text = [NSString stringWithFormat:@"订单号:  %@",model.after_num];
    self.buyerNameLabel.text = model.consignee;
    self.buyerPhoneLabel.text = model.mobile;
    
    if ([model.after_type intValue] == 1) {//退货
        
        [self.agreeRetureButton setTitle:@"同意退货" forState:UIControlStateNormal];
    }
    else if([model.after_type intValue] == 2){//换货
          [self.agreeRetureButton setTitle:@"同意换货" forState:UIControlStateNormal];
    }
}


+ (NSMutableAttributedString*)reason:(SellerAfterListModel*)model{


    
    NSString *str1 = @"退货理由 : ";
    NSString *str2 = model.after_reason?model.after_reason:@" ";
    
    NSString *express = [NSString stringWithFormat:@"%@%@",str1,str2];
    
    NSMutableAttributedString *attrExpress = [[NSMutableAttributedString alloc] initWithString:express];
    [attrExpress addAttribute:NSForegroundColorAttributeName  value:[Configure SYS_UI_COLOR_BG_RED]  range:NSMakeRange(0, str1.length)];
    [attrExpress addAttribute:NSForegroundColorAttributeName  value:[Configure SYS_UI_COLOR_TEXT_BLACK]  range:NSMakeRange(str1.length, str2.length)];
    
    CustomerSeverListCell *cell = [CustomerSeverListCell appearance];
    [attrExpress addAttribute:NSFontAttributeName value:cell.reasonFont range:NSMakeRange(0, str1.length + str2.length)];
    
    return attrExpress;
    
}

+ (float)cellHeight:(SellerAfterListModel*)model{

    float height = 10;
    

    CustomerSeverListCell *cell = [CustomerSeverListCell appearance];
    NSMutableAttributedString *reason = [CustomerSeverListCell reason:model];
    CGSize reasonSize = [reason sizeWithWidth:[UIScreen mainScreen].bounds.size.width - 20];
    height += reasonSize.height;
    
    if (!model.after_img || model.after_img.count <= 0) {
    
        cell.imageHeight = 0;
    }
    
    height += cell.imageHeight;
    height += 10;
    height += cell.buyerInfoHeight;
    height += 10;
    height += 1;
    height += cell.footBarHeight;
    
    return height;
}

//同意退货
- (IBAction)clickAgreeAfter:(id)sender{

    if (self.delegate && [self.delegate respondsToSelector:@selector(agreeRetueAction:)]) {
        [self.delegate agreeRetueAction:self];
    }

}

//拒绝申请
- (IBAction)clickRefuse:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(refuseAction:)]) {
        [self.delegate refuseAction:self];
    }
    
}

//确认收货
- (IBAction)clickSureRecieve:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureReciveAction:)]) {
        [self.delegate sureReciveAction:self];
    }
}

- (IBAction)clickCheckOrderDetail:(id)sender{

    if (self.delegate && [self.delegate respondsToSelector:@selector(checkOrderDetail:)]) {
        [self.delegate checkOrderDetail:self];
    }
}

- (void)checkBigImage:(CustomButton*)button{
    
    if (_delegate && [_delegate respondsToSelector:@selector(checkPicDetail:)]) {
        [_delegate checkPicDetail:button.imageUrl];
    }
}

@end
