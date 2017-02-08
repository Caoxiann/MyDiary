//
//  DiaryBL.h
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DiaryDAO.h"
#import "Diary.h"

@interface DiaryBL : NSObject
//插入
-( NSMutableArray*)createDiary:(Diary*)model;
//修改
- (NSMutableArray*)modifyDiary:(Diary*)model;
//删除
- (NSMutableArray*)removeDiary:(Diary*)model;
//查询所用数据
- (NSMutableArray*) findAll;

@end

