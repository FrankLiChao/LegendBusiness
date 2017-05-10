//
//  MyAnnotation.m
//  legend
//
//  Created by msb-ios-dev on 15/10/28.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation


-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle
                subTitle:(NSString *)paramSubitle
{
    self = [super init];
    if(self != nil)
    {
        _coordinate = paramCoordinates;
        _title = paramTitle;
        _subtitle = paramSubitle;
    }
    return self;
}
@end
