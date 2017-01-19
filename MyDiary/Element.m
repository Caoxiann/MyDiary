//
//  Element.m
//  MyDiary
//
//  Created by Wujianyun on 15/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "Element.h"
#import "SqlService.h"
@implementation Element

+(void)creatElementWithContent:(NSString *)content andTime:(NSString *)time andDate:(NSMutableDictionary *)date{
    Element *element=[[Element alloc]init];
    element.content=content;
    element.time=time;
    element.date=date;
    [element setDates];
    [[SqlService sqlInstance] insertElementDBtable:element];
}
+(void)updateElementWithContent:(NSString *)content andTime:(NSString *)time andDate:(NSMutableDictionary *)date currentElement:(Element *)element{
    element.content=content;
    element.time=time;
    element.date=date;
    [element setDates];
    [[SqlService sqlInstance] updateElementDBtable:element];
}
+(void)deleteElement:(Element *)element{
    [[SqlService sqlInstance]deleteElement:element];
}
-(void)setDates{
    self.year=[self.date objectForKey:@"year"];
    self.month=[self.date objectForKey:@"month"];
    self.day=[self.date objectForKey:@"day"];
}

@end
