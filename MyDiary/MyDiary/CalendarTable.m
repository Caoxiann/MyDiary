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

#define Weekdays @[@"S", @"M", @"T", @"W", @"T", @"F", @"S"]

static NSDateFormatter *dateFormattor;

@interface CalendarTable () <UIScrollViewDelegate, CalendarItemsDelegate>

@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) UILabel *titleLable;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) CalendarItems *lastMonthItem;
@property (strong, nonatomic) CalendarItems *theMonthItem;
@property (strong, nonatomic) CalendarItems *nextMonthItem;
@property (strong, nonatomic) UIView *backgroundView;

@end
@implementation CalendarTable
- (instancetype)initWithCurrentDate:(NSDate *)date
{
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
        [self setFrame:CGRectMake(0, 10, DeviceWidth, CGRectGetMaxY(self.scrollView.frame))];
        [_backgroundView setFrame:CGRectMake(15, 15, [UIScreen mainScreen].bounds.size.width - 30, CGRectGetMaxY(self.scrollView.frame))];
        [self setCurrentDate:self.date];
    }
    return self;
}


#pragma mark - Private

- (NSString *)stringFromDate:(NSDate *)date
{
    if (!dateFormattor)
    {
        dateFormattor = [[NSDateFormatter alloc] init];
        [dateFormattor setDateFormat:@"MM-yyyy"];
    }
    
    return [dateFormattor stringFromDate:date];
}

// 设置上层的titleBar
- (void)setupTitleBar
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, DeviceWidth-40,30)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:titleView];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(titleView.frame.size.width-90, 5, 20, 20)];
    [leftButton setImage:[UIImage imageNamed:@"preButton"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setPreviousMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(titleView.frame.size.width - 40, 5, 20, 20)];
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

// 设置星期文字的显示
- (void)setupWeekHeader
{
    CGFloat offsetX = 30;
    for (int i = 0; i < 7; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 60, (DeviceWidth - 60) / 7, 15)];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.font=[UIFont systemFontOfSize:16];
        weekdayLabel.text = Weekdays[i];
        weekdayLabel.textColor = [UIColor colorWithRed:181/255.0 green:188/255.0 blue:194/255.0 alpha:1];
        [self addSubview:weekdayLabel];
        offsetX += weekdayLabel.frame.size.width;
    }
}

// 设置包含日历的item的scrollView
- (void)setupScrollView{
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView setFrame:CGRectMake(0, 60, DeviceWidth, self.theMonthItem.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(3 * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    [self addSubview:self.scrollView];
}

// 设置3个日历的item
- (void)setupCalendarItems
{
    self.scrollView = [[UIScrollView alloc] init];
    
    self.lastMonthItem = [[CalendarItems alloc] init];
    [self.scrollView addSubview:self.lastMonthItem];
    
    CGRect itemFrame = self.lastMonthItem.frame;
    itemFrame.origin.x = DeviceWidth;
    self.theMonthItem = [[CalendarItems alloc] init];
    self.theMonthItem.frame = itemFrame;
    self.theMonthItem.delegate = self;
    [self.scrollView addSubview:self.theMonthItem];
    
    itemFrame.origin.x = DeviceWidth * 2;
    self.nextMonthItem = [[CalendarItems alloc] init];
    self.nextMonthItem.frame = itemFrame;
    [self.scrollView addSubview:self.nextMonthItem];
}

// 设置当前日期，初始化
- (void)setCurrentDate:(NSDate *)date
{
    self.theMonthItem.date = date;
    self.lastMonthItem.date = [self.theMonthItem previousMonthDate];
    self.nextMonthItem.date = [self.theMonthItem nextMonthDate];
    NSString *dateShow = [self stringFromDate:date];
    NSInteger month = [[dateShow substringWithRange:NSMakeRange(0, 2)]integerValue];
    NSInteger year = [[dateShow substringWithRange:NSMakeRange(3, 4)]integerValue];
    NSArray *monthTable = [[NSArray alloc]initWithObjects:@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月", nil];
    NSString *finalShow = [[NSString alloc]init];
    finalShow = [NSString stringWithFormat:@"%@  %ld年",monthTable[month-1],year];
    //NSLog(@"%ld %ld",(long)month,(long)year);
    [self.titleLable setText:finalShow];
}

// 重新加载日历items的数据
- (void)reloadCalendarItems
{
    CGPoint offset = self.scrollView.contentOffset;
    
    if (offset.x == self.scrollView.frame.size.width) { //防止滑动一点点并不切换scrollview的视图
        return;
    }
    
    if (offset.x > self.scrollView.frame.size.width) {
        [self setNextMonthDate];
    } else {
        [self setPreviousMonthDate];
    }
    
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
}

#pragma mark - SEL

// 跳到上一个月
- (void)setPreviousMonthDate
{
    [self setCurrentDate:[self.theMonthItem previousMonthDate]];
}

// 跳到下一个月
- (void)setNextMonthDate{

    [self setCurrentDate:[self.theMonthItem nextMonthDate]];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self reloadCalendarItems];
}

#pragma mark - CalendarItemsDelegate

- (void)calendarItem:(CalendarItems *)item didSelectedDate:(NSDate *)date {
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self setCurrentDate:date];
    NSString *timeString=[formatter stringFromDate:date];
    [self.selectedDelegate selectedUpdate:timeString];
}

@end
