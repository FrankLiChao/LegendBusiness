//
//  MaskListModel.h
//  legend_business_ios
//
//  Created by heyk on 16/3/5.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaskListModel : NSObject

@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *status;//1, 任务状态0:未开通,1:进行中,2:已完成
@property (nonatomic,strong) NSString *list_img;
@property (nonatomic,strong) NSString *finish_number;
@property (nonatomic,strong) NSString *mission_id;
@property (nonatomic,strong) NSString *target_number;
@end


@interface MaskInfoModel : MaskListModel
@property (nonatomic,strong) NSString *content_img;
@property (nonatomic,strong) NSString *unit_price;
@property (nonatomic,strong) NSString *demand;//单次任务数量;
@property (nonatomic,strong) NSString *time_limit;
@property (nonatomic,strong) NSString *total_share;//累计分享次数;
@end
