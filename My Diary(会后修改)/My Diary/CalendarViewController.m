//
//  CalendarViewController.m
//  My Diary
//
//  Created by 徐贤达 on 2017/1/15.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import "CalendarViewController.h"
#import "SqlService.h"
#import "NotePage.h"
#import "BXCalendar.h"

@interface CalendarViewController ()

@property (nonatomic,strong)BXCalendar *calendar;

@end

@implementation CalendarViewController

@synthesize noteListArray;
@synthesize dataArray;
@synthesize calendar;

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        dataArray=[[NSMutableArray alloc]init];
        calendar = [[BXCalendar alloc] initWithCurrentDate:[NSDate date]];
        calendar.selectedDelegate=self;
        CGRect frame = calendar.frame;
        frame.origin.y = 0;
        calendar.frame = frame;
        fuckFrame=frame;
        
        _noteListTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, frame.origin.y+frame.size.height+10, frame.size.width,deviceHeight*78/100-frame.size.height-10)
                                                       style:UITableViewStylePlain];
        _noteListTableView.backgroundColor=[UIColor clearColor];
        _noteListTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        UIImage *backImage=[UIImage imageNamed:@"blueskytable.jpg"];
        _noteListTableView.layer.contents=(id)backImage.CGImage;
        _noteListTableView.layer.backgroundColor=[UIColor clearColor].CGColor;
        _noteListTableView.delegate = self;
        _noteListTableView.dataSource = self;
        [_noteListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//初始化selectedDate为今天
    [self initSelectedDate];
    [self updateTheNoteList];
    [self.view addSubview:_noteListTableView];
    [self.view addSubview:calendar];

    UIColor *background=[UIColor colorWithPatternImage:[UIImage imageNamed:@"blueskyfinal.jpg"]];
    self.view.backgroundColor=background;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)initSelectedDate
{
    if (k!=17)
    {
    NSDate *today=[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateTime = [formatter stringFromDate:today];
    selectedYear=[[dateTime substringWithRange:NSMakeRange(0, 4)]integerValue];
    selectedMonth=[[dateTime substringWithRange:NSMakeRange(5, 2)]integerValue];
    selectedDay=[[dateTime substringWithRange:NSMakeRange(8, 2)]integerValue];
    }
    k=17;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

//传入选中的那一天
-(void)selectedUpdate:(NSString*)string
{
    _stringTime=string;
    [self updateSelectedDate];
}

//更新选中天数
-(void) updateSelectedDate
{
    NSInteger year;
    NSInteger month;
    NSInteger day;
    year=[[_stringTime substringWithRange:NSMakeRange(0, 4)]integerValue];
    month=[[_stringTime substringWithRange:NSMakeRange(5, 2)]integerValue];
    day=[[_stringTime substringWithRange:NSMakeRange(8, 2)]integerValue];
    selectedYear=year;
    selectedMonth=month;
    selectedDay=day;
    [self updateTheNoteList];
}

//比较，更新tabelview的data库
-(void) updateDataArray
{
    dataArray=nil;
    dataArray=[[NSMutableArray alloc]init];
    NSInteger year;
    NSInteger month;
    NSInteger day;
    NSString *time;
    NSInteger i=0;
    if ([noteListArray count]!=0)
    {
    for (i=0;i<=[noteListArray count]-1;i++)
        {
            NotePage *page=noteListArray[i];
            time=page.time;
            year=[[time substringWithRange:NSMakeRange(0, 4)]integerValue];
            month=[[time substringWithRange:NSMakeRange(5, 2)]integerValue];
            day=[[time substringWithRange:NSMakeRange(8, 2)]integerValue];
            if (year==selectedYear&&month==selectedMonth&&day==selectedDay)
          {
                [dataArray addObject:page];
          }
        }
    }
    [self update];
}

//tableview刷新数据
-(void)update
{
    self.noteListTableView.delegate=self;
    self.noteListTableView.dataSource=self;
    [self.noteListTableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_noteListTableView reloadData];
    });
}

//从本地更新数据
-(void)updateTheNoteList
{
    NSLog(@"queryDBtable");
    noteListArray = [[SqlService sqlInstance] queryDBtable];
    [self updateDataArray];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetifier = @"cell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
    }
    
    NotePage *notePage = dataArray[indexPath.row];
    
    //大的UIView对象
    _cellView=[[UIView alloc]init];
    _cellView.frame=CGRectMake(20, 10, deviceWidth-40, 80);
    _cellView.layer.cornerRadius=10;
    _cellView.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:_cellView];
    
//    NSString *colorname =@"0x69D7DD";
//    long colorLong = strtoul([colorname cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
//    int R = (colorLong & 0xFF0000 )>>16;
//    int G = (colorLong & 0x00FF00 )>>8;
//    int B =  colorLong & 0x0000FF;
//    UIColor *themecolor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    
    UIColor *themecolor = [UIColor colorWithRed:107/255.0 green:183/255.0 blue:219/255.0 alpha:1];
    //显示标题
    _titleLabel=[[UILabel alloc]init];
    _titleLabel.frame=CGRectMake(100,37.5,deviceWidth-160, 15);
    _titleLabel.text=notePage.titile;
    _titleLabel.font=[UIFont systemFontOfSize:20];
    _titleLabel.numberOfLines=0;
    _titleLabel.tag=indexPath.row;
    _titleLabel.textColor=themecolor;
    [_cellView addSubview:_titleLabel];

    //显示时间
    _time=[[NSString alloc]init];
    _time=notePage.time;
    _date=[[_time substringWithRange:NSMakeRange(8, 2)]intValue];
    _hour=[[_time substringWithRange:NSMakeRange(11, 2)]intValue];
    _minute=[[_time substringWithRange:NSMakeRange(14,2)]intValue];
    
    _hourLabel=[[UILabel alloc]init];
    _hourLabel.frame=CGRectMake(100, 13, 200, 10);
    if(_minute>=0&&_minute<=9)
    {
        _hourLabel.text=[NSString stringWithFormat:@"%0d:0%d",_hour,_minute];
    }
    else
    {
        _hourLabel.text=[NSString stringWithFormat:@"%0d:%d",_hour,_minute];
    }
    _hourLabel.textColor=themecolor;
    _hourLabel.font=[UIFont systemFontOfSize:13];
    [_cellView addSubview:_hourLabel];
    
    _dateLabel=[[UILabel alloc]init];
    _dateLabel.frame=CGRectMake(0, 0, 80, 80);
    _dateLabel.text=[NSString stringWithFormat:@"%d",_date];
    _dateLabel.textAlignment=NSTextAlignmentCenter;
    _dateLabel.font=[UIFont systemFontOfSize:35];
    _dateLabel.textColor=[UIColor whiteColor];
    _dateLabel.backgroundColor=themecolor;
    _dateLabel.layer.masksToBounds = YES;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_dateLabel.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: (CGSize){10, 10}].CGPath;
    _dateLabel.layer.mask = maskLayer;
    [_cellView addSubview:_dateLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
