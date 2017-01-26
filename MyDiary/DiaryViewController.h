//
//  DiaryViewController.h
//  MyDiary
//
//  Created by Wujianyun on 18/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaryViewController : UIViewController
@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong)NSArray * diaryListArray;
@property (nonatomic,strong)NSMutableArray <__kindof NSArray *> * diaryForMonthArray;


@end
