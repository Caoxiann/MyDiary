//
//  sqlService.m
//  DemoOfNotes
//
//  Created by Wujianyun on 18/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import "SqlService.h"
#import "Diary.h"
#import "Item.h"
#import "FMDatabase.h"

static SqlService *sqlService;
@interface SqlService(){
    
}

@property (nonatomic,strong)FMDatabase *db;
@property (nonatomic,strong)NSString *dataBasePath;

@end
@implementation SqlService
@synthesize db;
@synthesize dataBasePath;

#pragma mark - dataBase
+(SqlService *)sqlInstance{
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
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self){
        if(!sqlService){
            sqlService = [super allocWithZone:zone];
        }
    }
    
    return sqlService;
}

-(void)setSqlDB{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    dataBasePath = [documents stringByAppendingPathComponent:@"DemoOfNotes.sqlite"];
    db  = [FMDatabase databaseWithPath:dataBasePath];
}
//--------------------------------------------------------
#pragma mark - Table
-(void)createItemTable
{
    if([db open]){
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS ITEMTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT,CONTENT TEXT,TIME TEXT,DATE TEXT)"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        
        if(!res){
            NSLog(@"create error");
        }else{
            NSLog(@"success");
        }
        
        [db close];
        
    }
}
-(void)createDiaryTable
{
    if([db open]){
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS DIARYTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT,CONTENT TEXT,TIME TEXT,DATE TEXT)"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        
        if(!res){
            NSLog(@"create error");
        }else{
            NSLog(@"success");
        }
        
        [db close];
        
    }
}

-(void)insertItemDBtable:(Item *)item{
    [self createItemTable];
    
    if([db open]){
        NSString *sqlInsertTable = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@')VALUES ('%@','%@','%@')",@"itemtable",@"content",@"time",@"date",item.content,item.time,item.date];
        BOOL res = [db executeUpdate:sqlInsertTable];
        if(!res){
            NSLog(@"插入失败");
        }else{
            NSLog(@"insert success");
        }
        
        [db close];
    }
}

-(void)insertDiaryDBtable:(Diary *)diary{
    [self createDiaryTable];
    
    if([db open]){
        NSString *sqlInsertTable = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@')VALUES ('%@','%@','%@')",@"diarytable",@"content",@"time",@"date",diary.content,diary.time,diary.date];
        BOOL res = [db executeUpdate:sqlInsertTable];
        if(!res){
            NSLog(@"插入失败");
        }else{
            NSLog(@"insert success");
        }
        
        [db close];
    }
}

-(void)updateItemDBtable:(Item *)item{
    if([db open]){
        NSString *sqlUpdeteTable = [NSString stringWithFormat:@"UPDATE '%@' SET '%@' = '%@' , '%@' = '%@' , '%@' = '%@' WHERE %@ = %ld",@"itemtable",@"content",item.content,@"time",item.time,@"date",item.date,@"ID",(long)item.itemID];
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
-(void)updateDiaryDBtable:(Diary *)diary{
    if([db open]){
        NSString *sqlUpdeteTable = [NSString stringWithFormat:@"UPDATE '%@' SET '%@' = '%@' , '%@' = '%@' , '%@' = '%@' WHERE %@ = %ld",@"diarytable",@"content",diary.content,@"time",diary.time,@"date",diary.date,@"id",(long)diary.diaryID];
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

-(BOOL)deleteItem:(Item *) item{
    if([db open]){
        
        NSString *sqlDelete = [NSString stringWithFormat:@"delete from %@ where %@ = %ld",@"itemtable",@"id",(long)item.itemID];
        BOOL res = [db executeUpdate:sqlDelete];
        if(res){
            NSLog(@"delete success");
        }else{
            NSLog(@"delete error");
        }
        [db close];
        return  res;
    }
    return NO;
}
-(BOOL)deleteDiary:(Diary *)diary{
        if([db open]){
            
            NSString *sqlDelete = [NSString stringWithFormat:@"delete from %@ where %@ = %ld",@"diarytable",@"id",(long)diary.diaryID];
            BOOL res = [db executeUpdate:sqlDelete];
            if(res){
                NSLog(@"delete success");
            }else{
                NSLog(@"delete error");
            }
            [db close];
            return  res;
        }
    return NO;
}


-(NSArray *)queryItemDBtable{
    [self createItemTable];
    
    NSMutableArray *array  = [NSMutableArray array];
    
    if([db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@",@"itemtable"];;
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            Item*item=[[Item alloc]init];
            item.itemID = [rs intForColumn:@"id"];
            item.content = [rs stringForColumn:@"content"];
            item.time = [rs stringForColumn:@"time"];
            item.date= [rs stringForColumn:@"date"];
            [array addObject:item];
        }
        [db close];
        return [array copy];
    }
    return nil;

}
-(NSArray *)queryDiaryDBtable{
    [self createDiaryTable];
    
    NSMutableArray *array  = [NSMutableArray array];
    
    if([db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@",@"diarytable"];;
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            Diary *diary=[[Diary alloc]init];
            diary.diaryID = [rs intForColumn:@"id"];
            diary.content = [rs stringForColumn:@"content"];
            diary.time = [rs stringForColumn:@"time"];
            diary.date= [rs stringForColumn:@"date"];
            [array addObject:diary];
        }
        [db close];
        return [array copy];
    }
    return nil;
}


@end
