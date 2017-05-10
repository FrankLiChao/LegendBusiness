//
//  MyAnnotation.h
//  legend
//
//  Created by msb-ios-dev on 15/10/28.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>


@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy,readonly) NSString * title;
@property (nonatomic,copy,readonly) NSString * subtitle;


-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                   title:(NSString *)paramTitle
                subTitle:(NSString *)paramTitle;

@end
