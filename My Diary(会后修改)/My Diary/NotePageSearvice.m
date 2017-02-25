//
//  NotePageSearvice.m
//  My Diary
//
//  Created by 徐贤达 on 2017/2/2.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import "NotePageSearvice.h"
#import "NotePage.h"
#import "SqlService.h"
#import "TimeDealler.h"


@implementation NotePageSearvice

//创建Notepage
+(void)creatNotepage:(NSString *)content title:(NSString*)titile location:(NSString*)location time:(NSString*)time
{
    if ([content length] == 0)
    {
        return;
    }
    NotePage *notePage = [[NotePage alloc]init];
    notePage.location=location;
    notePage.titile=titile;
    notePage.content = content;
    notePage.time = time;
    [[SqlService sqlInstance] insertDBtable:notePage];
}

//更新Notepage
+(void)updateNotePage:(NSString *)content title:(NSString*)titile location:(NSString*)location time:(NSString*)time currentNotePage:(NotePage *)notePage
{
    notePage.titile=titile;
    notePage.content = content;
    notePage.location=location;
    notePage.time = time;
    [[SqlService sqlInstance]updateDBtable:notePage];
}

//删除Notepage
+(void)deleteNotePage:(NSString *)content title:(NSString*)titile location:(NSString*)location time:(NSString*)time currentNotePage:(NotePage *)notePage
{
    [[SqlService sqlInstance]deleteDBtableList:notePage];
}


@end
