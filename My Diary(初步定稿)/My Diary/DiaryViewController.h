//
//  DiaryViewController.h
//  My Diary
//
//  Created by 徐贤达 on 2017/1/15.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import <UIKit/UIKit.h>

#define deviceWidth [UIScreen mainScreen].bounds.size.width
#define deviceHeight [UIScreen mainScreen].bounds.size.height

@protocol diaryUpdateDelegate <NSObject>

-(void)updateTheNote;

@end


@interface DiaryViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,diaryUpdateDelegate>

@property (nonatomic,strong)UITableView *noteListTableView;

@property (nonatomic,strong)NSArray *noteListArray;

@property (nonatomic,strong)NSMutableArray *textArray;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) UIView *cellView;

@property (nonatomic,strong) UIView *cellTopView;

@property (nonatomic,strong) UILabel *dateLabel;

@property (nonatomic,strong) UILabel *yearLabel;

@property (nonatomic,strong) UILabel *hourLabel;

@property (nonatomic,strong) NSString *time;

@property (nonatomic,strong) NSString *cellTitle;

@property int date;

@property int hour;

@property int minute;

@property int year;

@property int month;

@property CGSize size;


@end
