//
//  Diary.h
//  MyDiary
//
//  Created by Wujianyun on 15/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Diary : NSObject
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *day;
@property (nonatomic,strong)NSString *month;
@property (nonatomic,strong)NSString *year;
@property (nonatomic,assign)NSInteger diaryID;
@property (nonatomic,strong)NSMutableDictionary* date;

+(void)creatdiaryWithContent:(NSString *)content andTime:(NSString *)time andDate:(NSString *)date;
+(void)updateDiaryWithContent:(NSString *)content andTime:(NSString *)time andDate:(NSString *)date currentDiary:(Diary *)diary;
+(void)deletediary:(Diary *)diary;
-(void)setDates;
@end
