//
//  sqlService.m
//  DemoOfNotes
//
//  Created by Wujianyun on 18/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import "SqlService.h"
#import "Diary.h"
#import "Element.h"
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
    dataBasePath = [documents stringByAppendingPathComponent:@"MyDiary.sqlite"];
    db  = [FMDatabase databaseWithPath:dataBasePath];
}
//--------------------------------------------------------
#pragma mark - Table
-(void)createElementTable
{
    if([db open]){
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS ElEMENTTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT,CONTENT TEXT,TIME TEXT,YEAR TEXT,MONTH TEXT,DAY TEXT,TITLE TEXT,LOCATION TEXT)"];
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
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS DIARYTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT,CONTENT TEXT,TIME TEXT,YEAR TEXT,MONTH TEXT,DAY TEXT,TITLE TEXT,LOCATION TEXT)"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        
        if(!res){
            NSLog(@"create error");
        }else{
            NSLog(@"success");
        }
        
        [db close];
        
    }
}

-(void)insertElementDBtable:(Element *)element{
    [self createElementTable];
    
    if([db open]){
        NSString *sqlInsertTable = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@','%@','%@','%@','%@')VALUES ('%@','%@','%@','%@','%@','%@','%@')",@"elementtable",@"content",@"time",@"year",@"month",@"day",@"title",@"location",element.content,element.time,element.year,element.month,element.day,element.title,element.location];
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
        NSString *sqlInsertTable = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@','%@','%@','%@','%@')VALUES ('%@','%@','%@','%@','%@','%@','%@')",@"diarytable",@"content",@"time",@"year",@"month",@"day",@"title",@"location",diary.content,diary.time,diary.year,diary.month,diary.day,diary.title,diary.location];
        BOOL res = [db executeUpdate:sqlInsertTable];
        if(!res){
            NSLog(@"插入失败");
        }else{
            NSLog(@"insert success");
        }
        
        [db close];
    }
}

-(void)updateElementDBtable:(Element *)element{
    if([db open]){
        NSString *sqlUpdeteTable = [NSString stringWithFormat:@"UPDATE '%@' SET '%@' = '%@' , '%@' = '%@' ,'%@' = '%@','%@' = '%@','%@' = '%@', '%@' = '%@','%@' = '%@' WHERE %@ = %ld",@"elementtable",@"content",element.content,@"time",element.time,@"year",element.year,@"month",element.month,@"day",element.day ,@"title",element.title,@"location",element.location,@"id",element.elementID];
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
        NSString *sqlUpdeteTable = [NSString stringWithFormat:@"UPDATE '%@' SET '%@' = '%@' , '%@' = '%@' ,'%@' = '%@','%@' = '%@','%@' = '%@', '%@' = '%@','%@' = '%@' WHERE %@ = %ld",@"diarytable",@"content",diary.content,@"time",diary.time,@"year",diary.year,@"month",diary.month,@"day",diary.day,@"title",diary.title,@"location",diary.location,@"id",diary.diaryID];
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

-(BOOL)deleteElement:(Element *) element{
    if([db open]){
        
        NSString *sqlDelete = [NSString stringWithFormat:@"delete from %@ where %@ = %ld",@"elementtable",@"id",(long)element.elementID];
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


-(NSArray *)queryElementDBtable{
    [self createElementTable];
    
    NSMutableArray *array  = [NSMutableArray array];
    
    if([db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@",@"elementtable"];;
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            Element*element=[[Element alloc]init];
            element.elementID = [rs intForColumn:@"id"];
            element.content = [rs stringForColumn:@"content"];
            element.time = [rs stringForColumn:@"time"];
            element.year= [rs stringForColumn:@"year"];
            element.month=[rs stringForColumn:@"month"];
            element.day=[rs stringForColumn:@"day"];
            element.title=[rs stringForColumn:@"title"];
            element.location=[rs stringForColumn:@"location"];
            [array addObject:element];
        }
        [db close];
        return [array copy];
    }
    return nil;

}
-(NSArray *)queryElementDBtable:(NSDate *)date {
    [self createElementTable];
    
    NSMutableArray *array  = [NSMutableArray array];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year=[formatter stringFromDate:date];
    [formatter setDateFormat:@"MM"];
    NSString *month=[formatter stringFromDate:date];
    [formatter setDateFormat:@"dd"];
    NSString *day=[formatter stringFromDate:date];
    if([db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@ WHERE %@ = %@",@"elementtable",@"year",year];;
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            if(month==[rs stringForColumn:@"month"]) {
                if(day==[rs stringForColumn:@"day"]) {
                    Element*element=[[Element alloc]init];
                    element.elementID = [rs intForColumn:@"id"];
                    element.content = [rs stringForColumn:@"content"];
                    element.time = [rs stringForColumn:@"time"];
                    element.year= [rs stringForColumn:@"year"];
                    element.month=[rs stringForColumn:@"month"];
                    element.day=[rs stringForColumn:@"day"];
                    element.title=[rs stringForColumn:@"title"];
                    element.location=[rs stringForColumn:@"location"];
                    [array addObject:element];
                }
            }
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
            diary.year= [rs stringForColumn:@"year"];
            diary.month=[rs stringForColumn:@"month"];
            diary.day=[rs stringForColumn:@"day"];
            diary.title=[rs stringForColumn:@"title"];
            diary.location=[rs stringForColumn:@"location"];
            [array addObject:diary];
        }
        [db close];
        return [array copy];
    }
    return nil;
}


@end
