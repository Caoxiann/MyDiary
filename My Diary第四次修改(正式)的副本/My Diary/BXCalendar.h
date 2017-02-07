//
//  BXCalendar.h
//  BXCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol timeDelegate;

@interface BXCalendar : UIView

- (instancetype)initWithCurrentDate:(NSDate *)date;

@property (nonatomic,weak) id<timeDelegate> delegate;

@end

@protocol timeDelegate <NSObject>

-(void) time:(BXCalendar *)calendar timeTrans:(NSString*)timeString;

@end




