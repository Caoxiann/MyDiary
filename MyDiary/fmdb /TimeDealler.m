//
//  timeDealler.m
//  DemoOfNotes
//
//  Created by Wujianyun on 17/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import "timeDealler.h"

@implementation TimeDealler
+(NSMutableDictionary *)getCurrentDate {
    NSMutableDictionary *dateDic=[[NSMutableDictionary alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString * year = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"MM"];
    NSString * month=[formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"dd"];
    NSString * day=[formatter stringFromDate:[NSDate date]];

    [dateDic setObject:year forKey:@"year"];
    [dateDic setObject:month forKey:@"month"];
    [dateDic setObject:day forKey:@"day"];
    
    return dateDic;
}
/*
+(NSString *)getCurrentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString * date = [formatter stringFromDate:[NSDate date]];
    return date;
}
*/
+(NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSString * time=[formatter stringFromDate:[NSDate date]];
    return time;
}
@end
