//
//  BXCalendarItem.h
//  BXCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DeviceWidth [UIScreen mainScreen].bounds.size.width

@protocol BXCalendarItemDelegate;

@interface BXCalendarItem : UIView

@property (strong, nonatomic) NSDate *date;
@property (weak, nonatomic) id<BXCalendarItemDelegate> delegate;

- (NSDate *)nextMonthDate;
- (NSDate *)previousMonthDate;

@end

@protocol BXCalendarItemDelegate <NSObject>

- (void)calendarItem:(BXCalendarItem *)item didSelectedDate:(NSDate *)date;

@end
