//
//  PrudctHeaderInfoCell.m
//  legend
//
//  Created by heyk on 16/1/12.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "PrudctHeaderInfoCell.h"
#import "UIImageView+WebCache.h"
#import "ProudctPropertySelectView.h"
#import "ProductModel.h"
#import "legend_business_ios-swift.h"

@interface PrudctHeaderInfoCell()

@property (nonatomic,strong)ProductModel *currentModel;

@end

@implementation PrudctHeaderInfoCell


+ (void)initialize
{
    // UIAppearance Proxy Defaults
    PrudctHeaderInfoCell *cell = [self appearance];
    cell.inforDetailFont = [UIFont systemFontOfSize:14];
    cell.nameFont =  [UIFont systemFontOfSize:(14)];
    cell.priceFont =  [UIFont systemFontOfSize:(20)];
    cell.stockFont =  [UIFont systemFontOfSize:(12)];
    cell.freePostageFont = [UIFont systemFontOfSize:(12)];
    cell.infoTitleFont = [UIFont systemFontOfSize:(14)];
    cell.tipFont = [UIFont systemFontOfSize:(12)];
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInforDetailFont:(UIFont *)inforDetailFont
{
    _inforDetailFont = inforDetailFont;
    self.infoDetailLabel.font = inforDetailFont;
}

-(void)setNameFont:(UIFont *)nameFont{
    _nameFont = nameFont;
    self.nameLabel.font = _nameFont;
}

-(void)setPriceFont:(UIFont *)priceFont{
    _priceFont = priceFont;
    self.priceLabel.font = priceFont;
}

-(void)setStockFont:(UIFont *)stockFont{

    _stockFont = stockFont;
    self.stockLabel.font = stockFont;
}

-(void)setInfoTitleFont:(UIFont *)infoTitleFont{
    _infoTitleFont = infoTitleFont;
    self.infoTitleLabel.font = infoTitleFont;
}

-(void)setTipFont:(UIFont *)tipFont{
    _tipFont = tipFont;
    self.sevenReturnButton.titleLabel.font = tipFont;
    self.saleFreeButton.titleLabel.font = tipFont;
}

-(void)setFreePostageFont:(UIFont *)freePostageFont{

    _freePostageFont = freePostageFont;
    self.freePostageLabel.font = _freePostageFont;
    self.postageLabel.font = _freePostageFont;
}

#pragma makr config
+(float)introduceImageHeight{
    return (317);
}
+(float)priceRowHeight{
    return (110);
}
+(float)tipRowHeight{
    return (45);
}
+(float)selectCountHeight{
    return (45);
}
+(float)spaceHeight{
    return (15);
}
+(float)productIntroduceHeight{
    return (50);
}

+(float)cellHeightWithModel:(ProductModel*)model{


    float height = [self  introduceImageHeight] + [self priceRowHeight] + [self selectCountHeight]+[self spaceHeight]+[self productIntroduceHeight];
    
//    if (!model.freePostage && [UitlCommon isNull:model.postoage]) {
//        height-=16;
//    }
//    
    //if(model.sevenReturnGuarantee || model.saleGuarantee){
        height += [self tipRowHeight]*2;
//    }
//    else{
//        height +=[self spaceHeight];
//    }
    
    PrudctHeaderInfoCell *cell = [PrudctHeaderInfoCell appearance];
    
    NSAttributedString *str = [PrudctHeaderInfoCell productInfoAttribution:model.goods_brief font:cell.inforDetailFont];
    
    CGSize infoSize = [str sizeWithWidth:[UIScreen mainScreen].bounds.size.width - 24]; //[model.productInfo sizeWithFont:cell.inforDetailFont byWidth:SYS_UI_WINSIZE_WIDTH - 24];
    
    height += infoSize.height;
    
    return height;
}


+(NSAttributedString*)productInfoAttribution:(NSString*)str font:(UIFont*)font{

    str = str?str:@"";
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0;
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    
    return string;
}

-(void)setUIWithMode:(ProductModel*)model{
    
    self.currentModel = model;
    
    for (UIView *view in _scrollContentView.subviews) {
        [view removeFromSuperview];
    }
    
    _pageControl.numberOfPages = 1;
    
    
    for (int i=0;i<model.gallery_list.count;i++) {
        
        ProductGalleryListModel * gallery = [model.gallery_list objectAtIndex:i];
        
        NSString *imageUrl = gallery.thumb_url;

        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i* [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [PrudctHeaderInfoCell introduceImageHeight])];
        
        [imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                  placeholderImage:[UIImage imageNamed:@"默认"]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        [_scrollContentView addSubview:imageV];
    }
    _scrollHeight.constant = [PrudctHeaderInfoCell introduceImageHeight];
    //_scrollWidth.constant = (model.imageUrls.count-1) * SYS_UI_WINSIZE_WIDTH;
    _scrollHeight.constant =  [UIScreen mainScreen].bounds.size.width;
    
    
    _nameLabel.text = model.goods_name;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.shop_price?model.shop_price:@""];
    _stockLabel.text = [NSString stringWithFormat:@"剩余：%@",model.goods_number?model.goods_number:@""];
   /* if (!model.freePostage) {
  
        _freePostageLabel.hidden = YES;

        if (![UitlCommon isNull:model.postoage]) {
            _postageLabel.hidden = NO;
            _postageLabel.text = [NSString stringWithFormat:@"邮费:%@",model.postoage];
            _priceBackHeight.constant = [PrudctHeaderInfoCell priceRowHeight];
        }
        else{
            _freePostageHeight.constant = 0;
            _postageLabel.hidden = YES;
            _priceBackHeight.constant = [PrudctHeaderInfoCell priceRowHeight]- 15;
        }
   
    }
    else{*/
           _postageLabel.hidden = YES;
         _priceBackHeight.constant = [PrudctHeaderInfoCell priceRowHeight] ;
  //  }
    
    
    
    
  /*  if (!model.sevenReturnGuarantee&&!model.saleGuarantee) {
        _tipHeight.constant = [PrudctHeaderInfoCell spaceHeight];
        _sevenReturnButton.hidden = YES;
        _saleFreeButton.hidden = YES;
    }
    else if(model.sevenReturnGuarantee&&!model.saleGuarantee){
        
        _tipHeight.constant = [PrudctHeaderInfoCell tipRowHeight];
        _sevenReturnX.constant = 0;
        _saleFreeButton.hidden = YES;
    }
    else if(!model.sevenReturnGuarantee&&model.saleGuarantee){
    
        _tipHeight.constant = [PrudctHeaderInfoCell tipRowHeight];
        _saleFreeX.constant = 0;
        _sevenReturnButton.hidden = YES;
    }
    else{*/
        _tipHeight.constant = [PrudctHeaderInfoCell tipRowHeight];
  //  }
    
    
    
    
    self.propertyHeight.constant = [PrudctHeaderInfoCell selectCountHeight];
    
    NSString *str1 = @"选择 ";
    NSString *str2 = @"颜色 数量等";
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [attr addAttribute:NSForegroundColorAttributeName value:[Configure SYS_UI_COLOR_TEXT_GRAY] range:NSMakeRange(0, str1.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UitlCommon UIColorFromRGB:0x444444] range:NSMakeRange(str1.length, str2.length)];
    
     [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:(12)] range:NSMakeRange(0, str1.length)];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:(14)] range:NSMakeRange(str1.length, str2.length)];
    
    [self.propertyButton setAttributedTitle:attr forState:UIControlStateNormal];
    
    
    NSAttributedString *str = [PrudctHeaderInfoCell productInfoAttribution:model.goods_brief font:self.inforDetailFont];
    CGSize infoSize = [str sizeWithWidth:[UIScreen  mainScreen].bounds.size.width - 24];
    
    self.infoHeight.constant = [PrudctHeaderInfoCell productIntroduceHeight]+infoSize.height;
    
    self.infoDetailLabel.attributedText =  str;
    
}


-(IBAction)clickSectProperty:(id)sender{

    __weak PrudctHeaderInfoCell *weakSelf = self;
    
    [[ProudctPropertySelectView getInstanceWithNib] showWithProudctID:self.currentModel selectBuy:^(ProductModel *model) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(buyAction:)]) {
            [weakSelf.delegate buyAction:model];
        }
    }];
}

- (IBAction)actionCotrolPage:(id)sender
{
    [_scrollView setContentOffset:CGPointMake(_pageControl.currentPage * [UIScreen  mainScreen].bounds.size.width , 0) animated:YES];
}
// UIScrollView的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x/[UIScreen  mainScreen].bounds.size.width ;
}
@end
