//
//  DiaryViewController.h
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "DiaryViewController.h"

@interface DiaryViewController () <UITableViewDelegate,UITableViewDataSource,DiaryPageUpdateDelegate>

@property (nonatomic,strong) NSMutableArray *monthInTable;

@property (nonatomic,strong) NSMutableArray *monthDetail;

@property (nonatomic,strong) UITableView *diaryShowTableView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) UILabel *locationLabel;

@property (nonatomic,strong) UILabel *weekLabel;

@property (nonatomic,strong) UIView *cellView;

@property (nonatomic,strong) UILabel *dateLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *maskLabel;

@property (nonatomic,strong) NSString *time;

@property (nonatomic) CGSize deviceScreenSize;

@property (nonatomic,strong) UIColor *themeColor;

@property int year, month, date, hour, minute, weekDay;


@end

@implementation DiaryViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self themeSetting];
    
    _diaryShowTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _deviceScreenSize.width,_deviceScreenSize.height - 140) style:UITableViewStyleGrouped];
    [_diaryShowTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_diaryShowTableView];
    UIImage *backImage=[UIImage imageNamed:@"background1"];
    _diaryShowTableView.layer.contents=(id)backImage.CGImage;
    _diaryShowTableView.layer.backgroundColor=[UIColor clearColor].CGColor;
    [_diaryShowTableView setDelegate:self];
    [_diaryShowTableView setDataSource:self];
    
    self.bl = [[DiaryBL alloc] init];
    
    self.listData = [self.bl findAll];
    [self groupByMonth];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}
//主题设置
- (void)themeSetting{
    //主题颜色
    UIColor *blueThemeColor = [UIColor colorWithRed:107/255.0 green:183/255.0 blue:219/255.0 alpha:1];
    //UIColor *redThemeColor = [UIColor colorWithRed:246/255.0 green:120/255.0 blue:138/255.0 alpha:1];
    _themeColor = blueThemeColor;
    //控件大小设置
    _deviceScreenSize = [UIScreen mainScreen].bounds.size;
}

- (void)groupByMonth{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //UITableView分组
    int selctedMonth = 0;
    int numberPerMonth = 1;
    NSInteger temp1, temp2;
    _monthInTable = [[NSMutableArray alloc]init];
    _monthDetail = [[NSMutableArray alloc]init];
    //数据排序防止不同月份来回添加导致的section分组错误，时间晚近显示越靠前（最近的日记靠前）
    NSArray *sortData = [_listData copy];
    sortData = [sortData sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Diary *dic1 = (Diary*)obj1;
        Diary *dic2 = (Diary*)obj2;
        NSString *date1 = [dateFormatter stringFromDate:dic1.date];
        NSString *date2 = [dateFormatter stringFromDate:dic2.date];
        long year1 = [[date1 substringWithRange:NSMakeRange(0, 4)]intValue];
        long month1 = [[date1 substringWithRange:NSMakeRange(5, 2)]intValue];
        long day1 = [[date1 substringWithRange:NSMakeRange(8, 2)]intValue];
        long hour1 = [[date1 substringWithRange:NSMakeRange(11, 2)]intValue];
        long min1 = [[date1 substringWithRange:NSMakeRange(14, 2)]intValue];
        long date11 = year1*1000000000 + month1*10000000 +day1*100000 + hour1*60 + min1;
        long year2 = [[date2 substringWithRange:NSMakeRange(0, 4)]intValue];
        long month2 = [[date2 substringWithRange:NSMakeRange(5, 2)]intValue];
        long day2 = [[date2 substringWithRange:NSMakeRange(8, 2)]intValue];
        long hour2 = [[date2 substringWithRange:NSMakeRange(11, 2)]intValue];
        long min2 = [[date2 substringWithRange:NSMakeRange(14, 2)]intValue];
        long date22 = year2*1000000000 + month2*10000000 +day2*100000 + hour2*60 + min2;
        return date11 < date22;
    }];
    [_listData removeAllObjects];
    _listData = [sortData mutableCopy];
    
    if([_listData count] > 1){
        
        for(int i = 0; i < [_listData count] - 1; i++){
            
            Diary *diary1 = _listData[i];
            Diary *diary2 = _listData[i + 1];
            NSString *strDateOfDiary1 = [dateFormatter stringFromDate:diary1.date];
            NSString *strDateOfDiary2 = [dateFormatter stringFromDate:diary2.date];
            temp1 = [[strDateOfDiary1 substringWithRange:NSMakeRange(5, 2)]intValue];
            temp2 = [[strDateOfDiary2 substringWithRange:NSMakeRange(5, 2)]intValue];
            
            if(temp1 == temp2 && i != [_listData count] - 2)
                numberPerMonth++;
            else if(temp1 == temp2 && i == [_listData count] - 2){
                
                numberPerMonth++;
                NSNumber *number = [NSNumber numberWithInt:numberPerMonth];
                NSNumber *month = [NSNumber numberWithInteger:temp1];
                [_monthInTable insertObject:number atIndex:selctedMonth];
                [_monthDetail insertObject:month atIndex:selctedMonth];
                selctedMonth++;
            }
            else if(temp1 != temp2 && i != [_listData count] - 2){
                
                NSNumber *number = [NSNumber numberWithInt:numberPerMonth];
                NSNumber *month = [NSNumber numberWithInteger:temp1];
                [_monthInTable insertObject:number atIndex:selctedMonth];
                [_monthDetail insertObject:month atIndex:selctedMonth];
                numberPerMonth = 1;
                selctedMonth++;
            }
            else if(temp1 != temp2 && i == [_listData count] - 2){
                
                NSNumber *number = [NSNumber numberWithInt:numberPerMonth];
                NSNumber *month = [NSNumber numberWithInteger:temp1];
                [_monthInTable insertObject:number atIndex:selctedMonth];
                [_monthDetail insertObject:month atIndex:selctedMonth];
                selctedMonth++;
                numberPerMonth = 1;
                NSNumber *snumber = [NSNumber numberWithInt:numberPerMonth];
                NSNumber *smonth = [NSNumber numberWithInteger:temp2];
                [_monthInTable insertObject:snumber atIndex:selctedMonth];
                [_monthDetail insertObject:smonth atIndex:selctedMonth];
                selctedMonth++;
            }
        }
    }
    else if([_listData count] == 1){
        
        Diary *diary = _listData[0];
        NSString *strDateOfDiary = [dateFormatter stringFromDate:diary.date];
        temp1 = [[strDateOfDiary substringWithRange:NSMakeRange(5, 2)]intValue];
        NSNumber *number = [NSNumber numberWithInt:numberPerMonth];
        NSNumber *month = [NSNumber numberWithInteger:temp1];
        [_monthInTable insertObject:number atIndex:0];
        [_monthDetail insertObject:month atIndex:0];
    }
    else if ([_listData count] == 0){
        
        NSNumber *number=[NSNumber numberWithInteger:0];
        [_monthInTable insertObject:number atIndex:0];
        [_monthDetail insertObject:number atIndex:0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}
//设置Section标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *collectionTitle = [[UIView alloc] init];
    collectionTitle.backgroundColor = [UIColor clearColor];
    UILabel *collectionTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 30)];
    if ([_monthInTable count] >= 1){
        for (int i = 0; i < [_monthInTable count]; i++)
            if (section == i){
                
                NSNumber *monthIndexTemp = [_monthDetail objectAtIndex:i];
                NSInteger monthIndex = [monthIndexTemp integerValue];
                NSMutableArray *titleSet=[NSMutableArray arrayWithObjects:@"无日记", @"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月",nil];
                collectionTitleLable.text = [titleSet objectAtIndex:monthIndex];
            }
    }
    [collectionTitleLable setTextColor:[UIColor whiteColor]];
    [collectionTitleLable setFont:[UIFont fontWithName:@"Futura" size:22]];
    [collectionTitle addSubview:collectionTitleLable];
    
    return collectionTitle;
}

//分组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    [self groupByMonth];
    return [_monthInTable count];
}
//获取cell数
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    [self groupByMonth];
    if([_monthInTable count] != 0){
        
        NSInteger totalSection = [_monthInTable count];
        for(int i = 0; i < totalSection; i++)
            if(section == i){
                
                NSNumber *numbers;
                numbers = [_monthInTable objectAtIndex:i];
                return [numbers intValue];
            }
    }
    return 0;
}

//自定义cell风格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *indetifier = @"key";
    UITableViewCell *baseTableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    if(!baseTableViewCell)
        baseTableViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
    Diary *diaryData = _listData[indexPath.row];
    
    _cellView=[[UIView alloc]init];
    [_cellView.layer setCornerRadius:10];
    [_cellView setBackgroundColor:[UIColor whiteColor]];
    [baseTableViewCell.contentView addSubview:_cellView];
    //顶部底色
    _maskLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _deviceScreenSize.width - 30, 60)];
    [_maskLabel setBackgroundColor:_themeColor];
    _maskLabel.layer.masksToBounds = YES;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_maskLabel.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){10, 10}].CGPath;
    _maskLabel.layer.mask = maskLayer;
    [_cellView addSubview:_maskLabel];
    //标题显示
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 20, _deviceScreenSize.width - 120, 20)];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    _titleLabel.font = [UIFont systemFontOfSize:22];
    [_titleLabel setNumberOfLines:0];
    [_titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [_titleLabel setText:diaryData.title];
    [_titleLabel setTag: indexPath.row];
    [_cellView addSubview:_titleLabel];
    //内容显示
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, _deviceScreenSize.width - 50, 10)];
    [_contentLabel setTextColor:_themeColor];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    [_contentLabel setNumberOfLines:0];
    [_contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [_contentLabel setText:diaryData.content];
    [_contentLabel setTag: indexPath.row];
    //iOS7之后方法：
    CGSize autoContentSize = {0, 0};    //初始autoSize
    CGSize size = CGSizeMake(_deviceScreenSize.width - 60, 160); //autoSize最大限制
    NSDictionary * contentFontDic = [NSDictionary dictionaryWithObjectsAndKeys:_contentLabel.font,NSFontAttributeName,nil];
    autoContentSize = [diaryData.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:contentFontDic context:nil].size;
    [_contentLabel setFrame:CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, autoContentSize.height)];
    /*iOS7以前方法；
    CGSize labelSize = {0,0};
    labelSize = [diaryData.content sizeWithFont:[UIFont systemFontOfSize:14]
                              constrainedToSize:CGSizeMake(_deviceScreenSize.width - 60, 160)
                                  lineBreakMode:UILineBreakModeWordWrap];
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, labelSize.height);//保持原来Label的位置和宽度，只是改变高度。
     */
    [_cellView addSubview:_contentLabel];
    //_cellView设置
    NSInteger tag = _contentLabel.frame.size.height;
    [_cellView setFrame:CGRectMake(15, 10, _deviceScreenSize.width-30, tag + 80)];
    //位置显示
    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 45, _deviceScreenSize.width - 120, 10)];
    [_locationLabel setTextColor:[UIColor whiteColor]];
    [_locationLabel setFont:[UIFont systemFontOfSize:12]];
    [_locationLabel setNumberOfLines:0];
    [_locationLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [_locationLabel setText:diaryData.location];
    [_locationLabel setTag: indexPath.row];
    [_cellView addSubview:_locationLabel];
    //显示时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _time = [dateFormatter stringFromDate:diaryData.date];
    _hour = [[_time substringWithRange:NSMakeRange(11, 2)]intValue];
    _minute = [[_time substringWithRange:NSMakeRange(14,2)]intValue];
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 200, 10)];
    if(_minute >= 0 && _minute <= 9)
        [_timeLabel setText:[NSString stringWithFormat:@"%d:0%d",_hour,_minute]];
    else
        [_timeLabel setText:[NSString stringWithFormat:@"%d:%d",_hour,_minute]];
    [_timeLabel setTextColor:[UIColor whiteColor]];
    [_timeLabel setFont:[UIFont systemFontOfSize:12]];
    [_cellView addSubview:_timeLabel];
    //日期显示
    _date = [[_time substringWithRange:NSMakeRange(8, 2)]intValue];
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [_dateLabel setText:[NSString stringWithFormat:@"%d",_date]];
    [_dateLabel setTextAlignment:NSTextAlignmentCenter];
    [_dateLabel setFont:[UIFont systemFontOfSize:35]];
    [_dateLabel setTextColor:[UIColor whiteColor]];
    [_dateLabel setBackgroundColor:[UIColor clearColor]];
    [_cellView addSubview:_dateLabel];
    //星期显示
    _year = [[_time substringWithRange:NSMakeRange(0, 4)]intValue];
    _month = [[_time substringWithRange:NSMakeRange(5, 2)]intValue];
    if (_month ==1 || _month == 2){
        
        _month += 12;
        _year--;
    }
    _weekDay = (_date + 2 * _month + 3 * (_month + 1) / 5 + _year + _year / 4 - _year / 100 + _year / 400) % 7;
    NSMutableArray *weekDaySet=[NSMutableArray arrayWithObjects:@"日曜日", @"月曜日", @"火曜日", @"水曜日", @"木曜日", @"金曜日", @"土曜日", @"何曜日", nil];
    _weekLabel = [[UILabel alloc]init];
    [_weekLabel setFrame:CGRectMake(0, 40, 60, 20)];
    [_weekLabel setText:[weekDaySet objectAtIndex:_weekDay - 1]];
    [_weekLabel setFont:[UIFont systemFontOfSize:12]];
    [_weekLabel setTextAlignment:NSTextAlignmentCenter];
    [_weekLabel setBackgroundColor:[UIColor clearColor]];
    [_weekLabel setTextColor:[UIColor whiteColor]];
    [_cellView addSubview:_weekLabel];
    
    [baseTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [baseTableViewCell setBackgroundColor:[UIColor clearColor]];
    
    return baseTableViewCell;
}
//设置cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据内容多少动态调整，上下clear间距各10
    return _contentLabel.frame.size.height + 100;
}
//创建
- (void)diary{
    
    DiaryEditViewController *createVC = [[DiaryEditViewController alloc]init];
    createVC.diaryDelegate = self;
    [self.navigationController pushViewController:createVC animated:YES];
}
//编辑
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiaryEditViewController *editVC = [[DiaryEditViewController alloc]init];
    editVC.diaryDelegate = self;
    editVC.currentPage = _listData[indexPath.row];
    [self.navigationController pushViewController:editVC animated:YES];
}
//删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        Diary *diaryTemp = _listData[indexPath.row];
        DiaryBL *bl = [[DiaryBL alloc]init];
        self.listData = [bl removeDiary:diaryTemp];
        [_diaryShowTableView reloadData];
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"Delete";
}
//更新TableView
- (void)updateTheDiaryList{
    
    _listData = [self.bl findAll];
    [_diaryShowTableView reloadData];
}

@end
