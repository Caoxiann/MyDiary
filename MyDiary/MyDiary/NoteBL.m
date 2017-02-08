//
//  NoteBL.m
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "NoteBL.h"

@implementation NoteBL

//插入
- (NSMutableArray*)createNote:(Note*)model{
    
    NoteDAO *dao = [NoteDAO sharedManager];
    [dao create:model];
    
    return [dao findAll];
}


//修改
- (NSMutableArray*)modifyNote:(Note *)model{
    
    NoteDAO *dao = [NoteDAO sharedManager];
    [dao modify:model];
    
    return [dao findAll];
}

//删除
- (NSMutableArray*)removeNote:(Note*)model{
    
    NoteDAO *dao = [NoteDAO sharedManager];
    [dao remove:model];
    
    return [dao findAll];
}

//查找
- (NSMutableArray*)findID:(Note *)model{
    
    NoteDAO *dao = [NoteDAO sharedManager];
    NSMutableArray *noteWithID = [[NSMutableArray alloc]init];
    for (int i = 0; i < [[self findAll] count]; i++) {
        [noteWithID insertObject:[dao findById:model] atIndex:i];
    }
    
    return noteWithID;
}
//查询所用数据方法
- (NSMutableArray*)findAll{
    
    NoteDAO *dao = [NoteDAO sharedManager];
    
    return [dao findAll];
}

- (void)setdata{
    

}

@end
