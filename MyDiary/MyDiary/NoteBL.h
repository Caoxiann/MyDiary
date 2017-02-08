//
//  NOteBL.h
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NoteDAO.h"
#import "Note.h"

@interface NoteBL : NSObject
//插入
- (NSMutableArray*)createNote:(Note*)model;
//修改
- (NSMutableArray*)modifyNote:(Note*)model;
//删除
- (NSMutableArray*)removeNote:(Note*)model;
//ID查询
- (NSMutableArray*)findID:(Note*)model;
//查询所用数据
- (NSMutableArray*)findAll;

- (void)setdata;
@end
