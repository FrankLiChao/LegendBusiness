//
//  ProudctPropertySelectView.m
//  legend
//
//  Created by heyk on 16/1/13.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "ProudctPropertySelectView.h"
#import "DefineKey.h"
#import "ProductPropertyModel.h"
#import "UIImageView+WebCache.h"
#import "ProductModel.h"
#import "legend_business_ios-swift.h"
#import "UIView+HUD.h"

@interface PropertyButton : UIButton

@property (nonatomic,strong)UIColor *normalBackGroudColor;
@property (nonatomic,strong)UIColor *normalTextColor;

@property (nonatomic,strong)UIColor *selectBackGroudColor;
@property (nonatomic,strong)UIColor *selectTextColor;
@property (nonatomic,strong)UIColor *invailedBackGroundColor;

@property (nonatomic,strong)NSString *strKey;
@property (nonatomic,strong)id model;

@end


@implementation PropertyButton

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self setBackgroundColor:_selectBackGroudColor];
        [self setTitleColor:_selectTextColor forState:UIControlStateNormal];
        
        [UitlCommon setFlatWithView:self radius:1];
    
    }
    else {
        [self setBackgroundColor:_normalBackGroudColor];
        [self setTitleColor:_normalTextColor forState:UIControlStateNormal];
        [UitlCommon setFlatWithView:self radius:1 borderColor:[Configure SYS_UI_COLOR_LINE_COLOR] borderWidth:1];
    }
}

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (enabled) {
        [self setBackgroundColor:_normalBackGroudColor];
        [self setTitleColor:_normalTextColor forState:UIControlStateNormal];
         [UitlCommon setFlatWithView:self radius:1 borderColor:[Configure SYS_UI_COLOR_LINE_COLOR] borderWidth:1];;
    }
    else{
        [self setBackgroundColor:_invailedBackGroundColor];
        [self setTitleColor:_normalTextColor forState:UIControlStateNormal];
         [UitlCommon setFlatWithView:self radius:1 borderColor:[Configure SYS_UI_COLOR_LINE_COLOR] borderWidth:1];
    }
}


-(void)setNormalBackGroudColor:(UIColor *)normalBackGroudColor{
    _normalBackGroudColor = normalBackGroudColor;
    [self setBackgroundColor:normalBackGroudColor];
     [UitlCommon setFlatWithView:self radius:1 borderColor:[Configure SYS_UI_COLOR_LINE_COLOR] borderWidth:1];
}

-(void)setNormalTextColor:(UIColor *)normalTextColor{
    
    _normalTextColor = normalTextColor;
    [self setTitleColor:normalTextColor forState:UIControlStateNormal];
}
@end




@interface ProudctPropertySelectView()


@property (nonatomic,strong)UILabel *prountNumLabel;
@property (nonatomic,strong)NSMutableDictionary *selectDic;

@end


@implementation ProudctPropertySelectView{
    
    
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
+(ProudctPropertySelectView*)getInstanceWithNib{
    ProudctPropertySelectView *view = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"ProudctPropertySelectView" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[ProudctPropertySelectView class]]){
            view = (ProudctPropertySelectView *)obj;
            view.frame = [UIScreen mainScreen].bounds;
            
            view.selectDic = [NSMutableDictionary dictionary];
            
            break;
        }
    }
    return view;
}


-(void)setUI{
    
    
    if ([self.currentModel.goods_number intValue]>0) {
         _currentModel.selectNum = @"1";
    }
    else{
        _buyButton.enabled = NO;
        _buyButton.backgroundColor = [Configure SYS_UI_COLOR_LINE_COLOR];
    }
    float height = 0;
    
    for (int i = 0;i<_currentModel.buy_attr_list.count;i++) {
        
        ProductAttributionListModel *model =  [_currentModel.buy_attr_list objectAtIndex:i];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, height, [UIScreen mainScreen].bounds.size.width - 24, 50)];
        titleLabel.textColor =   [UitlCommon UIColorFromRGB:0x444444];
        titleLabel.text = model.attr_name;
        titleLabel.font = [UIFont systemFontOfSize:14];
        [_scrollContentView addSubview:titleLabel];
        
        height+=titleLabel.frame.size.height;
        

        NSArray *array = model.attr_list;
        
        float leading = 12;
        float h = 35;
        
        PropertyButton *lastButton = nil;
        
        for (int j = 0; j<array.count; j++) {
            
            PropertyButton *button = [PropertyButton buttonWithType:UIButtonTypeCustom];
            button.normalBackGroudColor = [UIColor  whiteColor];
            button.normalTextColor = [Configure SYS_UI_COLOR_TEXT_BLACK];
            button.selectBackGroudColor = [Configure SYS_UI_COLOR_BG_RED];
            button.selectTextColor = [UIColor whiteColor];
            button.invailedBackGroundColor =  [Configure SYS_UI_COLOR_LINE_COLOR];;
            
            ProductAttributionModel *attrModel = [array objectAtIndex:j];
            
            button.strKey = titleLabel.text;
            button.model = attrModel;

            NSString *content = attrModel.attr_value;
            [button setTitle:content forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [_scrollContentView addSubview:button];
            
            CGSize size = [content sizeWithFont:button.titleLabel.font byHeight:h];
            size.width += leading*2;//24为按钮内容边距
            
            if (size.width>[UIScreen mainScreen].bounds.size.width - leading*2) {
                size.width = [UIScreen mainScreen].bounds.size.width -leading*2;
            }
            
            if (lastButton) {
                if (size.width> [UIScreen mainScreen].bounds.size.width  - lastButton.frame.origin.x - lastButton.frame.size.width - leading) {
                    height=height + h + leading;
                    button.frame = CGRectMake(leading, lastButton.frame.origin.y+ h + leading, size.width, h);
                }
                else{
                    button.frame =  CGRectMake(lastButton.frame.origin.x + lastButton.frame.size.width + leading, lastButton.frame.origin.y , size.width, h);
                }
            }
            else{
                button.frame = CGRectMake(leading,  height, size.width, h);
                height = height + h;
            }
            
            lastButton = button;
            
            
            [button addTarget:self action:@selector(selectProperty:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        height +=leading;
        
        UIView *spearteLine = [[UIView alloc] initWithFrame:CGRectMake(12, height, [UIScreen mainScreen].bounds.size.width-24, 1)];
        spearteLine.backgroundColor = [Configure   SYS_UI_COLOR_LINE_COLOR];
        [_scrollContentView addSubview:spearteLine];
        
        height+=1;
    }
    
    height+=10;
    
    UILabel *buyCountLabel =  [[UILabel alloc] initWithFrame:CGRectMake(12, height, [UIScreen mainScreen].bounds.size.width - 24, 50)];
    buyCountLabel.textColor = [UitlCommon UIColorFromRGB:0x444444];
    buyCountLabel.text = @"购买数量";
    buyCountLabel.font = [UIFont systemFontOfSize:14];
    [_scrollContentView addSubview:buyCountLabel];
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"add_count"] forState:UIControlStateNormal];
    addButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 , height, 44, 50);
    [addButton addTarget:self action:@selector(addPrountCount:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollContentView addSubview:addButton];
    
    
    UIView *spearte1 = [[UIView alloc] initWithFrame:CGRectMake(addButton.frame.origin.x - 1, addButton.frame.origin.y + 10, 1, 30)];
    spearte1.backgroundColor = [Configure SYS_UI_COLOR_LINE_COLOR];
    [_scrollContentView addSubview:spearte1];
    
    
    self.prountNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(spearte1.frame.origin.x - 44, addButton.frame.origin.y, 44, 50)];
    self.prountNumLabel.textAlignment = NSTextAlignmentCenter;
    self.prountNumLabel.text = @"1";
    _prountNumLabel.font = [UIFont systemFontOfSize:14];
    [_scrollContentView addSubview:_prountNumLabel];
    
    UIView *spearte2 = [[UIView alloc] initWithFrame:CGRectMake(_prountNumLabel.frame.origin.x - 1, buyCountLabel.frame.origin.y + 10, 1, 30)];
    spearte2.backgroundColor = [Configure SYS_UI_COLOR_LINE_COLOR];
    [_scrollContentView addSubview:spearte2];
    
    
    UIButton *decressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [decressButton setImage:[UIImage imageNamed:@"decrease_count"] forState:UIControlStateNormal];
    decressButton.frame = CGRectMake(spearte2.frame.origin.x - 44 , height, 44, 50);
    [decressButton addTarget:self action:@selector(decresePrountCount:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollContentView addSubview:decressButton];
    
    height +=50;
    
    _scrollContentHeight.constant = height -  275;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_currentModel.goods_thumb] placeholderImage:[UIImage imageNamed:@"默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}


-(void)showWithProudctID:(ProductModel*)model selectBuy:(ProudctPropertySelectBuyBlock)block{
    
    self.buyBlock = block;
    self.currentModel = model;
    self.titleLabel.text = model.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.shop_price];
    
    
    [self setUI];
    
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [view addSubview:self];
    [_contentView layoutIfNeeded];
    
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         _contentBottom.constant = 0;
                         [_contentView layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         
                         
                     }];
}

-(void)dismiss{
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         _contentBottom.constant = -440;
                         [_contentView layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                     }];
}


-(IBAction)clickBuy:(id)sender{
    
    
    if ([self checkAllSelect]) {

        if (self.buyBlock) {
            _currentModel.selectProperty = _selectDic;
            self.buyBlock(_currentModel);
        }
        [self dismiss];
    }
}

-(IBAction)clickClose:(id)sender{
    [self dismiss];
}



-(void)selectProperty:(PropertyButton*)button{
    

    button.selected = !button.selected;
    [self checkSelectStatus:button];
    
    if (button.selected) {
        [_selectDic setObject:button.model forKey:button.strKey];
    }
    else{
        [_selectDic setObject:@"" forKey:button.strKey];
    }
    
}

-(void)addPrountCount:(UIButton*)button{
    
    if([self.prountNumLabel.text intValue]<[_currentModel.goods_number intValue]){
        self.prountNumLabel.text = [NSString stringWithFormat:@"%d",[self.prountNumLabel.text intValue] + 1];
        
       _currentModel.selectNum = self.prountNumLabel.text;
    }
}

-(void)decresePrountCount:(UIButton*)button{
    
    if ([self.prountNumLabel.text intValue]>1) {
        self.prountNumLabel.text = [NSString stringWithFormat:@"%d",[self.prountNumLabel.text intValue] - 1];
        _currentModel.selectNum = self.prountNumLabel.text;
    }
}

//取消同类别中已经选择的状态
-(void)checkSelectStatus:(PropertyButton*)button{
    
    NSString *strKey = button.strKey;
    
    NSMutableString *titlePrice = [self.priceLabel.text mutableCopy];
    NSString *str1 = @"¥";
    
    [titlePrice replaceOccurrencesOfString:str1 withString:@"" options:NSLiteralSearch  range:NSMakeRange(0, str1.length)];
    
    float price =  [titlePrice floatValue];
    
    NSArray *views = _scrollContentView.subviews;
    for (UIView *view in views) {
        
        if ([view isKindOfClass:[PropertyButton class]] && ![button isEqual:view]) {
            
            PropertyButton *temp = (PropertyButton*)view;
            
            ProductAttributionModel *attrModel = temp.model;
    
            if ([temp.strKey isEqualToString:strKey]) {//同一类别
                if (temp.selected) {
                    price = price - [attrModel.attr_price floatValue];
                    temp.selected = NO;
                }
            }
        }
    }
    
    if (button.selected) {
        
        ProductAttributionModel *attrModel = button.model;
        price +=  [attrModel.attr_price floatValue];
    }
    self.priceLabel.text = [NSString stringWithFormat:@"¥%0.2f",price];
    
}



-(BOOL)checkAllSelect{
    
    NSArray *allKeys = [_selectDic allKeys];
    
    for (ProductAttributionListModel *model in self.currentModel.buy_attr_list) {
        
        NSString *strKey = model.attr_name;
        if (![allKeys containsObject: strKey ]) {
            
            [self showHint :[NSString stringWithFormat:@"请选择%@",strKey]];
            
            return NO;
        }
    }
    return YES;
}

- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

@end
