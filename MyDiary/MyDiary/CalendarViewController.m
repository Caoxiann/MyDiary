//
//  CalenderViewController.m
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarTable.h"
#import "CalendarItems.h"

@interface CalendarViewController () <UITableViewDelegate,UITableViewDataSource,selectedUpdate>

@property (nonatomic,strong)CalendarTable *calendar;

@end

@implementation CalendarViewController

@synthesize calendar;


- (void)viewDidLoad{
    [super viewDidLoad];
    [self themeSetting];
    _bl = [[NoteBL alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _noteListArray = [[NSMutableArray alloc]init];
    //初始化selectedDate为今天
    [self initSelectedDate];
    [self.view addSubview:_noteListTableView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1"]]];
    [self updateList];
}

-(instancetype)init{
    
    self=[super init];
    if (self){
        

        calendar = [[CalendarTable alloc] initWithCurrentDate:[NSDate date]];
        calendar.selectedDelegate=self;
        CGRect frame = calendar.frame;
        frame.origin.y = 0;
        [calendar setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 30)];
        initFrame=frame;
        _noteListTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height- 140) style:UITableViewStylePlain];
        _noteListTableView.backgroundColor=[UIColor clearColor];
        [_noteListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _noteListTableView.tableHeaderView = calendar;
        UIImage *backImage=[UIImage imageNamed:@"background1"];
        [_noteListTableView.layer setContents:(id)backImage.CGImage];
        [_noteListTableView.layer setBackgroundColor:(__bridge CGColorRef _Nullable)([UIColor clearColor])];
        _noteListTableView.delegate = self;
        _noteListTableView.dataSource = self;
        [_noteListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return self;
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

- (void)initSelectedDate{
    if (k != 1){
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateTime = [formatter stringFromDate:[[NSDate alloc]init]];
        selectedYear = [[dateTime substringWithRange:NSMakeRange(0, 4)]integerValue];
        selectedMonth = [[dateTime substringWithRange:NSMakeRange(5, 2)]integerValue];
        selectedDay = [[dateTime substringWithRange:NSMakeRange(8, 2)]integerValue];
    }
    k = 1;
}

//自定义cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *indetifier = @"key";
    UITableViewCell *baseTableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    if(!baseTableViewCell)
        baseTableViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
    Note *noteData = _dataArray[indexPath.row];
    
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
    UILabel *_locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 65, _deviceScreenSize.width - 120, 10)];
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
    NSString *timeShow = [dateFormatter stringFromDate:noteData.date];
    int hourShow = [[timeShow substringWithRange:NSMakeRange(11, 2)]intValue];
    int minuteShow = [[timeShow substringWithRange:NSMakeRange(14,2)]intValue];
    UILabel  *_timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 200, 10)];
    if(_minute >= 0 && _minute <= 9)
        [_timeLabel setText:[NSString stringWithFormat:@"%d:0%d",hourShow,minuteShow]];
    else
        [_timeLabel setText:[NSString stringWithFormat:@"%d:%d",hourShow,minuteShow]];
    [_timeLabel setTextColor:_themeColor];
    [_timeLabel setFont:[UIFont systemFontOfSize:12]];
    [_cellView addSubview:_timeLabel];
    
    //右侧底色
    UILabel *_maskLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 80)];
    [_maskLabel setBackgroundColor:_themeColor];
    _maskLabel.layer.masksToBounds = YES;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_maskLabel.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: (CGSize){10, 10}].CGPath;
    _maskLabel.layer.mask = maskLayer;
    [_cellView addSubview:_maskLabel];
    
    //日期显示
    NSInteger dateShow = [[timeShow substringWithRange:NSMakeRange(8, 2)]intValue];
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [_dateLabel setText:[NSString stringWithFormat:@"%ld",dateShow]];
    [_dateLabel setTextAlignment:NSTextAlignmentCenter];
    [_dateLabel setFont:[UIFont systemFontOfSize:35]];
    [_dateLabel setTextColor:[UIColor whiteColor]];
    [_dateLabel setBackgroundColor:[UIColor clearColor]];
    [_cellView addSubview:_dateLabel];
    
    //星期显示
    
    int yearShow = [[_time substringWithRange:NSMakeRange(0, 4)]intValue];
    int monthShow = [[_time substringWithRange:NSMakeRange(5, 2)]intValue];
    if (monthShow ==1 || monthShow == 2){
        
        monthShow += 12;
        yearShow--;
    }
    int weekDayShow = (dateShow + 2 * monthShow + 3 * (monthShow + 1) / 5 + yearShow + yearShow / 4 - yearShow / 100 + yearShow / 400) % 7;
    NSMutableArray *weekDaySet=[NSMutableArray arrayWithObjects:@"日曜日", @"月曜日", @"火曜日", @"水曜日", @"木曜日", @"金曜日", @"土曜日", @"何曜日", nil];
    UILabel *_weekLabel = [[UILabel alloc]init];
    [_weekLabel setFrame:CGRectMake(0, 50, 60, 20)];
    [_weekLabel setText:[weekDaySet objectAtIndex:weekDayShow - 1]];
    [_weekLabel setFont:[UIFont systemFontOfSize:12]];
    [_weekLabel setTextAlignment:NSTextAlignmentCenter];
    [_weekLabel setBackgroundColor:[UIColor clearColor]];
    [_weekLabel setTextColor:[UIColor whiteColor]];
    [_cellView addSubview:_weekLabel];
    
    [baseTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [baseTableViewCell setBackgroundColor:[UIColor clearColor]];
    
    return baseTableViewCell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

//传入选中的那一天
-(void)selectedUpdate:(NSString*)string{
    
    _stringTime = string;
    [self updateSelectedDate];
}

//更新选中天数
-(void) updateSelectedDate{
    
    NSInteger year;
    NSInteger month;
    NSInteger day;
    year = [[_stringTime substringWithRange:NSMakeRange(0, 4)]integerValue];
    month = [[_stringTime substringWithRange:NSMakeRange(5, 2)]integerValue];
    day = [[_stringTime substringWithRange:NSMakeRange(8, 2)]integerValue];
    selectedYear=year;
    selectedMonth=month;
    selectedDay=day;
    [self updateList];
}

//更新tabelview
-(void) updateDataArray{

    _noteListArray = [self.bl findAll];
    [_dataArray removeAllObjects];
    NSInteger year;
    NSInteger month;
    NSInteger day;
    NSString *time;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if ([_noteListArray count] != 0){
        
        for (int i = 0; i <= [_noteListArray count] - 1; i++){
            
            Note *page=_noteListArray[i];
            time = [dateFormatter stringFromDate:page.date];
            year=[[time substringWithRange:NSMakeRange(0, 4)]integerValue];
            month=[[time substringWithRange:NSMakeRange(5, 2)]integerValue];
            day=[[time substringWithRange:NSMakeRange(8, 2)]integerValue];
            if (year == selectedYear && month == selectedMonth && day == selectedDay){
                
                [_dataArray addObject:page];
            }
        }
    }
    [self update];
}

//tableview刷新数据
-(void)update{
    
    [self.noteListTableView setDelegate:self];
    [self.noteListTableView setDataSource:self];
    [self.noteListTableView reloadData];
}
//从本地更新数据
- (void)updateList{
    
    [self updateDataArray];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
