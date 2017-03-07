//
//  VCDiary.h
//  MyDiary02
//
//  Created by 向尉 on 2017/1/20.
//  Copyright © 2017年 向尉. All rights reserved.
//
#import "ViewController.h"
#import "VCDiaryWrite.h"

@class FMDatabase;


@interface VCDiary : ViewController
<UITableViewDataSource,UITableViewDelegate,VCDiaryWriteDelegate>

/* a tableView to show projects*/
@property(nonatomic,retain)UITableView *tableView;

/* a button to delete selected projects in tableView when is under the edit state*/
@property(nonatomic,retain)UIBarButtonItem *deleteBtn;

/* a button to commit edit state*/
@property(nonatomic,retain)UIBarButtonItem *finishBtn;

/* a mutableArray to write diaries*/
@property(nonatomic,retain)NSMutableArray *diaries;

/* database*/
@property (retain) FMDatabase *dataBase;

@end
