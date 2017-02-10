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

- (UILabel *)dayLabel{
    if (!dayLabel) {
        dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.font = [UIFont systemFontOfSize:14];
        [dayLabel.layer setCornerRadius:10];
        [dayLabel.layer setMasksToBounds:YES];
        dayLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 );
        [self addSubview:dayLabel];
    }
    return dayLabel;
}

@end

typedef NS_ENUM(NSInteger, CalendarMonth){
    MonthPrevious = 0,
    MonthCurrent = 1,
    MonthNext = 2,
};

@interface CalendarItems () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation CalendarItems

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupCollectionView];
        [self setFrame:CGRectMake(0, 0, DeviceWidth, self.collectionView.frame.size.height +10)];
    }
    return self;
}

#pragma mark - Custom Accessors

- (void)setDate:(NSDate *)date {
    _date = date;
    [self.collectionView reloadData];
}

#pragma mark - Public

// 获取date的下个月 日期
- (NSDate *)nextMonthDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    NSDate *nextMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self.date options:NSCalendarMatchStrictly];
    return nextMonthDate;
}

// 获取date的上个月日期
- (NSDate *)previousMonthDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    NSDate *previousMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self.date options:NSCalendarMatchStrictly];
    return previousMonthDate;
}

#pragma mark - Private

// collectionView显示日期单元，设置其属性
- (void)setupCollectionView {

    UICollectionViewFlowLayout *flowLayot = [[UICollectionViewFlowLayout alloc] init];
    flowLayot.sectionInset = UIEdgeInsetsZero;
    flowLayot.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 80) / 7, ([UIScreen mainScreen].bounds.size.width - 80) / 7);
    flowLayot.minimumLineSpacing = 0;
    flowLayot.minimumInteritemSpacing = 0;
    
    CGRect collectionViewFrame = CGRectMake(30, 20, DeviceWidth - 60, ([UIScreen mainScreen].bounds.size.width - 80) / 7 * 5);
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayot];
    [self addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
}

// 获取date当前月的第一天是星期几
- (NSInteger)weekdayOfFirstDayInDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
    [components setDay:1];
    NSDate *firstDate = [calendar dateFromComponents:components];
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday fromDate:firstDate];
    return firstComponents.weekday - 1;
}

// 获取date当前月的总天数
- (NSInteger)totalDaysInMonthOBXate:(NSDate *)date
{
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

// 获取某月day的日期
- (NSDate *)dateOfMonth:(CalendarMonth)calendarMonth WithDay:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date;
    
    switch (calendarMonth) {
        case MonthPrevious:
            date = [self previousMonthDate];
            break;
            
        case MonthCurrent:
            date = self.date;
            break;
            
        case MonthNext:
            date = [self nextMonthDate];
            break;
        default:
            break;
    }
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [components setDay:day];
    NSDate *dateOBXay = [calendar dateFromComponents:components];
    return dateOBXay;
}


#pragma mark - UICollectionDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = [UIColor colorWithRed:107/255.0 green:183/255.0 blue:219/255.0 alpha:1];
    NSString *identifier = @"CalendarCell";
    CalendarCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.dayLabel.textColor = [UIColor colorWithRed:109/255.0 green:122/255.0 blue:163/255.0 alpha:1];
    NSInteger firstWeekday = [self weekdayOfFirstDayInDate];
    NSInteger totalDaysOfMonth = [self totalDaysInMonthOBXate:self.date];
    NSInteger totalDaysOfLastMonth = [self totalDaysInMonthOBXate:[self previousMonthDate]];
    
    if (indexPath.row < firstWeekday)
    {    // 小于这个月的第一天
        NSInteger day = totalDaysOfLastMonth - firstWeekday + indexPath.row + 1;
        cell.dayLabel.text = [NSString stringWithFormat:@"%ld", day];
        cell.dayLabel.textColor = [UIColor lightGrayColor];
    }
    else if (indexPath.row >= totalDaysOfMonth + firstWeekday)
    {    // 大于这个月的最后一天
        NSInteger day = indexPath.row - totalDaysOfMonth - firstWeekday + 1;
        cell.dayLabel.text = [NSString stringWithFormat:@"%ld", day];
        cell.dayLabel.textColor = [UIColor lightGrayColor];
    }
    else
    {    // 属于这个月
        NSInteger day = indexPath.row - firstWeekday + 1;
        cell.dayLabel.text= [NSString stringWithFormat:@"%ld", day];
        //选中的那一天被圈起来显示
        if (day == [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:self.date]){
            
            //[cell.dayLabel setBackgroundColor:color];
            cell.backgroundColor = color;
            cell.layer.cornerRadius = cell.frame.size.height / 2;
            cell.dayLabel.textColor = [UIColor whiteColor];
        }
        
        // 如果日期和当期日期同年同月不同天, 注：第一个判断中的方法是iOS8的新API, 会比较传入单元以及比传入单元大得单元上数据是否相等，亲测同时传入Year和Month结果错误
        if ([[NSCalendar currentCalendar] isDate:[NSDate date] equalToDate:self.date toUnitGranularity:NSCalendarUnitMonth] && ![[NSCalendar currentCalendar] isDateInToday:self.date]) {
            
            // 将当前日期的那天高亮显示
            if (day == [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:[NSDate date]]) {
                cell.dayLabel.textColor = [UIColor redColor];
            }
        }
        
    }
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
    NSInteger firstWeekday = [self weekdayOfFirstDayInDate];
    [components setDay:indexPath.row - firstWeekday+1];
    NSDate *selectedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarItem:didSelectedDate:)]) {
        [self.delegate calendarItem:self didSelectedDate:selectedDate];
    }
}


@end
