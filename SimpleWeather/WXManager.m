//
//  WXManager.m
//  SimpleWeather
//
//  Created by Amir Ghoreshi on 07/11/14.
//  Copyright (c) 2014 ag07. All rights reserved.
//

#import "WXManager.h"
#import "WXClient.h"
#import <TSMessage.h>

@interface WXManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isFirstUpdate;
@property (nonatomic, strong) WXClient *client;


@end

@implementation WXManager

#pragma mark - static

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (id)init {
    if (self = [super init]){

        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;


        _client = [[WXClient alloc] init];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_locationManager requestAlwaysAuthorization];
            }
        }
        [[[[RACObserve(self, currentLocation) ignore:nil]

        flattenMap:^(CLLocation *newLocation) {
            [TSMessage showNotificationWithTitle:@"Loading" subtitle:@"Getting data from the server" type:TSMessageNotificationTypeSuccess];
            return [RACSignal merge:@[
                                      [self updateCurrentCondition],
                                      [self updateDailyForecast],
                                      [self updateHourlyForecast]
                                      ]
                    ];
        }]
        deliverOn:RACScheduler.mainThreadScheduler]

        subscribeError:^(NSError *error) {
            [TSMessage showNotificationWithTitle:@"Erro" subtitle:@"There was a problem fetching the last weather" type:TSMessageNotificationTypeError];
        }];
    }
    return self;
}

- (void)findCurrentLocation {
    self.isFirstUpdate = YES;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (self.isFirstUpdate) {
        self.isFirstUpdate = NO;
        return;
    }
    CLLocation *location = [locations lastObject];

    if (location.horizontalAccuracy > 0) {
        self.currentLocation = location;
        [self.locationManager  stopUpdatingLocation];
    }
}

- (RACSignal *)updateCurrentCondition {
    return [[self.client fetchCurrentConditionsForLocation:self.currentLocation.coordinate] doNext:^(WXCondition *condition) {
        self.currentCondition = condition;
    }];
}

- (RACSignal *)updateHourlyForecast {
    return [[self.client fetchHourlyForecastForLocation:self.currentLocation.coordinate] doNext:^(NSArray *conditions) {

        self.hourlyForecast = conditions;
    }];
}

-(RACSignal *)updateDailyForecast {
    
    return [[self.client fetchDailyForecastForLocation:self.currentLocation.coordinate] doNext:^(NSArray *conditions) {
        for (int i = 0; i < [conditions count]; i++) {
            NSLog(@"%@", conditions[i]);
        }
        self.dailyForecast = conditions;
    }];
}




































@end
