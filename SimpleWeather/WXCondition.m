//
//  WXCondition.m
//  SimpleWeather
//
//  Created by Amir Ghoreshi on 07/11/14.
//  Copyright (c) 2014 ag07. All rights reserved.
//

#import "WXCondition.h"

@interface WXCondition(){

}
@end

@implementation WXCondition

+ (NSDictionary *)imageMap {
    // 1
    static NSDictionary *_imageMap = nil;
    if (! _imageMap) {
        // 2
        _imageMap = @{
                      @"01d" : @"weather-clear",
                      @"02d" : @"weather-few",
                      @"03d" : @"weather-few",
                      @"04d" : @"weather-broken",
                      @"09d" : @"weather-shower",
                      @"10d" : @"weather-rain",
                      @"11d" : @"weather-tstorm",
                      @"13d" : @"weather-snow",
                      @"50d" : @"weather-mist",
                      @"01n" : @"weather-moon",
                      @"02n" : @"weather-few-night",
                      @"03n" : @"weather-few-night",
                      @"04n" : @"weather-broken",
                      @"09n" : @"weather-shower",
                      @"10n" : @"weather-rain-night",
                      @"11n" : @"weather-tstorm",
                      @"13n" : @"weather-snow",
                      @"50n" : @"weather-mist",
                      };
    }
    return _imageMap;
}

- (NSString *)imageName {
    return [WXCondition imageMap][self.icon];
}

+ (NSDictionary *) JSONKeyPathsByPropertyKey {

    return @{
             @"date": @"dt",
             @"locationName": @"name",
             @"humidity": @"main.humidity",
             @"temperature": @"main.temp",
             @"tempHigh": @"main.temp_max",
             @"tempLow": @"main.temp_min",
             @"sunrise": @"sys.sunrise",
             @"sunset": @"sys.sunset",
             @"conditionDescription": @"weather.description",
             @"condition": @"weather.main",
             @"icon": @"weather.icon",
             @"windBearing": @"wind.deg",
             @"windSpeed": @"wind.speed"
             };
}

+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^(NSString *string) {
                return [NSDate dateWithTimeIntervalSince1970:string.floatValue];
            }
            reverseBlock:^(NSDate *date) {
                return [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
            }];
}

// 2
+ (NSValueTransformer *)sunriseJSONTransformer {
    return [self dateJSONTransformer];
}

+ (NSValueTransformer *)sunsetJSONTransformer {
    return [self dateJSONTransformer];
}



+ (NSValueTransformer *)conditionDescriptionJSONTransformer {
    return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^(NSArray *values) {
                return [values firstObject];
            }
            reverseBlock:^(NSString *string) {
                return @[string];
            }];
}

+ (NSValueTransformer *)conditionJSONTransformer {
    return [self conditionDescriptionJSONTransformer];
}

+ (NSValueTransformer *)iconJSONTransformer {
    return [self conditionDescriptionJSONTransformer];
}



+ (NSValueTransformer *)windSpeedJSONTransformer {

    float MPS_TO_MPH = 2.23694f;
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
        return @(num.floatValue*MPS_TO_MPH);
    } reverseBlock:^(NSNumber *speed) {
        return @(speed.floatValue/MPS_TO_MPH);
    }];
}





















@end
