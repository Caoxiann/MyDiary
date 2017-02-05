//
//  DiaryBL.m
//  MyDiaryFOOO
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "DiaryBL.h"

@implementation DiaryBL

//插入
-(NSMutableArray*) createDiary:(Diary*)model {
    
    DiaryDAO *dao = [DiaryDAO sharedManager];
    [dao create:model];
    
    return [dao findAll];
}

//删除
-(NSMutableArray*) removeDiary:(Diary*)model {
    
    DiaryDAO *dao = [DiaryDAO sharedManager];
    [dao remove:model];
    
    return [dao findAll];
}

//查询所用数据
-(NSMutableArray*) findAll{
    
    DiaryDAO *dao = [DiaryDAO sharedManager];
    return [dao findAll];
}

//查询指定日期数据
/*
-(NSMutableArray*) findByDate:(Diary*)model {
    
    DiaryDAO *dao = [DiaryDAO sharedManager];
    NSMutableArray *diaryFindByDate = [dao findById:model];
    return diaryFindByDate;
}
*/
@end
