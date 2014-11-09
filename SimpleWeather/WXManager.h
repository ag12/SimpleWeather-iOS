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

+ (instancetype)sharedManager;
- (void)findCurrentLocation;

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) WXCondition *currentCondition;
@property (nonatomic, strong) NSArray *hourlyForecast;
@property (nonatomic, strong) NSArray *dailyForecast;


- (RACSignal *)updateCurrentCondition;
- (RACSignal *)updateHourlyForecast;
- (RACSignal *)updateDailyForecast;
@end
