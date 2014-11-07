//
//  WXClient.m
//  SimpleWeather
//
//  Created by Amir Ghoreshi on 07/11/14.
//  Copyright (c) 2014 ag07. All rights reserved.
//

#import "WXClient.h"
#import "WXDailyForecast.h"

@interface WXClient () {}

@property(nonatomic, strong) NSURLSession *session;

@end

@implementation WXClient

#pragma mark -
#pragma mark - Init

- (id)init {
    if (self == [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

- (RACSignal *)

@end
