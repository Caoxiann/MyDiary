//
//  DiaryDAO.h
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Diary.h"
#import "sqlite3.h"

#define DIARY_DBFILE_NAME @"DiaryList.sqlite3"

@interface DiaryDAO : NSObject
{
    sqlite3 *db;
}

+ (DiaryDAO*)sharedManager;

- (NSString *)applicationDocumentsDirectoryFile;

- (void)createEditableCopyOfDatabaseIfNeeded;

//插入
-(int) create:(Diary*)model;

//删除
-(int) remove:(Diary*)model;

//修改
-(int) modify:(Diary*)model;

//查询所有数据
-(NSMutableArray*) findAll;

//按照主键查询数据
-(Diary*) findById:(Diary*)model;

@end

