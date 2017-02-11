//
//  ElementViewController.m
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "ElementViewController.h"

@interface ElementViewController () <UITableViewDelegate,UITableViewDataSource,NotePageUpdateDelegate>

@property (nonatomic,strong) NSMutableArray *monthInTable;

@property (nonatomic,strong) NSMutableArray *monthDetail;

@property (nonatomic,strong) UITableView *elementShowTableView;

@property (nonatomic,strong) UILabel *titleLabel;

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

@implementation ElementViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self themeSetting];

    _elementShowTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _deviceScreenSize.width,_deviceScreenSize.height - 140) style:UITableViewStyleGrouped];
    _elementShowTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [_elementShowTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_elementShowTableView];
    UIImage *backImage=[UIImage imageNamed:@"background1"];
    _elementShowTableView.layer.contents=(id)backImage.CGImage;
    _elementShowTableView.layer.backgroundColor=[UIColor clearColor].CGColor;
    [_elementShowTableView setDelegate:self];
    [_elementShowTableView setDataSource:self];
    
    self.bl = [[NoteBL alloc] init];
    self.listData = [self.bl findAll];
    
    [self groupByMonth];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
//主题设置
-(void)themeSetting {
    //主题颜色
    UIColor *blueThemeColor = [UIColor colorWithRed:107/255.0 green:183/255.0 blue:219/255.0 alpha:1];
    //UIColor *redThemeColor = [UIColor colorWithRed:246/255.0 green:120/255.0 blue:138/255.0 alpha:1];
    _themeColor = blueThemeColor;
    //控件大小设置
    _deviceScreenSize = [UIScreen mainScreen].bounds.size;
}

-(void)groupByMonth{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //UITableView分组
    int selctedMonth = 0;
    int numberPerMonth = 1;
    NSInteger temp1, temp2;
    _monthInTable = [[NSMutableArray alloc]init];
    _monthDetail = [[NSMutableArray alloc]init];
    //数据排序防止不同月份来回添加导致的section分组错误, 升序排列，时间早的靠前。
    NSArray *sortData = [_listData copy];
    sortData = [sortData sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Note *dic1 = (Note*)obj1;
        Note *dic2 = (Note*)obj2;
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
        
        return date11 > date22;
    }];
    [_listData removeAllObjects];
    _listData = [sortData mutableCopy];

    if([_listData count] > 1){
        
        for(int i = 0; i < [_listData count] - 1; i++){
            
            Note *note1 = _listData[i];
            Note *note2 = _listData[i + 1];
            NSString *strDateOfNote1 = [dateFormatter stringFromDate:note1.date];
            NSString *strDateOfNote2 = [dateFormatter stringFromDate:note2.date];
            temp1 = [[strDateOfNote1 substringWithRange:NSMakeRange(5, 2)]intValue];
            temp2 = [[strDateOfNote2 substringWithRange:NSMakeRange(5, 2)]intValue];
            
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
        
        Note *note = _listData[0];
        NSString *strDateOfNote = [dateFormatter stringFromDate:note.date];
        temp1 = [[strDateOfNote substringWithRange:NSMakeRange(5, 2)]intValue];
        NSNumber *number = [NSNumber numberWithInt:numberPerMonth];
        NSNumber *month = [NSNumber numberWithInteger:temp1];
        [_monthInTable insertObject:number atIndex:0];
        [_monthDetail insertObject:month atIndex:0];
    }
    else if ([_listData count] == 0){
        
        NSNumber *number=[NSNumber numberWithInt:0];
        [_monthInTable insertObject:number atIndex:0];
        [_monthDetail insertObject:number atIndex:0];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}
//设置Section标题
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *collectionTitle = [[UIView alloc] init];
    collectionTitle.backgroundColor = [UIColor clearColor];
    UILabel *collectionTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 30)];
    if ([_monthInTable count] >= 1){
        for (int i = 0; i < [_monthInTable count]; i++)
            if (section == i){
                
                NSNumber *monthIndexTemp = [_monthDetail objectAtIndex:i];
                NSInteger monthIndex = [monthIndexTemp integerValue];
                NSMutableArray *titleSet=[NSMutableArray arrayWithObjects:@"无项目", @"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月",nil];
                collectionTitleLable.text = [titleSet objectAtIndex:monthIndex];
            }
    }
    [collectionTitleLable setTextColor:[UIColor whiteColor]];
    [collectionTitleLable setFont:[UIFont fontWithName:@"Futura" size:22]];
    [collectionTitle addSubview:collectionTitleLable];
    
    return collectionTitle;
}
//分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    [self groupByMonth];
    return [_monthInTable count];
}
//获取section中cell数
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
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
//自定义cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *indetifier = @"key";
    UITableViewCell *baseTableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    if(!baseTableViewCell)
        baseTableViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
    Note *noteData = _listData[indexPath.row];
    //_cellView设置
    _cellView=[[UIView alloc]init];
    [_cellView setFrame:CGRectMake(15, 10, _deviceScreenSize.width-30, 80)];
    [_cellView.layer setCornerRadius:10];
    [_cellView setBackgroundColor:[UIColor whiteColor]];
    [baseTableViewCell.contentView addSubview:_cellView];
    //标题显示
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 22.5, _deviceScreenSize.width - 120, 40)];
    [_titleLabel setTextColor:_themeColor];
    [_titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_titleLabel setNumberOfLines:0];
    [_titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [_titleLabel setText:noteData.title];
    [_titleLabel setTag: indexPath.row];
    [_cellView addSubview:_titleLabel];
    //位置显示
    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 65, _deviceScreenSize.width - 120, 10)];
    [_locationLabel setTextColor:_themeColor];
    [_locationLabel setFont:[UIFont systemFontOfSize:12]];
    [_locationLabel setNumberOfLines:0];
    [_locationLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [_locationLabel setText:noteData.location];
    [_locationLabel setTag: indexPath.row];
    [_cellView addSubview:_locationLabel];
    //显示时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _time = [dateFormatter stringFromDate:noteData.date];
    _hour = [[_time substringWithRange:NSMakeRange(11, 2)]intValue];
    _minute = [[_time substringWithRange:NSMakeRange(14,2)]intValue];
    _year = [[_time substringWithRange:NSMakeRange(0,4)]intValue];
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 200, 10)];
    if(_minute >= 0 && _minute <= 9)
        [_timeLabel setText:[NSString stringWithFormat:@"%d:0%d %d",_hour,_minute,_year]];
    else
        [_timeLabel setText:[NSString stringWithFormat:@"%d:%d %d",_hour,_minute,_year]];
    [_timeLabel setTextColor:_themeColor];
    [_timeLabel setFont:[UIFont systemFontOfSize:12]];
    [_cellView addSubview:_timeLabel];
    //右侧底色
    _maskLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 80)];
    [_maskLabel setBackgroundColor:_themeColor];
    _maskLabel.layer.masksToBounds = YES;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_maskLabel.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: (CGSize){10, 10}].CGPath;
    _maskLabel.layer.mask = maskLayer;
    [_cellView addSubview:_maskLabel];
    //日期显示
    _date = [[_time substringWithRange:NSMakeRange(8, 2)]intValue];
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
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
    [_weekLabel setFrame:CGRectMake(0, 50, 60, 20)];
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
    
    return 100;
}
//创建
- (void)note{
    
    NoteEditViewController *createVC = [[NoteEditViewController alloc]init];
    createVC.noteDelegate = self;
    [self.navigationController pushViewController:createVC animated:YES];
}
//编辑
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoteEditViewController *editVC = [[NoteEditViewController alloc]init];
    editVC.noteDelegate = self;
    editVC.currentPage = _listData[indexPath.row];
    [self.navigationController pushViewController:editVC animated:YES];
}
//删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        Note *noteTemp = _listData[indexPath.row];
        NoteBL *bl = [[NoteBL alloc]init];
        self.listData = [bl removeNote:noteTemp];
        [_elementShowTableView reloadData];
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"Delete";
}
//更新TableView
-(void)updateTheNoteList{
    
    _listData = [self.bl findAll];
    [_elementShowTableView reloadData];
}

@end

