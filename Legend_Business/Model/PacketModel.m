//
//  PacketModel.m
//  legend_business_ios
//
//  Created by heyk on 16/3/8.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "PacketModel.h"

@implementation PacketModel

@end


@implementation CashModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    
    return @{@"withdraw_id" : @"id"};
    
}
- (CashStatusType)cashStatus{
    return [_status intValue];
}

- (NSDateComponents *)componentsOfDay:(NSDate*)date
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
}

- (NSMutableAttributedString*)createTimeStr{

    if (!self.create_time) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.create_time doubleValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM"];
    NSString *monthStr = [dateFormatter stringFromDate:date];
   
    [dateFormatter setDateFormat:@"d"];
    NSString *dayStr = [dateFormatter stringFromDate:date];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",dayStr,monthStr]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[Configure SYS_FONT_SCALE:16]] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[Configure SYS_FONT_SCALE:11]] range:NSMakeRange(str.length -monthStr.length , monthStr.length)];
    
    return str;
}

- (NSMutableAttributedString*)applyTimeStr{

    if (!self.apply_time) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.apply_time doubleValue]];
 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM"];
    NSString *monthStr = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"d"];
    NSString *dayStr = [dateFormatter stringFromDate:date];
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",dayStr,monthStr]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[Configure SYS_FONT_SCALE:16]] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[Configure SYS_FONT_SCALE:11]] range:NSMakeRange(str.length -monthStr.length , monthStr.length)];
    
    return str;
    
}

- (NSString*)logo{

    if (_logo) {
        return _logo;
    }
    return @"";

}

- (NSString*)user_avatar{
    
    if (_user_avatar) {
        return _user_avatar;
    }
    return @"";
    
}


@end

@implementation CashHistoryModel

- (NSDateComponents *)componentsOfDay:(NSDate*)date
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
}

- (NSString*)monthStr{
    
    if (!self.month) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM"];
    
    NSDate *date=[formatter dateFromString:self.month];
    NSDate *now = [NSDate date];
   
    if ([self componentsOfDay:date].year == [self componentsOfDay:now].year &&
        [self componentsOfDay:date].month == [self componentsOfDay:now].month )
    {
        
        return  @"本月";
    }
    return self.month;
    

}



+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"list" : @"CashModel",
             };
}

@end

