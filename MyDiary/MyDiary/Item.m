//
//  Item.m
//  MyDiary
//
//  Created by Wujianyun on 15/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "Item.h"
#import "SqlService.h"
@implementation Item
+(void)creatItemWithContent:(NSString *)content andTime:(NSString *)time andDate:(NSString *)date{
    Item *item=[[Item alloc]init];
    item.content=content;
    item.time=time;
    item.date=date;
    [[SqlService sqlInstance] insertItemDBtable:item];
}
+(void)updateItemWithContent:(NSString *)content andTime:(NSString *)time andDate:(NSString *)date currentItem:(Item *)item{
    item.content=content;
    item.time=time;
    item.date=date;
    [[SqlService sqlInstance] updateItemDBtable:item];
}
+(void)deleteItem:(Item *)item{
    [[SqlService sqlInstance]deleteItem:item];
}
@end
