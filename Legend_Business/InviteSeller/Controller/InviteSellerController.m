//
//  InviteSellerController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/5.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "InviteSellerController.h"
#import <MessageUI/MessageUI.h>
#import "ShareView.h"

@interface InviteSellerController ()<MFMessageComposeViewControllerDelegate>

@property (nonatomic,strong) NSString *shareLink;


@end

@implementation InviteSellerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请商家";
    [self setBackButton];
    
    __weak typeof(self) weakSelf = self;
    
    [self showHudInView:self.view hint:@""];
    [self inviteSeller:^(NSString *imageUrl, NSString *code,NSString *link,NSString *recommend) {
      
        weakSelf.shareLink = link;
        weakSelf.recommendCodeLabel.text = code;
        
        dispatch_async((dispatch_queue_t)[DefaultService myCustomQueque], ^{
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            if (imageData) {
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    weakSelf.codeImageView.image = image;
                    [weakSelf hideHud];
                });
            }
        });
    } failed:^(NSString *errorDes) {
        [weakSelf hideHud];
        [weakSelf showHint:errorDes];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)clickWeChatButton:(id)sender{

   // if ([WXApi isWXAppInstalled]) {
        
    __weak typeof(self) weakSelf = self;
    
        [[ShareView getShareView] showOnlyShare:^(KKShareType type) {
            
            WXMediaMessage *message = [WXMediaMessage new];
            message.description = @"邀请商家";
            [message setThumbImage:[UIImage imageNamed:@"icon"]];
           
            WXWebpageObject *obj = [WXWebpageObject object] ;
            obj.webpageUrl = weakSelf.shareLink;
            
            message.mediaObject = obj;
            
            if(type == KKShareType_WeChat_Chat){
            
         
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
      
                req.message = message;
                req.scene = WXSceneSession; //发送到会话
                [WXApi sendReq:req];
                
            
            }
            else if(type == KKShareType_Wechat_Friends){
            
                SendMessageToWXReq* req2 = [[SendMessageToWXReq alloc] init];
                req2.message = message;
                req2.scene = WXSceneTimeline; //发送到朋友圈
                [WXApi sendReq:req2];
                
            }

        }];
        

//    }
//    else{
//        [self showHint:@"没有安装微信"];
//    }
}

- (IBAction)clcikMessageButton:(id)sender{
    
    if(!self.shareLink){
    
        [self showHint:@"没有获取到分享链接"];
        return;
    }
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
      //  controller.recipients = phones;
      //  controller.navigationBar.tintColor = [UIColor whiteColor];
        controller.body = self.shareLink;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"邀请商家"];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}


-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}

@end
