//
//  CommentsCell.m
//  legend_business_ios
//
//  Created by heyk on 16/3/4.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "CommentsCell.h"
@implementation CustomButton

@end

@implementation CommentsCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    CommentsCell *cell = [self appearance];
    
    cell.imageHeight = 70;
    cell.goodsAttrHeight = 20;
    cell.commentFont = [UIFont systemFontOfSize:12];
}



- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickReplay:(id)sender{

    if (self.delegate && [self.delegate respondsToSelector:@selector(replyComments:)]) {
        [self.delegate replyComments:self];
    }


}

+ (float)cellHeight:(CommentsModel*)model{

    CommentsCell *cell = [self appearance];
    
    float height = 50 ;
    
    if (![UitlCommon isNull:model.content ]) {
        
        CGSize size = [model.content sizeWithFont:cell.commentFont byWidth:[UIScreen mainScreen].bounds.size.width - 70];
        height += size.height;
        height +=5;
    }
    if (model.comment_img && model.comment_img.count > 0) {
        height += cell.imageHeight;
    }

    height += 10;
    NSString *good_des = [NSString stringWithFormat:@"%@ %@",model.goods_name?model.goods_name:@"",[model goodsAttr]];
    if (![UitlCommon isNull:good_des]) {
        height += cell.goodsAttrHeight;
    }

    if (![UitlCommon isNull:model.reply_content]) {
        
        CGSize size = [model.reply_content sizeWithFont:cell.commentFont byWidth:[UIScreen mainScreen].bounds.size.width - 70];
        height +=size.height;
     
    }
    height +=20;
    return height;
}

- (void)setUIWithModel:(CommentsModel*)model{


    CommentsCell *cell = [CommentsCell appearance];
    
    
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:model.user_avatar] placeholderImage:[UIImage imageNamed:@"默认"]];
    [UitlCommon setFlatWithView:_headImageV radius:20];
    
    _nameLabel.text = model.user_name;
    _timeLabel.text = [model dateStr];
    _commentsLabel.text = model.content;
  

    NSString *good_des = [NSString stringWithFormat:@"%@ %@",model.goods_name?model.goods_name:@"",[model goodsAttr]];
    _attrLabel.text = good_des;
    if ([UitlCommon isNull:good_des]) {
        _goodsInfoHeight.constant = 0;
    }
    else _goodsInfoHeight.constant = cell.goodsAttrHeight;
    
    
    if ([UitlCommon isNull:model.reply_content]) {
       
        self.replyLabelHeight.constant = 0;
        self.replayButton.hidden = NO;
        [UitlCommon setFlatWithView:_replayButton radius:10 ];

    }
    else{
       
        self.replayButton.hidden = YES;
         _replyLabel.text = [NSString stringWithFormat:@"回复 : %@",model.reply_content];
         CGSize size = [_replyLabel.text sizeWithFont:cell.commentFont byWidth:[UIScreen mainScreen].bounds.size.width - 70];
        self.replyLabelHeight.constant  = size.height;
    }
    
    for (UIImageView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    if (!model.comment_img || model.comment_img.count <= 0) {
        self.scrollHeight.constant = 0;
    }
    else{
      
        CommentsCell *cell = [CommentsCell appearance];
        self.scrollHeight.constant = cell.imageHeight;
        
        for (int i = 0; i<model.comment_img.count; i++) {
            NSString *url = [model.comment_img objectAtIndex:i];
            UIImageView *imageV = [UIImageView new];
            [imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"默认"]];
            [_scrollView addSubview:imageV];
            
            imageV.frame = CGRectMake(i*(70), 10, 60, 60);
            
            CustomButton  *button = [CustomButton buttonWithType:UIButtonTypeCustom];
            button.imageUrl = url;
            button.frame = imageV.frame;
            [button addTarget:self action:@selector(checkBigImage:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
            
        }
        _scrollView.contentSize = CGSizeMake(model.comment_img.count * 70, 0);
        
    }
    [self setStar:model.comment_rank ];
}


- (void)setStar:(NSString*)star{

    if ([star floatValue]>=5.0){
        _startV1.image = [UIImage imageNamed:@"star_select"];
        _startV2.image = [UIImage imageNamed:@"star_select"];
        _startV3.image = [UIImage imageNamed:@"star_select"];
        _startV4.image = [UIImage imageNamed:@"star_select"];
        _startV5.image = [UIImage imageNamed:@"star_select"];
    }
    else if([star floatValue]<5.0 && [star floatValue]>4.0){
        _startV1.image = [UIImage imageNamed:@"star_select"];
        _startV2.image = [UIImage imageNamed:@"star_select"];
        _startV3.image = [UIImage imageNamed:@"star_select"];
        _startV4.image = [UIImage imageNamed:@"star_select"];
        _startV5.image = [UIImage imageNamed:@"start_half"];
    }
    else if([star floatValue]==4.0){
        
        _startV1.image = [UIImage imageNamed:@"star_select"];
        _startV2.image = [UIImage imageNamed:@"star_select"];
        _startV3.image = [UIImage imageNamed:@"star_select"];
        _startV4.image = [UIImage imageNamed:@"star_select"];
        _startV5.image = [UIImage imageNamed:@"star_unselect"];
        
    }
    else if([star floatValue]<4.0 && [star floatValue]>3.0){
        
        _startV1.image = [UIImage imageNamed:@"star_select"];
        _startV2.image = [UIImage imageNamed:@"star_select"];
        _startV3.image = [UIImage imageNamed:@"star_select"];
        _startV4.image = [UIImage imageNamed:@"start_half"];
        _startV5.image = [UIImage imageNamed:@"star_unselect"];
        
    }
    else if([star floatValue]==3.0){
        
        _startV1.image = [UIImage imageNamed:@"star_select"];
        _startV2.image = [UIImage imageNamed:@"star_select"];
        _startV3.image = [UIImage imageNamed:@"star_select"];
        _startV4.image = [UIImage imageNamed:@"star_unselect"];
        _startV5.image = [UIImage imageNamed:@"star_unselect"];
        
    }
    else if([star floatValue]<3.0 && [star floatValue]>2.0){
        
        _startV1.image = [UIImage imageNamed:@"star_select"];
        _startV2.image = [UIImage imageNamed:@"star_select"];
        _startV3.image = [UIImage imageNamed:@"start_half"];
        _startV4.image = [UIImage imageNamed:@"star_unselect"];
        _startV5.image = [UIImage imageNamed:@"star_unselect"];
        
    }
    else if([star floatValue]  == 2.0){
        
        _startV1.image = [UIImage imageNamed:@"star_select"];
        _startV2.image = [UIImage imageNamed:@"star_select"];
        _startV3.image = [UIImage imageNamed:@"star_unselect"];
        _startV4.image = [UIImage imageNamed:@"star_unselect"];
        _startV5.image = [UIImage imageNamed:@"star_unselect"];
        
    }
    else if([star floatValue]<2.0 && [star floatValue]>1.0){
        
        _startV1.image = [UIImage imageNamed:@"star_select"];
        _startV2.image = [UIImage imageNamed:@"start_half"];
        _startV3.image = [UIImage imageNamed:@"star_unselect"];
        _startV4.image = [UIImage imageNamed:@"star_unselect"];
        _startV5.image = [UIImage imageNamed:@"star_unselect"];
        
    }
    else if([star floatValue]  == 1.0){
        
        _startV1.image = [UIImage imageNamed:@"star_select"];
        _startV2.image = [UIImage imageNamed:@"star_unselect"];
        _startV3.image = [UIImage imageNamed:@"star_unselect"];
        _startV4.image = [UIImage imageNamed:@"star_unselect"];
        _startV5.image = [UIImage imageNamed:@"star_unselect"];
        
    }
    else if([star floatValue]<1.0 && [star floatValue]>0.0){
        
        _startV1.image = [UIImage imageNamed:@"start_half"];
        _startV2.image = [UIImage imageNamed:@"star_unselect"];
        _startV3.image = [UIImage imageNamed:@"star_unselect"];
        _startV4.image = [UIImage imageNamed:@"star_unselect"];
        _startV5.image = [UIImage imageNamed:@"star_unselect"];
        
    }
    else{
        _startV1.image = [UIImage imageNamed:@"star_unselect"];
        _startV2.image = [UIImage imageNamed:@"star_unselect"];
        _startV3.image = [UIImage imageNamed:@"star_unselect"];
        _startV4.image = [UIImage imageNamed:@"star_unselect"];
        _startV5.image = [UIImage imageNamed:@"star_unselect"];
    }
    
}

- (void)checkBigImage:(CustomButton*)button{

    if (_delegate && [_delegate respondsToSelector:@selector(checkImageDetail:)]) {
        [_delegate checkImageDetail:button.imageUrl];
    }
}

@end
