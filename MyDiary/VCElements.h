//
//  VCElements.h
//  MyDiary
//
//  Created by Jimmy Fan on 2017/1/22.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface VCElements : UIViewController
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
    NSMutableArray* _arrayMinute;
    NSMutableArray* _arraySubLocality;
    NSMutableArray* _arrayCity;
    UISegmentedControl* _segControl;
    FMDatabase* _mDB;
    UIBarButtonItem* btn01;
    UIBarButtonItem* btn02;
    UIBarButtonItem* btn03;
    UIBarButtonItem* btn04;
    UIBarButtonItem* btn05;
    UIBarButtonItem* btnF01;
    UIBarButtonItem* btnF02;
    UIToolbar* _toolbar;
    UILabel* _labelNull;
}

@end
