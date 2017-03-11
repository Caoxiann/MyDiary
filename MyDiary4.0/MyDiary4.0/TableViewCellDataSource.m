//
//  TableViewCellDataSource.m
//  MyDiary02
//
//  Created by 向尉 on 2017/2/8.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "TableViewCellDataSource.h"

@implementation TableViewCellDataSource

-(id)initWithText:(NSString *)text Year:(NSInteger)year Month:(NSInteger) month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Place:(NSString *)place Weekday:(NSInteger)weekday
{
    self=[super init];
    if (self)
    {
        _text=text;
        _year=year;
        _month=month;
        _day=day;
        _hour=hour;
        _minute=minute;
        _place=place;
        _weekday=weekday;
    }
    return self;
}

@end
