//
//  ElementViewController.h
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "NoteBL.h"
#import "NoteEditViewController.h"

@interface ElementViewController : UIViewController


-(void)charactersButtonAction;

@property (nonatomic) CGSize deviceScreenSize;

@property (nonatomic,strong) UIColor *themeColor;
//保存数据列表
@property (nonatomic,strong) NSMutableArray* listData;

@property (nonatomic,strong) NoteBL* bl;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *locationLabel;

@property (nonatomic,strong) UILabel *weekLabel;

@property (nonatomic,strong) UIView *cellView;

@property (nonatomic,strong) UILabel *dateLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *maskLabel;

@property (nonatomic,strong) NSString *time;


@property int year, month, date, hour, minute, weekDay;

@end
