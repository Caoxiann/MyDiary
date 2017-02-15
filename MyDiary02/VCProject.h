//
//  VCProject.h
//  MyDiary02
//
//  Created by 向尉 on 2017/1/20.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "ViewController.h"
#import "VCProjectWrite.h"


@interface VCProject : ViewController
<UITableViewDelegate,UITableViewDataSource,VCProjectWriteDelegate>

/* a tableView to show projects*/
@property(nonatomic,retain)UITableView *tableView;

/* a button to delete selected projects in tableView when is under the edit state*/
@property(nonatomic,retain)UIBarButtonItem *deleteBtn;

/* a button to commit edit state*/
@property(nonatomic,retain)UIBarButtonItem *finishBtn;

/* a array to keep projects*/
@property(nonatomic)NSMutableArray *projects;
@end
