//
//  CalenderViewController.h
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "NoteBL.h"

@protocol selectedUpdate <NSObject>

-(void)selectedUpdate:(NSString*)string;

-(void)updateList;

@end

@interface CalendarViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,selectedUpdate> {
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    CGRect initFrame;
    int k;
}

-(void)updateList;

@property (nonatomic) CGSize deviceScreenSize;

@property (nonatomic,strong) UIColor *themeColor;

@property (nonatomic,strong)NSString *stringTime;

@property (nonatomic,strong)UITableView *noteListTableView;

@property (nonatomic,strong)NSMutableArray *noteListArray;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIView *cellView;

@property (nonatomic,strong) UILabel *dateLabel;

@property (nonatomic,strong) UILabel *hourLabel;

@property (nonatomic,strong) NSString *time;

@property (nonatomic,strong) NSString *cellTitle;

@property (nonatomic,strong) NoteBL *bl;

@property int date;

@property int hour;

@property int minute;


@end
