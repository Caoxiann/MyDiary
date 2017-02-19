//
//  BXMainPage.h
//  My Diary
//
//  Created by 徐贤达 on 2017/1/15.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElementsViewController.h"
#import "CalendarViewController.h"
#import "DiaryViewController.h"
#import "BXElements.h"

#define deviceWidth [UIScreen mainScreen].bounds.size.width
#define deviceHeight [UIScreen mainScreen].bounds.size.height

@interface BXMainPage : UIViewController
{
    NSInteger update;
    NSInteger numbers;
    NSInteger subNumbers;
    BOOL page1;
}

@property (nonatomic,strong) BXElements *elements;

@property (nonatomic,strong) CalendarViewController *calendar;

@property (nonatomic,strong) DiaryViewController *diary;

@property (nonatomic,strong) UIViewController *currentVC;

@property (nonatomic,retain) UILabel *label;

@property (nonatomic,strong) UILabel *rightLabel;

@property (nonatomic,strong) UISegmentedControl *mainSegmentControl;

@end
