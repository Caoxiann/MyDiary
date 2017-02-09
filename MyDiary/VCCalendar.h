//
//  VCCalendar.h
//  MyDiary
//
//  Created by Jimmy Fan on 2017/1/22.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FSCalendar.h"

@interface VCCalendar : UIViewController <FSCalendarDelegate,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource> {
    UISegmentedControl* _segControl;
    FMDatabase* _mDB;
    UIBarButtonItem* btn01;
    UIBarButtonItem* btn02;
    UIBarButtonItem* btn03;
    UIBarButtonItem* btn04;
    UIBarButtonItem* btn05;
    UIBarButtonItem* btnF01;
    UIBarButtonItem* btnF02;
    UIToolbar* _toolbar;
    NSMutableArray* _arrayMonth;
    NSMutableArray* _arrayDay;
    NSMutableArray* _arrayWeek;
    NSMutableArray* _arrayTitle;
    NSMutableArray* _arrayContent;
    NSMutableArray* _arrayID;
    NSMutableArray* _arrayMinute;
    UITableView* _tableView;
    FSCalendar* _calendar;
}

- (NSString*)shortDay:(NSString*)day;

@end
