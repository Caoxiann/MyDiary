//
//  BXCalendar.h
//  BXCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewController.h"

@interface BXCalendar : UIView

- (instancetype)initWithCurrentDate:(NSDate *)date;

@property (nonatomic,weak) id<selectedUpdate> selectedDelegate;

@end




