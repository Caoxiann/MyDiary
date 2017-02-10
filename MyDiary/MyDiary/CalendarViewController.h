//
//  CalenderViewController.h
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#ifndef CalenderViewController_h
#define CalenderViewController_h

#import <UIKit/UIKit.h>
#import "Note.h"
#import "NoteBL.h"

@protocol selectedUpdate <NSObject>

-(void)selectedUpdate:(NSString*)string;

@end

@interface CalendarViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,selectedUpdate>
{
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    CGRect initFrame;
    int k;
}

-(void)updateTheNoteList;

@property (nonatomic) CGSize deviceScreenSize;

@property (nonatomic,strong) UIColor *themeColor;

@property (nonatomic,strong)NSString *stringTime;

@property (nonatomic,strong)UITableView *noteListTableView;

@property (nonatomic,strong)NSArray *noteListArray;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIView *cellView;

@property (nonatomic,strong) UILabel *dateLabel;

@property (nonatomic,strong) UILabel *hourLabel;

@property (nonatomic,strong) NSString *time;

@property (nonatomic,strong) NSString *cellTitle;

@property int date;

@property int hour;

@property int minute;


@end

#endif /* CalenderViewController_h */
