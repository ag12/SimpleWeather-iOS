//
//  WXController.h
//  SimpleWeather
//
//  Created by ag07 on 06/11/14.
//  Copyright (c) 2014 ag07. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) NSDateFormatter *hourlyFormatter;
@property (nonatomic, strong) NSDateFormatter *dailyFormatter;
@end
