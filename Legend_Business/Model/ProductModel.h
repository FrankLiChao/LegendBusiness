//
//  Product.h
//  legend
//
//  Created by heyk on 16/1/7.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ProuductType) {

    ProuductType_UnKown = 0,
    ProuductType_Server = 1,
    ProuductType_Recharege= 1,
    ProuductType_Normal = 2,
    
};

typedef NS_ENUM(NSInteger,ProuductListType) {
    
   
    ProuductListType_Selling = 1,//出售中
    ProuductListType_Down = 2,//已下架
    ProuductListType_All = 3,//所有
};



@interface BannerModel : NSObject

@property (nonatomic,strong)NSString *banner_img;
@property (nonatomic,strong)NSString *target_url;

@end


@interface ProductAttributionModel : NSObject

@property (nonatomic,strong)NSString *goods_attr_id;
@property (nonatomic,strong)NSString *attr_value;
@property (nonatomic,strong)NSString  *attr_price;
@property (nonatomic,strong)NSString  *attr_goods_number;

@property (nonatomic,strong)NSString  *attr_id;
@property (nonatomic,strong)NSString  *goods_id;
@property (nonatomic,strong)NSString  *attr_name;
@property (nonatomic,strong)NSString  *price;
@property (nonatomic,strong)NSString  *goods_number;
@property (nonatomic,strong)NSString  *warn_number;
@property (nonatomic,strong)NSString  *recommend_reward;
@property (nonatomic,strong)NSString  *share_reward;
@end


@interface ProductAttributionListModel : NSObject

@property (nonatomic,strong)NSString *attr_name;
@property (nonatomic,strong)NSString *attr_type;
@property (nonatomic,strong)NSArray<ProductAttributionModel*>  *attr_list;

@end

@interface ProductGalleryListModel : NSObject

@property (nonatomic,strong)NSString *img_url;//图片地址
@property (nonatomic,strong)NSString *thumb_url;//缩略图地址
@property (nonatomic,strong)NSString *img_desc;//相册描述

@end

@interface ProductNotBuyAttrListModel : NSObject

@property (nonatomic,strong)NSString *attr_name;
@property (nonatomic,strong)NSString *attr_price;
@property (nonatomic,strong)NSString *attr_value;
@property (nonatomic,strong)NSString *goods_attr_id;
@end

@interface ProductModel : NSObject

@property (nonatomic,strong)NSString *goods_id;//商品id"
@property (nonatomic,strong)NSString *goods_sn;//商品货号
@property (nonatomic,strong)NSString *goods_name;//商品名称
@property (nonatomic,strong)NSString *market_price;//市场价格
@property (nonatomic,strong)NSString *shop_price;//商家价格
@property (nonatomic,strong)NSString *goods_number;//商品库存
@property (nonatomic,strong)NSString *goods_weight;//商品重量
@property (nonatomic,strong)NSString *goods_thumb;//商品列表图地址
@property (nonatomic,strong)NSString *goods_brief;//商品简短描述
@property (nonatomic,strong)NSString *goods_desc;//商品详细描述(图文)

@property (nonatomic,strong)NSString *size_img;//商品规格变


@property (nonatomic,strong)NSNumber *lng;
@property (nonatomic,strong)NSNumber *lat;
@property (nonatomic,strong)NSString *distance;
@property (nonatomic,strong)NSNumber *comment_star;
@property (nonatomic,strong)NSString *goods_img;

@property (nonatomic) BOOL is_endorse;

@property (nonatomic,strong)NSArray<ProductAttributionListModel*>  *buy_attr_list;//属性列表

@property (nonatomic,strong)NSArray<ProductGalleryListModel*>  *gallery_list;//

@property (nonatomic,strong)NSArray<ProductNotBuyAttrListModel*>  *not_buy_attr_list;//

@property (nonatomic,strong)NSString *selectNum;//选择的数量

@property (nonatomic,strong) NSString *shipping;//邮费
@property (nonatomic,strong) NSString *shipping_free;//满额包邮

@property (nonatomic,assign)BOOL        sevenReturnGuarantee;//七天无条件退货保障
@property (nonatomic,assign)BOOL        saleGuarantee;//售后无忧保障


@property (nonatomic,assign)ProuductType type;

@property (nonatomic,strong)NSDictionary *selectProperty;//选择的属性
@end


@interface ProductAttrModel : NSObject

@property (nonatomic,strong)NSString *attr_id;
@property (nonatomic,strong)NSString *goods_id;
@property (nonatomic,strong)NSString *attr_name;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *is_prepare;
@property (nonatomic,strong)NSString *goods_number;//库存
@property (nonatomic,strong)NSString *warn_number;//库存预警
@property (nonatomic,strong)NSString *recommend_reward;//直推收益
@property (nonatomic,strong)NSString *share_reward;//关联收益

@end

@interface ProductDetailModel : NSObject


@property (nonatomic,strong)NSString *goods_id;
@property (nonatomic,strong)NSString *cat_id;
@property (nonatomic,strong)NSString *cat_name;
@property (nonatomic,strong)NSString *parent_id;//父类类别id
@property (nonatomic,strong)NSString *goods_sn;
@property (nonatomic,strong)NSString *goods_name;
@property (nonatomic,strong)NSString *seller_id;
@property (nonatomic,strong)NSString *goods_number;
@property (nonatomic,strong)NSString *shop_price;
@property (nonatomic,strong)NSString *goods_brief;///商品描述
@property (nonatomic,strong)NSArray  *goods_desc;
@property (nonatomic,strong)NSString *goods_tips; //商家提示
@property (nonatomic,strong)NSString *goods_img;
@property (nonatomic,strong)NSArray  *gallery_img;
@property (nonatomic,strong)NSString *goods_type;
@property (nonatomic,strong)NSString *is_prepare;
@property (nonatomic)BOOL is_endorse;
@property (nonatomic,strong)NSString *shipping;
@property (nonatomic,strong)NSString *shipping_free;

@property (nonatomic,strong)NSString *share_money;
@property (nonatomic,strong)NSString *prepare_time;
@property (nonatomic,strong)NSString *goods_thumb;//商品方形图地址，微信分享和订单详情需要200x200像素
@property (nonatomic,strong)NSArray <ProductAttrModel*>*goods_size;


@end


@interface ProductListModel : NSObject

@property (nonatomic,strong)NSString *goods_id;//商品id"
@property (nonatomic,strong)NSString *cat_id;//商品分类id
@property (nonatomic,strong)NSString *goods_name;//商品名称
@property (nonatomic,strong)NSString *goods_thumb;//商品列表图地址
@property (nonatomic,strong)NSString *shop_price;//商家价格
@property (nonatomic,strong)NSString *goods_number;//商品库存
@property (nonatomic,strong)NSString *total_sell_num;//商品卖出数量
@property (nonatomic,strong)NSString *is_prepare;//是否预售
@property (nonatomic,strong)NSString *is_display;//1:未下架 0：下架
@property (nonatomic,strong)NSString *preview_url;//详情地址

@end
