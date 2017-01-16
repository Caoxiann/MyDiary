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

@interface BXMainPage : UIViewController
{
    int numbers;
}

@property (nonatomic,strong) ElementsViewController *elements;

@property (nonatomic,strong) CalendarViewController *calendar;

@property (nonatomic,strong) DiaryViewController *diary;

@property (nonatomic,strong) UIViewController *currentVC;

@property (nonatomic,retain) UILabel *label;



@end
