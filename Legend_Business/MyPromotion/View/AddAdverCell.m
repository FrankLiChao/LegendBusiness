//
//  AddAdverCell.m
//  legend_business_ios
//
//  Created by heyk on 16/3/7.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "AddAdverCell.h"

@implementation AddAdverCell

- (void)awakeFromNib {
   // NSLog(@"AddAdverCell ===== ");
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end

@implementation AddAdverCell1 //显示类

- (void)dealloc{
    
  //  [self.valueLabel removeObserver:self forKeyPath:@"text"];
}

- (void)awakeFromNib {
    NSLog(@"AddAdverCell1 ===== ");
    [super awakeFromNib];
   // [self.valueLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    UILabel *label = object;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(nomalCellValueChanged:cell:)]) {
//        [self.delegate nomalCellValueChanged:label.text cell:self];
//    }
//}
@end

@implementation AddAdverCell2  //输入类
- (void)dealloc{

   // [self.valueFiled removeObserver:self forKeyPath:@"text"];
}
- (void)awakeFromNib {
    NSLog(@"AddAdverCell2 ===== ");
    [super awakeFromNib];
    [self.valueFiled addTarget:self action:@selector(inputTextChange:) forControlEvents:UIControlEventEditingChanged];
    //[self.valueFiled addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)inputTextChange:(UITextField*)text{
    if (self.delegate && [self.delegate respondsToSelector:@selector(nomalCellValueChanged:cell:)]) {
        [self.delegate nomalCellValueChanged:text.text cell:self];
    }
}

@end


@implementation AddAdverCell3  //显示数量
- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"AddAdverCell3 ===== ");
}

@end

@implementation AddAdverCell4  //添加问题

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"AddAdverCell4 ===== ");
}

- (IBAction)clickAddNewQuestion:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addNewQuestionCell:)]) {
        [self.delegate addNewQuestionCell:self];
    }
}

@end

@implementation AddAdverCell5   //添加分享信息
- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textViewChange:(NSNotification*)notify{

    if ([notify object] == self.valueTextView) {
        if (!self.valueTextView.text || [self.valueTextView.text isEqualToString:@""]) {
            self.keyLabel.hidden = NO;
        }
        else self.keyLabel.hidden = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(nomalCellValueChanged:cell:)]) {
        [self.delegate nomalCellValueChanged:self.valueTextView.text cell:self];
    }
}

@end

@implementation AddAdverCell6  //问答类问题cell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.answerValueFiled addTarget:self action:@selector(inputTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.questionValueFiled addTarget:self action:@selector(inputTextChange:) forControlEvents:UIControlEventEditingChanged];
}

- (IBAction)clickRemove:(id)sender{

    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteQustion:)]) {
        [self.delegate deleteQustion:self];
    }
}

- (void)inputTextChange:(UITextField*)text{
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionChanged:answer:cell:)]) {
        [self.delegate questionChanged:_questionValueFiled.text answer:_answerValueFiled.text cell:self];
    }
}

@end

