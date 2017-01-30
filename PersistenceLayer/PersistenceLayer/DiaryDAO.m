//
//  DiaryDAO.m
//  PersistenceLayer
//
//  Created by tinoryj on 2017/1/30.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "DiaryDAO.h"

@implementation DiaryDAO


static DiaryDAO *sharedManager = nil;

+ (DiaryDAO*)sharedManager {
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedManager = [[self alloc] init];
        [sharedManager createEditableCopyOfDatabaseIfNeeded];
        
    });
    return sharedManager;
}


- (void)createEditableCopyOfDatabaseIfNeeded {
    
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    const char* cpath = [writableDBPath UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSAssert(NO,@"数据库打开失败。");
        
    }
    else {
        
        char *err;
        
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS Diary (cdate TEXT PRIMARY KEY,title TEXT, content TEXT);"];
        const char* cSql = [sql UTF8String];
        
        if (sqlite3_exec(db, cSql,NULL,NULL,&err) != SQLITE_OK) {
            sqlite3_close(db);
            NSAssert(NO, @"建表失败");
        }
        sqlite3_close(db);
        
    }
}

- (NSString *)applicationDocumentsDirectoryFile {
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:DBFILE_NAME];
    
    return path;
}


//插入方法
-(int) create:(Diary*)model {
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO,@"数据库打开失败。");
    }
    else {
        
        NSString *sql = @"INSERT OR REPLACE INTO note (cdate, title, content) VALUES (?, ?, ?)";
        const char* cSql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:model.date];
            const char* cDate = [strDate UTF8String];
            const char* cTitle = [model.title UTF8String];
            const char* cContent = [model.content UTF8String];
            
            //绑定参数开始
            sqlite3_bind_text(statement, 1, cDate, -1, NULL);
            sqlite3_bind_text(statement, 2, cTitle, -1, NULL);
            sqlite3_bind_text(statement, 3, cContent, -1, NULL);
            
            //执行插入
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"插入数据失败。");
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    
    return 0;
}

//删除方法
-(int) remove:(Diary*)model {
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO,@"数据库打开失败。");
    }
    else {
        NSString *sql = @"DELETE  from note where cdate = ?";
        const char* cSql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:model.date];
            const char* cDate  = [strDate UTF8String];
            
            //绑定参数开始
            sqlite3_bind_text(statement, 1, cDate, -1, NULL);
            //执行
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"删除数据失败。");
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    
    return 0;
}

//修改方法
-(int) modify:(Diary*)model {
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO,@"数据库打开失败。");
    }
    else {
        
        NSString *sql = @"UPDATE note set content=? where cdate =?";
        const char* cSql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:model.date];
            const char* cDate = [strDate UTF8String];
            const char* cTitle = [model.title UTF8String];
            const char* cContent = [model.content UTF8String];
            
            //绑定参数开始
            sqlite3_bind_text(statement, 1, cDate, -1, NULL);
            sqlite3_bind_text(statement, 2, cTitle, -1, NULL);
            sqlite3_bind_text(statement, 3, cContent, -1, NULL);
            //执行
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"修改数据失败。");
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return 0;
}

//查询所有数据方法
-(NSMutableArray*) findAll {
    
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO,@"数据库打开失败。");
    }
    else {
        
        NSString *sql =@"SELECT cdate,content FROM Note";
        const char* cSql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            //执行
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *bufDate = (char *) sqlite3_column_text(statement, 0);
                NSString *strDate = [[NSString alloc] initWithUTF8String: bufDate];
                NSDate *date = [dateFormatter dateFromString:strDate];
                
                char *bufTitle = (char *) sqlite3_column_text(statement, 1);
                NSString * strTitle = [[NSString alloc] initWithUTF8String: bufTitle];

                
                char *bufContent = (char *) sqlite3_column_text(statement, 2);
                NSString * strContent = [[NSString alloc] initWithUTF8String: bufContent];
                
                Diary* diary = [[Diary alloc]initWithDate:date title:strTitle content:strContent];
                
                [listData addObject:diary];
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
        
    }
    return listData;
}

//按照主键查询数据方法
-(Diary*) findById:(Diary*)model {
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO,@"数据库打开失败。");
    }
    else {
        
        NSString *sql = @"SELECT cdate,content FROM Note where cdate =?";
        const char* cSql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK) {
            //准备参数
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:model.date];
            const char* cDate  = [strDate UTF8String];
            
            //绑定参数开始
            sqlite3_bind_text(statement, 1, cDate, -1, NULL);
            
            //执行
            if (sqlite3_step(statement) == SQLITE_ROW) {
                
                char *bufDate = (char *) sqlite3_column_text(statement, 0);
                NSString *strDate = [[NSString alloc] initWithUTF8String: bufDate];
                NSDate *date = [dateFormatter dateFromString:strDate];
                
                char *bufTitle = (char *) sqlite3_column_text(statement, 1);
                NSString * strTitle = [[NSString alloc] initWithUTF8String: bufTitle];
                
                
                char *bufContent = (char *) sqlite3_column_text(statement, 2);
                NSString * strContent = [[NSString alloc] initWithUTF8String: bufContent];
                
                Diary* diary = [[Diary alloc]initWithDate:date title:strTitle content:strContent];
                
                sqlite3_finalize(statement);
                sqlite3_close(db);
                
                return diary;
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
        
    }
    return nil;
}

@end
