//
//  CalendarTable.h
//  MyDiary
//
//  Created by tinoryj on 2017/2/10.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarItems.h"
#import "CalendarViewController.h"

@interface CalendarTable : UIView

- (instancetype)initWithCurrentDate:(NSDate *)date;

@property (nonatomic,weak) id<selectedUpdate> selectedDelegate;

@end
