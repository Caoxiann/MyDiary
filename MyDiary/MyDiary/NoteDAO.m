//
//  NOteDAO.m
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "NoteDAO.h"

@implementation NoteDAO

static NoteDAO *sharedManager = nil;

+ (NoteDAO*)sharedManager{
    
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
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS Note (cdate TEXT PRIMARY KEY, title TEXT, content TEXT, location TEXT);"];
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
    NSString *path = [documentDirectory stringByAppendingPathComponent:NOTE_DBFILE_NAME];
    
    return path;
}
//插入
- (int)create:(Note*)model{
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSAssert(NO,@"数据库打开失败。");
    }
    else {
        
        NSString *sql = @"INSERT OR REPLACE INTO note (cdate, title, content, location) VALUES (?,?,?,?)";
        const char* cSql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:model.date];
            const char* cDate  = [strDate UTF8String];
            const char* cTitle = [model.title UTF8String];
            const char* cContent = [model.content UTF8String];
            const char* cLocation = [model.location UTF8String];
            //绑定参数开始
            sqlite3_bind_text(statement, 1, cDate, -1, NULL);
            sqlite3_bind_text(statement, 2, cTitle, -1, NULL);
            sqlite3_bind_text(statement, 3, cContent, -1, NULL);
            sqlite3_bind_text(statement, 4, cLocation, -1, NULL);
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
//删除
- (int)remove:(Note*)model{
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSAssert(NO,@"数据库打开失败。");
    }
    else {
        NSString *sql = @"DELETE  from note where cdate =?";
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
//修改
- (int)modify:(Note*)model{
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSAssert(NO,@"数据库打开失败。");
    }
    else {
        
        NSString *sql = @"UPDATE note set title=? content=? location=? where cdate =?";
        const char* cSql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:model.date];
            const char* cDate  = [strDate UTF8String];
            const char* cTitle = [model.title UTF8String];
            const char* cContent = [model.content UTF8String];
            const char* cLocation = [model.location UTF8String];
            //绑定参数开始
            sqlite3_bind_text(statement, 1, cDate, -1, NULL);
            sqlite3_bind_text(statement, 2, cTitle, -1, NULL);
            sqlite3_bind_text(statement, 3, cContent, -1, NULL);
            sqlite3_bind_text(statement, 4, cLocation, -1, NULL);
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
//查询所有数据
-(NSMutableArray*) findAll{
    
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO,@"数据库打开失败。");
    } else {
        
        NSString *sql =@"SELECT cdate,title,content,location FROM Note";
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
                char *bufLocation = (char *) sqlite3_column_text(statement, 3);
                NSString * strLocation = [[NSString alloc] initWithUTF8String: bufLocation];
                
                Note* note = [[Note alloc]initWithDate:date title:strTitle content:strContent location:strLocation];
                
                [listData addObject:note];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
        
    }
    return listData;
}

//按照主键查询数据
- (Note*)findById:(Note*)model{
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char* cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSAssert(NO,@"数据库打开失败。");
    }
    else {
        
        NSString *sql = @"SELECT cdate,title,content,location FROM Note where cdate =?";
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
                char *bufLocation = (char *) sqlite3_column_text(statement, 3);
                NSString * strLocation = [[NSString alloc] initWithUTF8String: bufLocation];
                
                Note* note = [[Note alloc]initWithDate:date title:strTitle content:strContent location:strLocation];
                
                sqlite3_finalize(statement);
                sqlite3_close(db);
                
                return note;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return nil;
}

@end
