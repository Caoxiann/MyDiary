//
//  timeDealler.m
//  DemoOfNotes
//
//  Created by Wujianyun on 17/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import "timeDealler.h"

@implementation TimeDealler
+(NSMutableDictionary *)getCurrentTime{
    NSMutableDictionary *dateDic=[[NSMutableDictionary alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString * year = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"MM"];
    NSString * month=[formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"dd"];
    NSString * day=[formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"HH"];
    NSString * hour=[formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"mm"];
    NSString * minute=[formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"ss"];
    NSString * second=[formatter stringFromDate:[NSDate date]];

    [dateDic setObject:year forKey:@"year"];
    [dateDic setObject:month forKey:@"month"];
    [dateDic setObject:day forKey:@"day"];
    [dateDic setObject:hour forKey:@"hour"];
    [dateDic setObject:minute forKey:@"minute"];
    [dateDic setObject:second forKey:@"second"];
    
    
    return dateDic;
}
@end
