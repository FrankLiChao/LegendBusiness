//
//  Good GoodsDescribeController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/2.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "GoodsDescribeController.h"

@interface GoodsDescribeController ()

@property (nonatomic,weak)IBOutlet UITextView *textView;
@property (nonatomic,weak)IBOutlet UILabel *sectionLabel;

@end

@implementation GoodsDescribeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    [self addRightBarItemWithTitle:@"完成" method:@selector(clickDone:)];
    self.title = _strTitle;
    self.sectionLabel.text = _strTitle;
    
    self.textView.text = _content;
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChange:) name:UITextViewTextDidChangeNotification object:nil];
    
    
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

- (void)clickDone:(id)sender{

    if (self.delegate && [self.delegate respondsToSelector:@selector(addGoodDesrible:contentTag:)]) {
        [self.delegate addGoodDesrible:self.textView.text contentTag:self.contentTag];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark notify
- (void)textValueChange:(NSNotification*)notify{
    

    if (self.textView.text.length>200) {
        
        NSMutableString *content = [NSMutableString stringWithString:_textView.text];
        [content replaceCharactersInRange:NSMakeRange( 200,content.length - 200) withString:@""];
        _textView.text = content;
    }
}



@end
