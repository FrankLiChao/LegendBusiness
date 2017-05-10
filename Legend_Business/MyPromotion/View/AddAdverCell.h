//
//  AddAdverCell.h
//  legend_business_ios
//
//  Created by heyk on 16/3/7.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddAdverCell;

@protocol AddAdverCellDelegate <NSObject>

/**
 *  显示内容有修改
 *
 *  @param value 修改后的值
 *  @param cell
 */
- (void)nomalCellValueChanged:(NSString*)value cell:(AddAdverCell*)cell;

- (void)addNewQuestionCell:(AddAdverCell*)cell;

//添加问题及答案，问答类广告才有
- (void)questionChanged:(NSString*)question answer:(NSString*)answer cell:(AddAdverCell*)cell;

- (void)deleteQustion:(AddAdverCell*)cell;

@end

@interface AddAdverCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *keyLabel;
@property (nonatomic,weak) IBOutlet UILabel *valueLabel;
@property (nonatomic,weak) IBOutlet UITextField *valueFiled;
@property (nonatomic,weak) IBOutlet UITextView *valueTextView;
@property (nonatomic,weak) id<AddAdverCellDelegate> delegate;

@end


@interface AddAdverCell1 : AddAdverCell//显示类


@end

@interface AddAdverCell2 : AddAdverCell //输入类


@end


@interface AddAdverCell3 : AddAdverCell //显示数量


@end

@interface AddAdverCell4 : AddAdverCell //添加问题按钮


@end

@interface AddAdverCell5 : AddAdverCell  //添加分享信息


@end

@interface AddAdverCell6 : AddAdverCell //问答类问题cell

@property (nonatomic,weak) IBOutlet UILabel *questionKeyLabel;
@property (nonatomic,weak) IBOutlet UITextField *questionValueFiled;

@property (nonatomic,weak) IBOutlet UILabel *answerKeyLabel;
@property (nonatomic,weak) IBOutlet UITextField *answerValueFiled;

@end