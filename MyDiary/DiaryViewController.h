//
//  DiaryViewController.h
//  MyDiary
//
//  Created by Wujianyun on 18/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary.h"
@protocol DiaryPageDelegate <NSObject>

@required -(void)turnToDiaryPage:(Diary *)diary;

@end
@interface DiaryViewController : UIViewController
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray <__kindof NSMutableArray *> * cellHeights;
@property (nonatomic,strong) NSMutableArray <__kindof NSMutableArray *> *diaryForMonthArray;
@property (nonatomic,strong) NSMutableArray *monthArr;
@property (nonatomic,strong) UIViewController <DiaryPageDelegate> *delegate;
@property (nonatomic,assign) CGFloat tableViewHeight;


@end
