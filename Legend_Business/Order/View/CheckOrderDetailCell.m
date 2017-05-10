//
//  CheckOrderDetailCell.m
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/3.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "CheckOrderDetailCell.h"
#import "MJExtension.h"

@interface CheckOrderDetailCell() {
    
    UILabel *goodAllPriceLabel;
    UILabel *freePriceLabel;
    UILabel *postageLabel;
    UIView  *detailView;
}


@end

@implementation CheckOrderDetailCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    CheckOrderDetailCell *cell = [self appearance];
    
    cell.topBarHeight = 110;
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        

        
        detailView = [UIView new];
        detailView.backgroundColor = [UIColor  whiteColor];
        [self.contentView addSubview:detailView];
        
        
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = [UIColor  whiteColor];
        [self.contentView addSubview:bottomView];
        
        
        
        UILabel *goodAllPriceTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        goodAllPriceTitleLabel.text = @"订单总价";
        goodAllPriceTitleLabel.backgroundColor = [UIColor clearColor];
        goodAllPriceTitleLabel.textAlignment = NSTextAlignmentLeft;
        goodAllPriceTitleLabel.font = [UIFont systemFontOfSize:15];
        goodAllPriceTitleLabel.textColor = [Configure SYS_UI_COLOR_TEXT_GRAY];
        [bottomView addSubview:goodAllPriceTitleLabel];
        
        
        goodAllPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        goodAllPriceLabel.backgroundColor = [UIColor clearColor];
        goodAllPriceLabel.textAlignment = NSTextAlignmentRight;
        goodAllPriceLabel.font = [UIFont systemFontOfSize:15];
        goodAllPriceLabel.textColor = [Configure SYS_UI_COLOR_TEXT_BLACK];
        [bottomView addSubview:goodAllPriceLabel];
        
        
        
        
        UILabel *freePriceTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        freePriceTitleLabel.backgroundColor = [UIColor clearColor];
        freePriceTitleLabel.textAlignment = NSTextAlignmentLeft;
        freePriceTitleLabel.font = [UIFont systemFontOfSize:15];
        freePriceTitleLabel.textColor = [Configure SYS_UI_COLOR_TEXT_GRAY];
        freePriceTitleLabel.text = @"返现";
        [bottomView addSubview:freePriceTitleLabel];
        
        
        freePriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        freePriceLabel.backgroundColor = [UIColor clearColor];
        freePriceLabel.textAlignment = NSTextAlignmentRight;
        freePriceLabel.font =  [UIFont systemFontOfSize:15];
        freePriceLabel.textColor = [Configure SYS_UI_COLOR_TEXT_BLACK];;
        [bottomView addSubview:freePriceLabel];
        
        
        
        
        
        UILabel *postageTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        postageTitleLabel.backgroundColor = [UIColor clearColor];
        postageTitleLabel.textAlignment = NSTextAlignmentLeft;
        postageTitleLabel.font = [UIFont systemFontOfSize:15];
        postageTitleLabel.textColor =  [Configure SYS_UI_COLOR_TEXT_GRAY];;
        postageTitleLabel.text = @"邮费";
        [bottomView addSubview:postageTitleLabel];
        
        
        postageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        postageLabel.backgroundColor = [UIColor clearColor];
        postageLabel.textAlignment = NSTextAlignmentRight;
        postageLabel.font = [UIFont systemFontOfSize:15];
        postageLabel.textColor = [Configure SYS_UI_COLOR_TEXT_BLACK];;
        [bottomView addSubview:postageLabel];
        
        
        
        
        UIView *bottomSpreateLine = [[UIView alloc] initWithFrame:CGRectZero];
        bottomSpreateLine.backgroundColor =  [Configure SYS_UI_COLOR_LINE_COLOR];;
        [self.contentView addSubview:bottomSpreateLine];
        
        [detailView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [detailView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [detailView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        
        
         [bottomSpreateLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
         [bottomSpreateLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
         [bottomSpreateLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:detailView];
        [bottomSpreateLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:bottomView];
        [bottomSpreateLine autoSetDimension:ALDimensionHeight toSize:1];
      
        
        [bottomView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [bottomView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];

        
        CheckOrderDetailCell *cell = [CheckOrderDetailCell appearance];
        [bottomView autoSetDimension:ALDimensionHeight toSize:cell.topBarHeight];
        
        

        [bottomView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView];
        [bottomView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:bottomSpreateLine];
        [bottomView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
        
 
        
       [freePriceTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bottomView withOffset:10];
        [freePriceTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bottomView  withOffset:10];
        [freePriceTitleLabel autoSetDimension:ALDimensionHeight toSize:30];
        [freePriceTitleLabel autoSetDimension:ALDimensionWidth toSize:60];
        
        
        [freePriceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:freePriceTitleLabel];
        [freePriceLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bottomView withOffset:-10];
        [freePriceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bottomView  withOffset:10];
        [freePriceLabel autoSetDimension:ALDimensionHeight toSize:30];

        
        
        [postageTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bottomView withOffset:10];
        [postageTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:freePriceTitleLabel ];
        [postageTitleLabel autoSetDimension:ALDimensionHeight toSize:30];
        [postageTitleLabel autoSetDimension:ALDimensionWidth toSize:60];
        
        
        [postageLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:postageTitleLabel];
        [postageLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bottomView withOffset:-10];
        [postageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:freePriceTitleLabel];
        [postageLabel autoSetDimension:ALDimensionHeight toSize:30];

        
        
        [goodAllPriceTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bottomView withOffset:10];
        [goodAllPriceTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:postageTitleLabel ];
        [goodAllPriceTitleLabel autoSetDimension:ALDimensionHeight toSize:30];
        [goodAllPriceTitleLabel autoSetDimension:ALDimensionWidth toSize:100];
        
        
        
        [goodAllPriceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:goodAllPriceTitleLabel];
        [goodAllPriceLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bottomView withOffset:-10];
        [goodAllPriceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:postageTitleLabel];
        [goodAllPriceLabel autoSetDimension:ALDimensionHeight toSize:30];
        
        
    }
    return self;
}


- (void)setUIWithModel:(OrderModel*)model{

    freePriceLabel.text = [NSString stringWithFormat:@"¥%@",model.share_money];
    postageLabel.text = [NSString stringWithFormat:@"¥%@",model.shipping_fee];
    goodAllPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.order_amount];
    
    for (UIView *view in detailView.subviews) {
        [view removeFromSuperview];
    }
    
    UIView *lastView = nil;
    
    for (int i = 0;i<model.goods_list.count ;i++) {
        
        GoodsInfo *goods  = [model.goods_list objectAtIndex:i];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageV sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:[UIImage imageNamed:@"默认"]];
        [detailView addSubview:imageV];
        
        UILabel *goodTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        goodTitleLabel.backgroundColor = [UIColor clearColor];
        goodTitleLabel.font = [UIFont systemFontOfSize:14];
        goodTitleLabel.textColor =  [Configure SYS_UI_COLOR_TEXT_GRAY];
        goodTitleLabel.numberOfLines = 0;
        goodTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        goodTitleLabel.text = goods.goods_name;
        [detailView addSubview:goodTitleLabel];
        
        
        UILabel *attrLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        attrLabel.backgroundColor = [UIColor clearColor];
        attrLabel.font = [UIFont systemFontOfSize:12];
        attrLabel.textColor =  [Configure SYS_UI_COLOR_BG_RED];;
        
    
        NSMutableString *str = [NSMutableString string];
        for (GoodsAttr *atrr in goods.goods_attr) {
            
            [str appendFormat:@"%@ %@  ",atrr.name,atrr.value];
            
        }
        
        attrLabel.text = str  ;
        [detailView addSubview:attrLabel];
        
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.font = [UIFont systemFontOfSize:12];
        numLabel.textColor =  [Configure SYS_UI_COLOR_BG_RED];;
        numLabel.text = [NSString stringWithFormat:@"x%@",goods.goods_number];
        numLabel.textAlignment = NSTextAlignmentRight;
        [detailView addSubview:numLabel];
        
        
        [imageV autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:imageV];
        [imageV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [imageV autoSetDimension:ALDimensionWidth toSize:60];
        
        if (lastView){
             [imageV autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lastView withOffset:10];
        }
        else{
            [imageV autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        }

 
        
        [goodTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageV withOffset:10];
        [goodTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [goodTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:imageV];
        [goodTitleLabel autoSetDimension:ALDimensionHeight toSize:40];
        
        

        [numLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [numLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:goodTitleLabel];
        [numLabel autoSetDimension:ALDimensionHeight toSize:20];
        [numLabel autoSetDimension:ALDimensionWidth toSize:40];
        


        
        [attrLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageV withOffset:10];
        [attrLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:numLabel ];
        [attrLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:goodTitleLabel];
        [attrLabel autoSetDimension:ALDimensionHeight toSize:20];
       
        
        

        if (model.goods_list.count>1 && i!= model.goods_list.count - 1) {
            UIView *spreate = [[UIView alloc] initWithFrame:CGRectZero];
            spreate.backgroundColor = [Configure SYS_UI_COLOR_LINE_COLOR];
            [detailView addSubview:spreate];
            
            [spreate autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
            [spreate autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
            [spreate autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageV withOffset:10];
            [spreate autoSetDimension:ALDimensionHeight toSize:1];
            
            lastView = spreate;
        }
    }
    

    
}

+ (float)cellHeight:(OrderModel*)model{
    

    
    float height = 0;
    if (model && model.goods_list.count > 0) {
        
        height =    model.goods_list.count * 80 + (model.goods_list.count - 1)*1;
    }
    CheckOrderDetailCell *cell = [CheckOrderDetailCell appearance];
    height += cell.topBarHeight;

    return height;
}


@end
