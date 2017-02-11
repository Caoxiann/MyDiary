//
//  CalendarItems.h
//  MyDiary
//
//  Created by tinoryj on 2017/2/10.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarItemsDelegate;

@interface CalendarItems : UIView

@property (strong, nonatomic) NSDate *date;

@property (weak, nonatomic) id<CalendarItemsDelegate> delegate;

- (NSDate *)nextMonthDate;

- (NSDate *)previousMonthDate;

@end

@protocol CalendarItemsDelegate <NSObject>

- (void)calendarItem:(CalendarItems *)item didSelectedDate:(NSDate *)date;

@end
