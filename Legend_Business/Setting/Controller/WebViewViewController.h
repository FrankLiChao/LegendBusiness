//
//  WebViewViewController.h
//  legend_business_ios
//
//  Created by heyk on 16/3/8.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef enum {
    
    WebType_HelpUs,
    WebType_UserAgent,
    WebType_GoodesDetail,
    

}WebType;

@interface WebViewViewController : BaseViewController

@property (nonatomic,weak) IBOutlet UIWebView   *webView;

@property (nonatomic)WebType type;
@property (nonatomic,strong )NSString *url;
@property (nonatomic,strong) NSString *strTitle;

@end
