//
//  CommentsModel.h
//  legend_business_ios
//
//  Created by heyk on 16/3/4.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsModel : NSObject

@property (nonatomic,strong) NSString *comment_id;
@property (nonatomic,strong) NSString *goods_id;
@property (nonatomic,strong) NSString *order_id;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *seller_id;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *comment_rank;//评分
@property (nonatomic,strong) NSString *create_time;
@property (nonatomic,strong) NSString *ip_address;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *reply_content;
@property (nonatomic,strong) NSString *reply_time;
@property (nonatomic,strong) NSArray  *comment_img;
@property (nonatomic,strong) NSString *user_name;
@property (nonatomic,strong) NSString *user_avatar;
@property (nonatomic,strong) NSString *goods_name;
@property (nonatomic,strong) NSString *goods_brief;
@property (nonatomic,strong) NSString *goods_attr;

- (NSString*)dateStr;
- (NSString*)goodsAttr;

@end
