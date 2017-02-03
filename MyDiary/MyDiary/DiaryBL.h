//
//  DiaryBL.h
//  MyDiaryFOOO
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#ifndef DiaryBL_h
#define DiaryBL_h

#import <Foundation/Foundation.h>

#import "DiaryDAO.h"
#import "Diary.h"

@interface DiaryBL : NSObject

//插入方法
-(NSMutableArray*) createDiary:(Diary*)model;

//删除方法
-(NSMutableArray*) removeDiary:(Diary*)model;

//查询所用数据方法
-(NSMutableArray*) findAll;

//查询指定日期数据方法
//-(NSMutableArray*) findByDate:(Diary*)model;
@end


#endif /* DiaryBL_h */
