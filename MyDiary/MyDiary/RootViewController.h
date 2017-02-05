//
//  ViewController.h
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Diary.h"
#import "DiaryBL.h"

#import "ElementViewController.h"
#import "DiaryViewController.h"
#import "CalendarViewController.h"
#import "EditViewController.h"

@interface ViewController : UIViewController
{
    NSInteger itemNumber;
}

@property (nonatomic,strong) ElementViewController* elementVC;

@property (nonatomic,strong) CalenderViewController* calendarVC;

@property (nonatomic,strong) DiaryViewController *diaryVC;

@property (nonatomic,strong) UIViewController *currentVC;


//主题颜色
@property (nonatomic,strong) UIColor *themeColor;



//保存数据列表
@property (nonatomic,strong) NSMutableArray* listData;
//保存数据列表
@property (nonatomic,strong) DiaryBL* bl;

-(void)themeSetting;

@end

