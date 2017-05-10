//
//  ShareView.h
//  legend
//
//  Created by msb-ios-dev on 15/11/5.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{

    KKShareType_WeChat_Chat,//微信聊天
    KKShareType_Wechat_Friends,//微信朋友圈
}KKShareType;


typedef void (^ShareViewClickBlock)(KKShareType type);
typedef void (^CollectClickBlock)(BOOL bSelected);



@interface ShareView : UIView

@property (nonatomic,copy)ShareViewClickBlock shareBlock;
@property (nonatomic,copy)CollectClickBlock collectBolck;

@property (nonatomic, strong) UIView *placeView;

+(ShareView*)getShareView;

-(void)show:(BOOL)bShowCollect shareAction:(ShareViewClickBlock)bolck collectAction:(CollectClickBlock)cBlock;

-(void)showOnlyShare:(ShareViewClickBlock)bolck;

//- (void)myMissionShare;
//- (void)myCompanyShare;
//
//@property (nonatomic, copy) NSString *target_url;

@end
