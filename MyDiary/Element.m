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
+(void)creatElementWithContent:(NSString *)content andTime:(NSString *)time andDate:(NSString *)date{
    Element *element=[[Element alloc]init];
    element.content=content;
    element.time=time;
    element.date=date;
    [[SqlService sqlInstance] insertElementDBtable:element];
}
+(void)updateElementWithContent:(NSString *)content andTime:(NSString *)time andDate:(NSString *)date currentElement:(Element *)element{
    element.content=content;
    element.time=time;
    element.date=date;
    [[SqlService sqlInstance] updateElementDBtable:element];
}
+(void)deleteElement:(Element *)element{
    [[SqlService sqlInstance]deleteElement:element];
}
@end
