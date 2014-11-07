//
//  WXClient.m
//  SimpleWeather
//
//  Created by Amir Ghoreshi on 07/11/14.
//  Copyright (c) 2014 ag07. All rights reserved.
//

#import "WXClient.h"
#import "WXDailyForecast.h"

static NSString * const BASE_URL = @"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial";

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

- (NSURL *)getDefaultUrl:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat:BASE_URL, coordinate.latitude, coordinate.longitude];
    return [NSURL URLWithString:urlString];
}

- (RACSignal *)fetchJSONFromURL:(NSURL *)url {
    NSLog(@"Fetching %@", url.absoluteString);

    //1
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //2
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"^completionHandler");
            NSLog(@"Data task create");

            if (!error) {
                //Vi kjor nu!
                NSError *jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (!jsonError) {
                    [subscriber sendNext:json];
                    NSLog(@"Send Next Json");
                } else
                {
                    [subscriber sendError:jsonError];
                }
            } else {
                [subscriber sendError:error];
            }
            [subscriber sendCompleted];
        }];
        //3
        [dataTask resume];
        NSLog(@"Data task resume");
        //4
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
            NSLog(@"Data task cancel");

        }];
    }] doError:^(NSError *error) {
           NSLog(@"^doError");
    }];
}
- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate {
    return [[self fetchJSONFromURL:[self getDefaultUrl:coordinate]] map:^id(NSDictionary *json) {
        return [MTLJSONAdapter modelOfClass:[WXCondition class] fromJSONDictionary:json error:nil];
    }];
}
- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    return [[self fetchJSONFromURL:[self getDefaultUrl:coordinate]]map:^id(NSDictionary *json) {
        RACSequence *list = [json[@"list"] rac_sequence];
        return [list map:^id(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[WXCondition class] fromJSONDictionary:item error:nil];
        }];
    }];
}
- (RACSignal *)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    return [[self fetchJSONFromURL:[self getDefaultUrl:coordinate] ] map:^id(NSDictionary *json) {
        RACSequence *list = [json[@"list"] rac_sequence];
        return [[list map:^id(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[WXCondition class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}
@end
