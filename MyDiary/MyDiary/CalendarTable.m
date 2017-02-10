//
//  CalendarTable.m
//  MyDiary
//
//  Created by tinoryj on 2017/2/10.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "CalendarTable.h"
#import "CalendarItems.h"
#import "CalendarViewController.h"

@interface CalendarTable () <UIScrollViewDelegate, CalendarItemsDelegate>

@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) CalendarItems *lastMonthItem;
@property (strong, nonatomic) CalendarItems *theMonthItem;
@property (strong, nonatomic) CalendarItems *nextMonthItem;

@property (strong, nonatomic) UIView *backgroundView;

@property (strong, nonatomic) UILabel *titleLable;

@end

@implementation CalendarTable
//初始化日历
- (instancetype)initWithCurrentDate:(NSDate *)date{
    
    if (self = [super init]){
        
        _backgroundView = [[UIView alloc]init];
        [_backgroundView setBackgroundColor:[UIColor whiteColor]];
        [_backgroundView.layer setCornerRadius:15];
        [self addSubview:_backgroundView];
        self.date = date;
        [self setupTitleBar];
        [self setupWeekHeader];
        [self setupCalendarItems];
        [self setupScrollView];
        [self setFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, CGRectGetMaxY(self.scrollView.frame))];
        [_backgroundView setFrame:CGRectMake(15, 15, [UIScreen mainScreen].bounds.size.width - 30, CGRectGetMaxY(self.scrollView.frame))];
        [self setCurrentDate:self.date];
    }
    return self;
}
//日历标题时间格式变化
- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormattor = [[NSDateFormatter alloc] init];
    [dateFormattor setDateFormat:@"MM-yyyy"];
    return [dateFormattor stringFromDate:date];
}
// 设置上层的titleBar
- (void)setupTitleBar{
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width-40,30)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:titleView];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(titleView.frame.size.width-90, 5, 20, 15)];
    [leftButton setImage:[UIImage imageNamed:@"preButton"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setPreviousMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(titleView.frame.size.width - 40, 5, 20, 15)];
    [rightButton setImage:[UIImage imageNamed:@"nextButton"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(setNextMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:rightButton];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 30)];
    [titleLable setTextColor:[UIColor colorWithRed:109/255.0 green:122/255.0 blue:163/255.0 alpha:1]];
    [titleLable setFont:[UIFont systemFontOfSize:18]];
    [titleLable setBackgroundColor:[UIColor clearColor]];
    [titleLable setTextAlignment:NSTextAlignmentLeft];
    [titleView addSubview:titleLable];
    self.titleLable = titleLable;
}
//设置“星期几”文字显示
- (void)setupWeekHeader{
    
    NSArray *weekDays = [[NSArray alloc]initWithObjects:@"S", @"M", @"T", @"W", @"T", @"F", @"S", nil];
    CGFloat offset = 30;
    for (int i = 0; i < 7; i++) {
        
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 60, ([UIScreen mainScreen].bounds.size.width - 60) / 7, 15)];
        [weekdayLabel setTextAlignment:NSTextAlignmentCenter];
        [weekdayLabel setFont:[UIFont fontWithName:@"Times new roman" size:16]];
        [weekdayLabel setText:weekDays[i]];
        [weekdayLabel setTextColor:[UIColor colorWithRed:181/255.0 green:188/255.0 blue:194/255.0 alpha:1]];
        [self addSubview:weekdayLabel];
        offset += weekdayLabel.frame.size.width;
    }
}
//设置scrollView
- (void)setupScrollView{
    
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, self.theMonthItem.frame.size.height + 10)];
    [self.scrollView setContentSize:CGSizeMake(3 * self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
    [self addSubview:self.scrollView];
}
//初始化日历scrollView显示
- (void)setupCalendarItems{
    
    self.scrollView = [[UIScrollView alloc] init];
    
    self.lastMonthItem = [[CalendarItems alloc] init];
    [self.scrollView addSubview:self.lastMonthItem];
    
    CGRect preViewFrame = self.lastMonthItem.frame;
    preViewFrame.origin.x = [UIScreen mainScreen].bounds.size.width;
    self.theMonthItem = [[CalendarItems alloc] init];
    [self.theMonthItem setFrame:preViewFrame];
    [self.theMonthItem setDelegate:self];
    [self.scrollView addSubview:self.theMonthItem];
    
    preViewFrame.origin.x = [UIScreen mainScreen].bounds.size.width * 2;
    self.nextMonthItem = [[CalendarItems alloc] init];
    [self.nextMonthItem setFrame:preViewFrame];
    [self.scrollView addSubview:self.nextMonthItem];
}
//设置当前日期
- (void)setCurrentDate:(NSDate *)date{
    
    self.theMonthItem.date = date;
    self.lastMonthItem.date = [self.theMonthItem previousMonthDate];
    self.nextMonthItem.date = [self.theMonthItem nextMonthDate];
    NSString *dateShow = [self stringFromDate:date];
    NSInteger month = [[dateShow substringWithRange:NSMakeRange(0, 2)]integerValue];
    NSInteger year = [[dateShow substringWithRange:NSMakeRange(3, 4)]integerValue];
    NSArray *monthTable = [[NSArray alloc]initWithObjects:@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月", nil];
    NSString *finalShow = [[NSString alloc]init];
    finalShow = [NSString stringWithFormat:@"%@  %ld年",monthTable[month-1],year];
    [self.titleLable setText:finalShow];
}
//重载日历数据
- (void)reloadCalendarItems{
    
    CGPoint offset = self.scrollView.contentOffset;
    if(offset.x > self.scrollView.frame.size.width){
        
        [self setNextMonthDate];
    }
    else{
        
        [self setPreviousMonthDate];
    }
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
}
//上翻一个月
- (void)setPreviousMonthDate{
    
    [self setCurrentDate:[self.theMonthItem previousMonthDate]];
}
//下翻一个月
- (void)setNextMonthDate{

    [self setCurrentDate:[self.theMonthItem nextMonthDate]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self reloadCalendarItems];
}

- (void)calendarItem:(CalendarItems *)item didSelectedDate:(NSDate *)date {
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self setCurrentDate:date];
    NSString *timeString=[formatter stringFromDate:date];
    [self.selectedDelegate selectedUpdate:timeString];
}

@end
