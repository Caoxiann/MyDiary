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
#import "Note.h"
#import "NoteBL.h"


#import "ElementViewController.h"
#import "DiaryViewController.h"
#import "CalendarViewController.h"
#import "NoteCreateViewController.h"
#import "DiaryCreateViewController.h"
@interface ViewController : UIViewController
{
    NSInteger itemNumber;
}

@property (nonatomic,strong) ElementViewController *elementVC;

@property (nonatomic,strong) CalendarViewController* calendarVC;

@property (nonatomic,strong) DiaryViewController *diaryVC;

@property (nonatomic,strong) UIViewController *currentVC;

@property (nonatomic,strong) NoteCreateViewController *noteCreateVC;

@property (nonatomic,strong) DiaryCreateViewController *diaryCreateVC;

@property (nonatomic) CGSize deviceScreenSize;

@property (nonatomic) CGRect buttonRect;


//主题颜色
@property (nonatomic,strong) UIColor *themeColor;

@property (nonatomic,retain) UILabel *titleLabel;

@property (nonatomic,retain) UILabel *itemShowLabel;

//保存数据列表
@property (nonatomic,strong) NSMutableArray* NoteListData;
@property (nonatomic,strong) NSMutableArray* DiaryListData;
//保存数据列表
@property (nonatomic,strong) NoteBL* noteBl;
@property (nonatomic,strong) DiaryBL* diaryBl;

-(void)themeSetting;

@end

