//
//  timeDealler.m
//  DemoOfNotes
//
//  Created by Wujianyun on 17/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import "timeDealler.h"

@implementation TimeDealler
+(NSString *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
@end
