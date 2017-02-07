//
//  BXCalendarItem.m
//  BXCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "BXCalendarItem.h"

@interface BXCalendarCell : UICollectionViewCell

- (UILabel *)dayLabel;
- (UILabel *)chineseDayLabel;

@end

@implementation BXCalendarCell {
    UILabel *_dayLabel;
    UILabel *_chineseDayLabel;
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont systemFontOfSize:12];
        _dayLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 - 10);
        [self addSubview:_dayLabel];
    }
    return _dayLabel;
}

- (UILabel *)chineseDayLabel {
    if (!_chineseDayLabel) {
        _chineseDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
        _chineseDayLabel.textAlignment = NSTextAlignmentCenter;
        _chineseDayLabel.font = [UIFont boldSystemFontOfSize:9];
        
        CGPoint point = _dayLabel.center;
        point.y += 15;
        _chineseDayLabel.center = point;
        [self addSubview:_chineseDayLabel];
    }
    return _chineseDayLabel;
}

@end

#define CollectionViewHorizonMargin 5
#define CollectionViewVerticalMargin 5

#define ChineseMonths @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月"]
#define ChineseDays @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"]

typedef NS_ENUM(NSUInteger, BXCalendarMonth) {
    BXCalendarMonthPrevious = 0,
    BXCalendarMonthCurrent = 1,
    BXCalendarMonthNext = 2,
};

@interface BXCalendarItem () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation BXCalendarItem

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupCollectionView];
        [self setFrame:CGRectMake(0, 0, DeviceWidth, self.collectionView.frame.size.height + CollectionViewVerticalMargin * 2)];
    }
    return self;
}

#pragma mark - Custom Accessors

- (void)setDate:(NSDate *)date {
    _date = date;
    [self.collectionView reloadData];
}

#pragma mark - Public 

// 获取date的下个月日期
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
    CGFloat itemWidth = (DeviceWidth - CollectionViewHorizonMargin * 2) / 7;
    CGFloat itemHeight = itemWidth-10;
    
    UICollectionViewFlowLayout *flowLayot = [[UICollectionViewFlowLayout alloc] init];
    flowLayot.sectionInset = UIEdgeInsetsZero;
    flowLayot.itemSize = CGSizeMake(itemWidth, itemHeight);
    flowLayot.minimumLineSpacing = 0;
    flowLayot.minimumInteritemSpacing = 0;
    
    CGRect collectionViewFrame = CGRectMake(CollectionViewHorizonMargin, CollectionViewVerticalMargin, DeviceWidth - CollectionViewHorizonMargin * 2, itemHeight * 6);
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayot];
    [self addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[BXCalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
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
- (NSDate *)dateOfMonth:(BXCalendarMonth)calendarMonth WithDay:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date;
    
    switch (calendarMonth) {
        case BXCalendarMonthPrevious:
            date = [self previousMonthDate];
            break;
            
        case BXCalendarMonthCurrent:
            date = self.date;
            break;
            
        case BXCalendarMonthNext:
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

// 获取date当天的农历
- (NSString *)chineseCalendarOBXate:(NSDate *)date
{
    NSString *day;
    NSCalendar *chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *components = [chineseCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    if (components.day == 1) {
        day = ChineseMonths[components.month - 1];
    } else {
        day = ChineseDays[components.day - 1];
    }

    return day;
}

#pragma mark - UICollectionDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *colorname =@"0x69D7DD";
    long colorLong = strtoul([colorname cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    int R = (colorLong & 0xFF0000 )>>16;
    int G = (colorLong & 0x00FF00 )>>8;
    int B =  colorLong & 0x0000FF;
    UIColor *color = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    
    static NSString *identifier = @"CalendarCell";
    BXCalendarCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.dayLabel.textColor = [UIColor blackColor];
    cell.chineseDayLabel.textColor = [UIColor grayColor];
    NSInteger firstWeekday = [self weekdayOfFirstDayInDate];
    NSInteger totalDaysOfMonth = [self totalDaysInMonthOBXate:self.date];
    NSInteger totalDaysOfLastMonth = [self totalDaysInMonthOBXate:[self previousMonthDate]];
    
    if (indexPath.row < firstWeekday)
    {    // 小于这个月的第一天
        NSInteger day = totalDaysOfLastMonth - firstWeekday + indexPath.row + 1;
        cell.dayLabel.text = [NSString stringWithFormat:@"%ld", day];
        cell.dayLabel.textColor = [UIColor grayColor];
        cell.chineseDayLabel.text = [self chineseCalendarOBXate:[self dateOfMonth:BXCalendarMonthPrevious WithDay:day]];
    }
    else if (indexPath.row >= totalDaysOfMonth + firstWeekday)
    {    // 大于这个月的最后一天
        NSInteger day = indexPath.row - totalDaysOfMonth - firstWeekday + 1;
        cell.dayLabel.text = [NSString stringWithFormat:@"%ld", day];
        cell.dayLabel.textColor = [UIColor grayColor];
        cell.chineseDayLabel.text = [self chineseCalendarOBXate:[self dateOfMonth:BXCalendarMonthNext WithDay:day]];
    }
    else
    {    // 属于这个月
        NSInteger day = indexPath.row - firstWeekday + 1;
        cell.dayLabel.text= [NSString stringWithFormat:@"%ld", day];
        
        //选中的那一天被圈起来显示
        if (day == [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:self.date])
        {
            cell.backgroundColor = color;
            cell.layer.cornerRadius = cell.frame.size.height / 2;
            cell.dayLabel.textColor = [UIColor whiteColor];
            cell.chineseDayLabel.textColor = [UIColor whiteColor];
        }
        
        // 如果日期和当期日期同年同月不同天, 注：第一个判断中的方法是iOS8的新API, 会比较传入单元以及比传入单元大得单元上数据是否相等，亲测同时传入Year和Month结果错误
        if ([[NSCalendar currentCalendar] isDate:[NSDate date] equalToDate:self.date toUnitGranularity:NSCalendarUnitMonth] && ![[NSCalendar currentCalendar] isDateInToday:self.date]) {
            
            // 将当前日期的那天高亮显示
            if (day == [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:[NSDate date]]) {
                cell.dayLabel.textColor = [UIColor redColor];
            }
        }
        
        cell.chineseDayLabel.text = [self chineseCalendarOBXate:[self dateOfMonth:BXCalendarMonthCurrent WithDay:day]];
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
