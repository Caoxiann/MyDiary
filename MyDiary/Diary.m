//
//  Diary.m
//  MyDiary
//
//  Created by Wujianyun on 15/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "Diary.h"
#import "SqlService.h"

@implementation Diary
+(void)creatdiaryWithContent:(NSString *)content andTime:(NSString *)time andDate:(NSMutableDictionary *)date{
    Diary *diary=[[Diary alloc]init];
    diary.content=content;
    diary.time=time;
    diary.date=date;
    [diary setDates];
    [[SqlService sqlInstance] insertDiaryDBtable:diary];
}
+(void)updateDiaryWithContent:(NSString *)content andTime:(NSString *)time andDate:(NSMutableDictionary *)date currentDiary:(Diary *)diary{
    diary.content=content;
    diary.time=time;
    diary.date=date;
    [diary setDates];
    [[SqlService sqlInstance] updateDiaryDBtable:diary];
}
+(void)deletediary:(Diary *)diary{
    [[SqlService sqlInstance]deleteDiary:diary];
}
-(void)setDates{
    self.year=[self.date objectForKey:@"year"];
    self.month=[self.date objectForKey:@"month"];
    self.day=[self.date objectForKey:@"day"];
}
@end
