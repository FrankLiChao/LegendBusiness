//
//  MUPromotionListCell.m
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/6.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "MyPromotionListCell.h"

@implementation MyPromotionListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickEdit:(id)sender{

    if (_delegate && [_delegate respondsToSelector:@selector(clickEditPromotion:)]) {
        [_delegate clickEditPromotion:self];
    }
}

- (void)setUIWithModel:(PromotionListModel*)model{

    if ([model advStatus] == AdvStatus_Done ||
        [model advStatus] == AdvStatus_Doing ) {
        self.editButton.hidden = YES;
        
        if ([model advStatus] == AdvStatus_Doing) {
             self.statusLabel.text = @"正在进行";
        }
        else if([model advStatus] == AdvStatus_Done){
             self.statusLabel.text = @"已完成";
        }
       
        
      NSMutableAttributedString *count =   [UitlCommon setKeyStringAttr:model.finish_number
                             fullStr:[NSString stringWithFormat:@"%@/%@",model.finish_number,model.target_number]
                            keyColor:[Configure SYS_UI_COLOR_TEXT_BLACK]
                          otherColor:[Configure SYS_UI_COLOR_TEXT_GRAY]];
        
        self.numLabel.attributedText = count;
        
        NSMutableAttributedString *price =   [UitlCommon setKeyStringAttr:model.remainder_money
                                                                  fullStr:[NSString stringWithFormat:@"%@/%@",model.remainder_money,model.target_money]
                                                                 keyColor:[Configure SYS_UI_COLOR_TEXT_BLACK]
                                                               otherColor:[Configure SYS_UI_COLOR_TEXT_GRAY]];
        
        self.priceLabel.attributedText = price;
        
    }
    else{
        self.editButton.hidden = YES;
        
        
        if ([model advStatus] == AdvStatus_UnPay) {
            self.statusLabel.text = @"未付款";
        }
        else if([model advStatus] == AdvStatus_Waiting){
            self.statusLabel.text = @"审核中";
        }
        else if([model advStatus] == AdvStatus_Not_Passed){
            self.statusLabel.text = @"审核不通过";
        }

        NSMutableAttributedString *count =   [UitlCommon setKeyStringAttr:nil
                                                                  fullStr:[NSString stringWithFormat:@"%@",model.target_number]
                                                                 keyColor:[Configure SYS_UI_COLOR_TEXT_GRAY]
                                                               otherColor:[Configure SYS_UI_COLOR_TEXT_BLACK]];
        
        self.numLabel.attributedText = count;
        
        NSMutableAttributedString *price =   [UitlCommon setKeyStringAttr:nil
                                                                  fullStr:[NSString stringWithFormat:@"%@",model.target_money]
                                                                 keyColor:[Configure SYS_UI_COLOR_TEXT_GRAY]
                                                               otherColor:[Configure SYS_UI_COLOR_TEXT_BLACK]];
        
        self.priceLabel.attributedText = price;

    }
    
    self.titleLabel.text = model.title;
}
@end
