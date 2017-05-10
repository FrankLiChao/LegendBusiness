//
//  AddGoodsCell.m
//  legend_business_ios
//
//  Created by heyk on 16/3/2.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "AddGoodsCell.h"

@implementation AddGoodsCell



@end


@implementation AddGoodsCell1

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (AddGoodsCell1*)createCellWithNib{

    AddGoodsCell1 *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"AddGoodsCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[AddGoodsCell1 class]]){
            cell = (AddGoodsCell1 *)obj;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [UitlCommon setFlatWithView:cell.homePageImageView radius:0 borderColor:[Configure SYS_UI_COLOR_LINE_COLOR] borderWidth:0.5];
            [UitlCommon setFlatWithView:cell.coverpImageView radius:0 borderColor:[Configure SYS_UI_COLOR_LINE_COLOR] borderWidth:0.5];
            
            cell.homePageLabel.hidden = YES;
            cell.coverLabel.hidden = YES;
            
            [cell.titleField addTarget:cell action:@selector(titleChanged:) forControlEvents:UIControlEventEditingChanged];
            break;
        }
    }
    return cell;
    
}

- (void)titleChanged:(UITextField*)text{

    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsTitleChange:)]) {
        [self.delegate goodsTitleChange:text.text];
    }
}

- (CustomUploadImageView*)homePageImage{

    for (UIView *view in self.homePageImageView.subviews) {
        if ([view isKindOfClass:[CustomUploadImageView class]]) {
            return (CustomUploadImageView*)view;
        }
    }
    return nil;
}
- (CustomUploadImageView*)coverImage{
    for (UIView *view in self.coverpImageView.subviews) {
        if ([view isKindOfClass:[CustomUploadImageView class]]) {
            return (CustomUploadImageView*)view;
        }
    }
    return nil;
}

- (IBAction)clickAddHomePage:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAddHomePageImage)]) {
        
        [self.delegate clickAddHomePageImage];
    }
}

- (IBAction)clickAddCoverImage:(id)sender{

    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAddCoverImage)]) {
        
        [self.delegate clickAddCoverImage];
    }
}
@end



@implementation AddGoodsCell2

+ (AddGoodsCell2*)createCellWithNib{
    
    AddGoodsCell2 *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"AddGoodsCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[AddGoodsCell2 class]]){
            cell = (AddGoodsCell2 *)obj;

            
            break;
        }
    }
    return cell;
}


@end

@implementation AddGoodsCell3

+ (AddGoodsCell3*)createCellWithNib{
    
    AddGoodsCell3 *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"AddGoodsCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[AddGoodsCell3 class]]){
            cell = (AddGoodsCell3 *)obj;
            
            
            break;
        }
    }
    return cell;
}


@end


@implementation AddGoodsCell4

+ (AddGoodsCell4*)createCellWithNib{
    
    AddGoodsCell4 *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"AddGoodsCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[AddGoodsCell4 class]]){
            cell = (AddGoodsCell4 *)obj;
        
            break;
        }
    }
    return cell;
}


- (IBAction)clickRemoveAttr:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteAttributionCell:)]) {
        [self.delegate deleteAttributionCell:self ];
    }
}


@end


@implementation AddGoodsCell5

+ (AddGoodsCell5*)createCellWithNib{
    
    AddGoodsCell5 *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"AddGoodsCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[AddGoodsCell5 class]]){
            cell = (AddGoodsCell5 *)obj;
            
            break;
        }
    }
    return cell;
}



@end

@implementation AddGoodsCell6

+ (AddGoodsCell6*)createCellWithNib{
    
    AddGoodsCell6 *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"AddGoodsCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[AddGoodsCell6 class]]){
            cell = (AddGoodsCell6 *)obj;
            
            break;
        }
    }
    return cell;
}

- (IBAction)clickAddNewSpec:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addNewAttributin)]) {
        [self.delegate addNewAttributin ];
    }
}


@end


@implementation AddGoodsCell7

+ (AddGoodsCell7*)createCellWithNib{
    
    AddGoodsCell7 *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"AddGoodsCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[AddGoodsCell7 class]]){
            cell = (AddGoodsCell7 *)obj;
            
            break;
        }
    }
    return cell;
}



@end


@implementation AddGoodsCell8

+ (AddGoodsCell8*)createCellWithNib{
    
    AddGoodsCell8 *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"AddGoodsCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[AddGoodsCell8 class]]){
            cell = (AddGoodsCell8 *)obj;
            
            break;
        }
    }
    return cell;
}

- (IBAction)swicthValue:(UISwitch*)switchControl{

    if (self.delegate && [self.delegate respondsToSelector:@selector(switchValueChanged:)]) {
        [self.delegate switchValueChanged:switchControl.on];
    }
}

@end


@implementation AddGoodsCell9

+ (AddGoodsCell9*)createCellWithNib{
    
    AddGoodsCell9 *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"AddGoodsCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[AddGoodsCell9 class]]){
            cell = (AddGoodsCell9 *)obj;
            
            break;
        }
    }
    return cell;
}


@end


@implementation AddGoodsCell10

+ (AddGoodsCell10*)createCellWithNib{
    
    AddGoodsCell10 *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"AddGoodsCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[AddGoodsCell10 class]]){
            cell = (AddGoodsCell10 *)obj;
            
            break;
        }
    }
    return cell;
}


@end

