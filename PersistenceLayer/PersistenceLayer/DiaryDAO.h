//
//  DiaryDAO.h
//  PersistenceLayer
//
//  Created by tinoryj on 2017/1/30.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#ifndef DiaryDAO_h
#define DiaryDAO_h

#import <Foundation/Foundation.h>
#import "Diary.h"
#import "sqlite3.h"

#define DBFILE_NAME @"NotesList.sqlite3"


@interface DiaryDAO : NSObject
{
    sqlite3 *db;
}

+ (DiaryDAO*)sharedManager;

- (NSString *)applicationDocumentsDirectoryFile;

- (void)createEditableCopyOfDatabaseIfNeeded;


//插入方法
-(int) create:(Diary*)model;

//删除方法
-(int) remove:(Diary*)model;

//修改方法
-(int) modify:(Diary*)model;

//查询所有数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(Diary*) findById:(Diary*)model;

@end

#endif /* DiaryDAO_h */
