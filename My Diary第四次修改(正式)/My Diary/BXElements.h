//
//  BXElements.h
//  My Diary
//
//  Created by 徐贤达 on 2017/2/2.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import <UIKit/UIKit.h>

#define deviceWidth [UIScreen mainScreen].bounds.size.width
#define deviceHeight [UIScreen mainScreen].bounds.size.height


@interface BXElements : UIViewController

-(void)rightButtonAction;

-(NSInteger)getNumberOfActivities;

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

@interface  HomeNavigationController: UINavigationController

@end

