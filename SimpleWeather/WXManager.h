//
//  WXManager.h
//  SimpleWeather
//
//  Created by Amir Ghoreshi on 07/11/14.
//  Copyright (c) 2014 ag07. All rights reserved.
//

@import Foundation;
@import CoreLocation;

#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import "WXCondition.h"

@interface WXManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)shredManager;

@property (nonatomic, strong, readonly) CLLocation *currantLocation;
@property (nonatomic, strong, readonly) WXCondition *currentCondition;
@property (nonatomic, strong, readonly) NSArray *hourlyForecast;
@property (nonatomic, strong, readonly) NSArray *dailyForecast;

// 4
- (void)findCurrentLocation;


@end
