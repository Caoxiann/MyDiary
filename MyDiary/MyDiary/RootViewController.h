//
//  ViewController.h
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElementViewController.h"
#import "DiaryViewController.h"
#import "CalendarViewController.h"
#import "NoteEditViewController.h"
#import "DiaryEditViewController.h"
@interface ViewController : UIViewController

@property (nonatomic,strong) ElementViewController *elementVC;

@property (nonatomic,strong) CalendarViewController* calendarVC;

@property (nonatomic,strong) DiaryViewController *diaryVC;

@end

