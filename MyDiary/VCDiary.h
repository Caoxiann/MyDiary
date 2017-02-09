//
//  VCDiary.h
//  MyDiary
//
//  Created by Jimmy Fan on 2017/1/22.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCDiary : UIViewController

<UITableViewDelegate,
UITableViewDataSource>
    
{
    UITableView* _tableView;
    NSMutableArray* _arrayMonth;
    NSMutableArray* _arrayDay;
    NSMutableArray* _arrayWeek;
    NSMutableArray* _arrayTitle;
    NSMutableArray* _arrayContent;
    NSMutableArray* _arrayID;
    UISegmentedControl* _segControl;
    FMDatabase* _mDB;
    NSInteger total;
    UIBarButtonItem* btn01;
    UIBarButtonItem* btn02;
    UIBarButtonItem* btn03;
    UIBarButtonItem* btn04;
    UIBarButtonItem* btn05;
    UIBarButtonItem* btnF01;
    UIBarButtonItem* btnF02;
    UIToolbar* _toolbar;
}

@end
