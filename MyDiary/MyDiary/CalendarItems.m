//
//  CalendarItems.m
//  MyDiary
//
//  Created by tinoryj on 2017/2/10.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "CalendarItems.h"

@interface CalendarCell : UICollectionViewCell

- (UILabel*)dayLabel;

@end

@implementation CalendarCell{
    
    UILabel *dayLabel;
}
//创建日期显示lable
- (UILabel *)dayLabel{
    
    if(!dayLabel){
        
        dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [dayLabel setTextAlignment:NSTextAlignmentCenter];
        [dayLabel setFont:[UIFont systemFontOfSize:14]];
        [dayLabel.layer setCornerRadius:10];
        [dayLabel.layer setMasksToBounds:YES];
        dayLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 );
        [self addSubview:dayLabel];
    }
    return dayLabel;
}

@end

@interface CalendarItems () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation CalendarItems

- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setupCollectionView];
        [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.collectionView.frame.size.height +10)];
    }
    return self;
}

- (void)setDate:(NSDate *)date {
    
    _date = date;
    [self.collectionView reloadData];
}
// 获取date的下个月 日期
- (NSDate *)nextMonthDate {
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    NSDate *nextMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.date options:NSCalendarMatchStrictly];
    return nextMonthDate;
}
// 获取date的上个月日期
- (NSDate *)previousMonthDate {
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *previousMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.date options:NSCalendarMatchStrictly];
    return previousMonthDate;
}
//collectionView显示日期单元 设置其属性
- (void)setupCollectionView {

    UICollectionViewFlowLayout *flowLayot = [[UICollectionViewFlowLayout alloc] init];
    [flowLayot setSectionInset:UIEdgeInsetsZero];
    [flowLayot setItemSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - 80) / 7, ([UIScreen mainScreen].bounds.size.width - 80) / 7)];
    [flowLayot setMinimumLineSpacing:0];
    [flowLayot setMinimumInteritemSpacing:0];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 20, [UIScreen mainScreen].bounds.size.width - 60, ([UIScreen mainScreen].bounds.size.width - 80) / 7 * 5) collectionViewLayout:flowLayot];
    [self addSubview:self.collectionView];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
}

//当前月的第一天是星期几
- (NSInteger)weekdayOfFirstDayInDate{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
    [dateComponents setDay:1];
    NSDate *firstDate = [calendar dateFromComponents:dateComponents];
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday fromDate:firstDate];
    return firstComponents.weekday - 1;
}
//获取当前月的总天数
- (NSInteger)totalDaysInMonthOBXate:(NSDate *)date{
    
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}
//获取某月某天的日期
typedef NS_ENUM(NSInteger, CalendarMonth){
    monthPrevious = 0,
    monthCurrent = 1,
    monthNext = 2
};

- (NSDate *)dateOfMonth:(CalendarMonth)calendarMonth WithDay:(NSInteger)day{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date;
    
    switch (calendarMonth) {
        case monthPrevious:
            date = [self previousMonthDate];
            break;
            
        case monthCurrent:
            date = self.date;
            break;
            
        case monthNext:
            date = [self nextMonthDate];
            break;
        default:
            break;
    }
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [dateComponents setDay:day];
    NSDate *dateFind = [calendar dateFromComponents:dateComponents];
    return dateFind;
}
//每组日期数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 42;
}
//日期显示处理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *identifier = @"CalendarCell";
    CalendarCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.dayLabel setTextColor:[UIColor colorWithRed:109/255.0 green:122/255.0 blue:163/255.0 alpha:1]];
    NSInteger firstWeekday = [self weekdayOfFirstDayInDate];
    NSInteger totalDaysOfMonth = [self totalDaysInMonthOBXate:self.date];
    NSInteger totalDaysOfLastMonth = [self totalDaysInMonthOBXate:[self previousMonthDate]];
    
    if (indexPath.row < firstWeekday){
        //属于上一月
        NSInteger day = totalDaysOfLastMonth - firstWeekday + indexPath.row + 1;
        [cell.dayLabel setText:[NSString stringWithFormat:@"%ld", day]];
        [cell.dayLabel setTextColor:[UIColor lightGrayColor]];
    }
    else if (indexPath.row >= totalDaysOfMonth + firstWeekday){
        //属于下一月
        NSInteger day = indexPath.row - totalDaysOfMonth - firstWeekday + 1;
        [cell.dayLabel setText:[NSString stringWithFormat:@"%ld", day]];
        [cell.dayLabel setTextColor:[UIColor lightGrayColor]];
    }
    else{
        //日期属于当前月
        NSInteger day = indexPath.row - firstWeekday + 1;
        [cell.dayLabel setText:[NSString stringWithFormat:@"%ld", day]];
        //选中状态
        if (day == [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:self.date]){

            [cell setBackgroundColor:[UIColor colorWithRed:107/255.0 green:183/255.0 blue:219/255.0 alpha:1]];
            [cell.layer setCornerRadius:cell.frame.size.height / 2];
            [cell.dayLabel setTextColor:[UIColor whiteColor]];
        }
        //当前日期红色
        if ([[NSCalendar currentCalendar] isDate:[NSDate date] equalToDate:self.date toUnitGranularity:NSCalendarUnitMonth] && ![[NSCalendar currentCalendar] isDateInToday:self.date]) {
            
            if (day == [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:[NSDate date]]) {
                
                [cell.dayLabel setTextColor:[UIColor redColor]];
            }
        }
    }
    return cell;
}
//UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
    NSInteger firstWeekday = [self weekdayOfFirstDayInDate];
    [dateComponents setDay:indexPath.row - firstWeekday+1];
    NSDate *selectedDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarItem:didSelectedDate:)]) {
        
        [self.delegate calendarItem:self didSelectedDate:selectedDate];
    }
}

@end
