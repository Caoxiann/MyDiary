//
//  SqlService.m
//  My Diary
//
//  Created by 徐贤达 on 2017/2/2.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import "SqlService.h"
#import "FMDatabase.h"
#import "NotePage.h"


#define TABLENAME @"notetable"
#define TITLE @"title"
#define CONTENT @"content"
#define TIME @"time"
#define ID @"id"
#define DBNAME @"noteinfo.sqlite"

static SqlService *sqlService;

@interface SqlService()

@property (nonatomic,strong)FMDatabase *db;
@property (nonatomic,strong)NSString *dataBasePath;

@end

@implementation SqlService
@synthesize db;
@synthesize dataBasePath;

+(SqlService *)sqlInstance
{
    @synchronized(self){
        if(!sqlService){
             sqlService = [[self alloc]init];
        }
    }
    return sqlService;
}

-(id)init{
    self = [super init];
    if(self){
        [self setSqlDB];
    }
    return self;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self){
        if(!sqlService){
            sqlService = [super allocWithZone:zone];
        }
    }
    return sqlService;
}

-(void)setSqlDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    dataBasePath = [documents stringByAppendingPathComponent:DBNAME];
    db  = [FMDatabase databaseWithPath:dataBasePath];
}

//创建数据库
-(void)createDBList
{
    if([db open]){
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS NOTETABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT,TITLE TEXT,CONTENT TEXT,TIME TEXT)"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if(!res){
            NSLog(@"create error");
        }else{
            NSLog(@"success");
        }
        [db close];
     }
}

-(void)insertDBtable:(NotePage *)notePage
{
    [self createDBList];
    if([db open]){
        NSString *sqlInsertTable = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@')VALUES ('%@','%@','%@')",TABLENAME,TITLE,CONTENT,TIME,notePage.titile,notePage.content,notePage.time];
        BOOL res = [db executeUpdate:sqlInsertTable];
        if(!res){
            NSLog(@"插入失败");
        }else{
            NSLog(@"insert success");
        }
        [db close];
     }
}

-(void)updateDBtable:(NotePage *)notePage
{
    if([db open]){
        NSString *sqlUpdeteTable = [NSString stringWithFormat:@"UPDATE %@ SET '%@' = '%@' , '%@' = '%@' , '%@' = '%@' WHERE %@ = %lu",TABLENAME,TITLE,notePage.titile,CONTENT,notePage.content,TIME,notePage.time,ID,notePage.noteID];
        NSLog(@"%@",sqlUpdeteTable);
        BOOL res = [db executeUpdate:sqlUpdeteTable];
        if(!res){
            NSLog(@"update error");
        }else{
            NSLog(@"update success");
        }
        [db close];
    }
}

-(BOOL)deleteDBtableList:(NotePage *)notePage
{
    if([db open]){
        NSString *sqlDelete = [NSString stringWithFormat:@"delete from %@ where %@ = %lu",TABLENAME,ID,notePage.noteID];
        BOOL res = [db executeUpdate:sqlDelete];
        if(!res){
            NSLog(@"delete error");
        }else{
            NSLog(@"delete success");
        }
        [db close];
        return  res;
    }
    return NO;
}

-(NSArray *)queryDBtable
{
    [self createDBList];
    NSMutableArray *array  = [NSMutableArray array];
    if([db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@",TABLENAME];;
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NotePage *notePage = [[NotePage alloc]init];
            notePage.noteID = [rs intForColumn:ID];
            notePage.titile = [rs stringForColumn:TITLE];
            notePage.content = [rs stringForColumn:CONTENT];
            notePage.time = [rs stringForColumn:TIME];
            [array addObject:notePage];
        }
        [db close];
        return [array copy];
    }
    return nil;
}

@end
