//
//  TableViewCellDataSource.m
//  MyDiary02
//
//  Created by 向尉 on 2017/2/8.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "TableViewCellDataSource.h"

@implementation TableViewCellDataSource

-(id)initWithText:(NSString *)text Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Place:(NSString *)place
{
    self=[super init];
    if (self) {
        self.text=text;
        self.day=day;
        self.hour=hour;
        self.minute=minute;
        self.place=place;
    }
    return self;
}

@end
