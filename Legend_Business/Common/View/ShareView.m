//
//  ShareView.m
//  legend
//
//  Created by msb-ios-dev on 15/11/5.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "ShareView.h"
#import "DefineKey.h"


@interface ShareView ()<UIGestureRecognizerDelegate>


@end

@implementation ShareView{

    KKShareType selectType;
    UIView *contentView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(ShareView*)getShareView{

    ShareView *shareView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //[shareView initUI];
    
    return shareView;
}

-(void)initUI{

    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-130, [UIScreen mainScreen].bounds.size.width, 130)];
    [self addSubview:contentView];
     contentView.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 130)];
    [contentView addSubview:scrollV];
    [UitlCommon setFlatWithView:scrollV radius:2];
    
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapRecognizer.numberOfTapsRequired =1;
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
    
    
    UILabel *weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100,90, 100, 20)];
    weixinLabel.text = @"微信好友";
    weixinLabel.font = [UIFont systemFontOfSize:16];
    weixinLabel.textAlignment = NSTextAlignmentCenter ;
    weixinLabel.textColor = [UIColor colorWithRed:101.0/255 green:101.0/255 blue:101.0/255 alpha:1];
    [scrollV addSubview:weixinLabel];
    
    UIButton *weixin = [UIButton buttonWithType:UIButtonTypeCustom];
    weixin.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, 0,100, 90);
    [weixin setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
   // [weixin setTitle:@"微信好友" forState:UIControlStateNormal];
   // [weixin setTitleColor:SYS_UI_COLOR(101, 101, 101, 1) forState:UIControlStateNormal];
    [weixin addTarget:self action:@selector(clickWeixinButton) forControlEvents:UIControlEventTouchUpInside];
    [scrollV addSubview:weixin];
    
    
    UILabel *fL = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 90, 100, 20)];
    fL.text = @"朋友圈";
    fL.font = [UIFont systemFontOfSize:16];
    fL.textAlignment = NSTextAlignmentCenter ;
    fL.textColor =  [UIColor colorWithRed:101.0/255 green:101.0/255 blue:101.0/255 alpha:1];
    [scrollV addSubview:fL];
    
    
    UIButton *friendCircle = [UIButton buttonWithType:UIButtonTypeCustom];
    friendCircle.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 , 0, 100, 90);
    [friendCircle setImage:[UIImage imageNamed:@"friend_circle"] forState:UIControlStateNormal];
    [friendCircle addTarget:self action:@selector(clickfriendCircleButton) forControlEvents:UIControlEventTouchUpInside];
    [scrollV addSubview:friendCircle];


}

-(void)showOnlyShare:(ShareViewClickBlock)bolck{
    self.shareBlock = bolck;
    [self initUI];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self showAnimation];
}
-(void)show:(BOOL)bShowCollect shareAction:(ShareViewClickBlock)bolck collectAction:(CollectClickBlock)cBlock{
    self.shareBlock = bolck;
    self.collectBolck = cBlock;
    
    [self initUI];
    
    contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 220, [UIScreen mainScreen].bounds.size.width, 220);
    
    
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectButton addTarget:self action:@selector(clcickCollect:) forControlEvents:UIControlEventTouchUpInside];
     collectButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [UitlCommon setFlatWithView:collectButton radius:4];
    

    float buttonHeight = 50;//SYS_UI_SCALE_WIDTH_SIZE(50);
    buttonHeight = buttonHeight>70?70:buttonHeight;
    
    collectButton.backgroundColor = [UitlCommon UIColorFromRGB:0xf72c6b ];
    [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    
    collectButton.frame = CGRectMake(12, (90-buttonHeight)/2+130, [UIScreen mainScreen].bounds.size.width-24, buttonHeight);
    [contentView addSubview:collectButton];
    
    UIView *speare = [[UIView alloc] initWithFrame:CGRectMake(12, 130, [UIScreen mainScreen].bounds.size.width - 24 , 1)];
    speare.backgroundColor =  [UIColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1];
    [contentView addSubview:speare];
    
    collectButton.selected  = NO;
    
    if (bShowCollect) {
        [collectButton setTitle:@"取消收藏" forState:UIControlStateNormal];
        collectButton.backgroundColor = [UitlCommon UIColorFromRGB:0xff9537 ];
        collectButton.selected  = YES;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
      [self showAnimation];
    
}





-(void)showAnimation{

    CGRect frame =  contentView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    contentView.frame = frame;
    
    [UIView animateWithDuration:0.25 animations:^{
       
        CGRect frame =  contentView.frame;
        
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        contentView.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];

}

-(void)dismissAnimation{


    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame =  contentView.frame;
        
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        contentView.frame = frame;
        
    } completion:^(BOOL finished) {
        [self dismiss];
    }];
    
}

-(void)dismiss{

    [self removeFromSuperview];
}


-(void)tapGesture:(UITapGestureRecognizer*)tap{
 
    [self dismissAnimation];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

#pragma mark click button
-(void)clickWeixinButton{

    selectType = KKShareType_WeChat_Chat;
       [self dealClick];
}
-(void)clickfriendCircleButton{
   selectType = KKShareType_Wechat_Friends;
    [self dealClick];
}

-(void)dealClick{

    self.shareBlock(selectType);
    [self dismissAnimation];
}

-(void)clcickCollect:(UIButton*)button{
    
    if (self.collectBolck) {
        self.collectBolck(!button.selected);
    }
    [self dismissAnimation]; 
}


/*
#pragma mark -
#pragma mark Public Methods
- (void)myMissionShare
{
    [self myMissionBaseUIConfig];
    [self missionShow];
}

- (void)myCompanyShare
{
    [self myCompanyBaseUIConfig];
    [self companyShow];
}

#pragma mark -
#pragma mark Private Methods
- (void)myMissionBaseUIConfig
{
    _placeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen ], SYS_UI_WINSIZE_HEIGHT)];
    
    _placeView.backgroundColor = SYS_UI_COLOR(0, 0, 0, 0.8f);
    
    //-- 叉叉按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(SYS_UI_WINSIZE_WIDTH/2 - KJL_X_FROM6(15.0f), KJL_X_FROM6(180.0f), KJL_X_FROM6(30.0f), KJL_X_FROM6(30.0f));
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close_white"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(companyCloseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_placeView addSubview:closeBtn];
    
    //-- label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, closeBtn.jl_bottom + KJL_X_FROM6(20.0f), SYS_UI_WINSIZE_WIDTH, KJL_X_FROM6(22.0f))];
    label.font = [UIFont boldSystemFontOfSize:KJL_X_FROM6(20.0f)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"请选择分享方式";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [_placeView addSubview:label];
    
    //-- 微信好友
    UIButton *wechatFriend = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatFriend.frame = CGRectMake(KJL_X_FROM6(85.0f), label.jl_bottom + KJL_X_FROM6(80.0f), KJL_X_FROM6(70.0f), KJL_X_FROM6(70.0f));
    [wechatFriend setBackgroundImage:[UIImage imageNamed:@"wechat_mission"] forState:UIControlStateNormal];
    wechatFriend.tag = 1;
    [wechatFriend addTarget:self action:@selector(companyShareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_placeView addSubview:wechatFriend];
    
    //-- 微信朋友圈
    UIButton *wechatCircle = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatCircle.frame = CGRectMake(wechatFriend.jl_right + KJL_X_FROM6(65.0f), label.jl_bottom + KJL_X_FROM6(80.0f), KJL_X_FROM6(70.0f), KJL_X_FROM6(70.0f));
    [wechatCircle setBackgroundImage:[UIImage imageNamed:@"friend_mission"] forState:UIControlStateNormal];
    wechatCircle.tag = 2;
    [wechatCircle addTarget:self action:@selector(companyShareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_placeView addSubview:wechatCircle];
    
    //-- 微信好友label
    UILabel *wechatFLabel = [[UILabel alloc] initWithFrame:CGRectMake(wechatFriend.jl_left - KJL_X_FROM6(15.0f), wechatFriend.jl_bottom + KJL_X_FROM6(10.0f), KJL_X_FROM6(100.0f), KJL_X_FROM6(18.0f))];
    wechatFLabel.textColor = [UIColor whiteColor];
    wechatFLabel.backgroundColor = [UIColor clearColor];
    wechatFLabel.text = @"微信好友";
    wechatFLabel.textAlignment = NSTextAlignmentCenter;
    [_placeView addSubview:wechatFLabel];
    
    //-- 朋友圈label
    UILabel *wechatCLabel = [[UILabel alloc] initWithFrame:CGRectMake(wechatCircle.jl_left - KJL_X_FROM6(15.0f), wechatCircle.jl_bottom + KJL_X_FROM6(10.0f), KJL_X_FROM6(100.0f), KJL_X_FROM6(18.0f))];
    wechatCLabel.textColor = [UIColor whiteColor];
    wechatCLabel.backgroundColor = [UIColor clearColor];
    wechatCLabel.text = @"微信朋友圈";
    wechatCLabel.textAlignment = NSTextAlignmentCenter;
    [_placeView addSubview:wechatCLabel];
    
    _placeView.alpha = 0.0f;
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:_placeView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)myCompanyBaseUIConfig
{
    _placeView = [[UIView alloc] initWithFrame:CGRectMake(0, SYS_UI_WINSIZE_HEIGHT, SYS_UI_WINSIZE_WIDTH, KJL_X_FROM6(200.0f))];
    _placeView.backgroundColor = [UIColor whiteColor];
    
    //-- 微信按钮
    UIButton *wechatFriend = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatFriend.frame = CGRectMake(KJL_X_FROM6(105.0f), KJL_X_FROM6(20.0f), KJL_X_FROM6(50.0f), KJL_X_FROM6(50.0f));
    [wechatFriend setBackgroundImage:[UIImage imageNamed:@"wechat_company"] forState:UIControlStateNormal];
    wechatFriend.tag = 1;
    [wechatFriend addTarget:self action:@selector(companyShareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_placeView addSubview:wechatFriend];
    
    //-- 微信朋友圈
    UIButton *wechatCircle = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatCircle.frame = CGRectMake(wechatFriend.jl_right + KJL_X_FROM6(65.0f), KJL_X_FROM6(20.0f), KJL_X_FROM6(50.0f), KJL_X_FROM6(50.0f));
    [wechatCircle setBackgroundImage:[UIImage imageNamed:@"message_company"] forState:UIControlStateNormal];
    wechatCircle.tag = 2;
    [wechatCircle addTarget:self action:@selector(companyShareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_placeView addSubview:wechatCircle];
    
    //-- 微信好友label
    UILabel *wechatFLabel = [[UILabel alloc] initWithFrame:CGRectMake(wechatFriend.jl_left - KJL_X_FROM6(22.0f), wechatFriend.jl_bottom + KJL_X_FROM6(10.0f), KJL_X_FROM6(100.0f), KJL_X_FROM6(18.0f))];
    wechatFLabel.textColor = SYS_UI_COLOR_TEXT_GRAY;
    wechatFLabel.backgroundColor = [UIColor clearColor];
    wechatFLabel.text = @"微信好友";
    wechatFLabel.textAlignment = NSTextAlignmentCenter;
    [_placeView addSubview:wechatFLabel];
    
    //-- 朋友圈label
    UILabel *wechatCLabel = [[UILabel alloc] initWithFrame:CGRectMake(wechatCircle.jl_left - KJL_X_FROM6(22.0f), wechatCircle.jl_bottom + KJL_X_FROM6(10.0f), KJL_X_FROM6(100.0f), KJL_X_FROM6(18.0f))];
    wechatCLabel.textColor = SYS_UI_COLOR_TEXT_GRAY;
    wechatCLabel.backgroundColor = [UIColor clearColor];
    wechatCLabel.text = @"朋友圈";
    wechatCLabel.textAlignment = NSTextAlignmentCenter;
    [_placeView addSubview:wechatCLabel];
    
    //-- 取消按钮
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, KJL_X_FROM6(200.0f) - KJL_X_FROM6(75.0f), SYS_UI_WINSIZE_WIDTH, KJL_X_FROM6(75.0f));
    [cancel setTitle:@"取 消" forState:UIControlStateNormal];
    [cancel setTitleColor:SYS_UI_COLOR_TEXT_BLACK forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:KJL_X_FROM6(20.0f)];
    [cancel addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_placeView addSubview:cancel];
    
    //-- 灰条
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, cancel.jl_top + 2, SYS_UI_WINSIZE_WIDTH, 2.0f)];
    grayLine.backgroundColor = SYS_UI_COLOR_LINE_IN_LIGHT;
    [_placeView addSubview:grayLine];
    
    [self addSubview:_placeView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)missionShow
{
    __weak typeof(self) weak_Self = self;
    [UIView animateWithDuration:0.8f animations:^{
        weak_Self.placeView.alpha = 1.0f;
    }];
}

- (void)missionDisappear
{
    __weak typeof(self) weak_Self = self;
    [UIView animateWithDuration:0.8f animations:^{
        weak_Self.placeView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        [weak_Self removeFromSuperview];
    }];
}

- (void)companyShow
{
    __weak typeof(self) weak_Self = self;
    [UIView animateWithDuration:0.6f animations:^{
        weak_Self.placeView.frame = CGRectMake(0, SYS_UI_WINSIZE_HEIGHT - KJL_X_FROM6(200.0f), SYS_UI_WINSIZE_WIDTH, KJL_X_FROM6(200.0f));
        weak_Self.backgroundColor = SYS_UI_COLOR(0, 0, 0, 0.8f);
    }];
}

- (void)companyHide
{
    __weak typeof(self) weak_Self = self;
    [UIView animateWithDuration:0.6f animations:^{
        weak_Self.placeView.frame = CGRectMake(0, SYS_UI_WINSIZE_HEIGHT, SYS_UI_WINSIZE_WIDTH, KJL_X_FROM6(200.0f));
    } completion:^(BOOL finished) {
        [weak_Self removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark Respond Methods
- (void)companyCloseBtnClicked:(UIButton *)sender
{
    [self missionDisappear];
}

- (void)cancelBtnClicked:(UIButton *)sender
{
    [self companyHide];
}

- (void)companyShareBtnClicked:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        //-- 微信好友
        id<ISSContent> publishContent = [ShareSDK content:@"testJL!"
                                           defaultContent:nil
                                                    image:nil
                                                    title:@"传说"
                                                      url:_target_url
                                              description:nil
                                                mediaType:SSPublishContentMediaTypeNews];
        
        [ShareSDK shareContent:publishContent type:ShareTypeWeixiSession authOptions:nil shareOptions:nil statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            NSLog(@"end = %d",end);
            if (error) {
                NSLog(@"error = %@",[error errorDescription]);
            }
        }];
        
        NSLog(@"%@", _target_url);
        
    }
    else
    {
        //-- 微信朋友圈
        
        id<ISSContent> publishContent = [ShareSDK content:@"testJL!"
                                           defaultContent:nil
                                                    image:nil
                                                    title:@"传说"
                                                      url:_target_url
                                              description:nil
                                                mediaType:SSPublishContentMediaTypeNews];
        
        [ShareSDK shareContent:publishContent type:ShareTypeWeixiTimeline authOptions:nil shareOptions:nil statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            NSLog(@"end = %d",end);
            if (error) {
                NSLog(@"error = %@",[error errorDescription]);
            }
        }];
        
        NSLog(@"%@", _target_url);
    }
}*/

@end
