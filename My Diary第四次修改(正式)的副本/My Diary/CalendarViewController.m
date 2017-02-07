//
//  CalendarViewController.m
//  My Diary
//
//  Created by 徐贤达 on 2017/1/15.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import "CalendarViewController.h"
#import "BXCalendar.h"
#import "SqlService.h"
#import "NotePage.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

@synthesize noteListArray;
@synthesize dataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataArray=[[NSMutableArray alloc]init];
    _noteListTableView=[[UITableView alloc]init];
    _noteListTableView.backgroundColor=[UIColor clearColor];
    _noteListTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _noteListTableView.delegate = self;
    _noteListTableView.dataSource = self;
    
//初始化selectedDate为今天
    [self initSelectedDate];
    [self updateTheNoteList];
    [self.view addSubview:_noteListTableView];
    NSLog(@"cao");
    
    UIColor *background=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bluesky.jpg"]];
    self.view.backgroundColor=background;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    BXCalendar *calendar = [[BXCalendar alloc] initWithCurrentDate:[NSDate date]];
    CGRect frame = calendar.frame;
    frame.origin.y = 0;
    calendar.frame = frame;
    fuckFrame=frame;
     _noteListTableView.frame=CGRectMake(0, frame.origin.y+frame.size.height+10, frame.size.width,deviceHeight*78/100-frame.size.height-10);
    [self.view addSubview:calendar];
    
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
    NSLog(@"fuck");
    }
    k=17;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void) time:(BXCalendar *)calendar timeTrans:(NSString*)timeString
{
    _stringTime=timeString;
    NSLog(@"shide:%@",_stringTime);
    [self updateSelectedDate];
}

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
    NSLog(@"被选中:%ld,%ld,%ld",selectedYear,selectedMonth,selectedDay);
    [self updateTheNoteList];
}

-(void) updateDataArray
{
    dataArray=[[NSMutableArray alloc]init];
    NSInteger year;
    NSInteger month;
    NSInteger day;
    NSString *time;
    NSInteger i=0;
    if ([noteListArray count]!=0)
    {
        for (i=1;i<=[noteListArray count];i++)
        {
            NotePage *page=noteListArray[i-1];
            time=page.time;
            year=[[time substringWithRange:NSMakeRange(0, 4)]integerValue];
            month=[[time substringWithRange:NSMakeRange(5, 2)]integerValue];
            day=[[time substringWithRange:NSMakeRange(8, 2)]integerValue];
            NSLog(@"%ld年%ld月%ld日",year,month,day);
            if (year==selectedYear&&month==selectedMonth&&day==selectedDay)
          {
                [dataArray insertObject:page atIndex:i-1];
                NSLog(@"+1");
          }
            NSLog(@"%ld",[dataArray count]);
        }
    }
    NSLog(@"reload");
    [self update];
}

-(void)update
{
    NSLog(@"update");
    self.noteListTableView.delegate=self;
    self.noteListTableView.dataSource=self;
    [self.noteListTableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_noteListTableView reloadData];
    });
}

-(void)updateTheNoteList
{
    NSLog(@"queryDBtable");
    noteListArray = [[SqlService sqlInstance] queryDBtable];
    NSLog(@"Notelist:%ld",[noteListArray count]);
    [self updateDataArray];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"section");
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"new:%ld行",[dataArray count]);
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
    
    NSString *colorname =@"0x69D7DD";
    long colorLong = strtoul([colorname cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    int R = (colorLong & 0xFF0000 )>>16;
    int G = (colorLong & 0x00FF00 )>>8;
    int B =  colorLong & 0x0000FF;
    UIColor *themecolor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    //显示标题
    _titleLabel=[[UILabel alloc]init];
    _titleLabel.frame=CGRectMake(100, 37.5, 200, 15);
    _titleLabel.font=[UIFont systemFontOfSize:20];
    _cellTitle=[[NSString alloc]init];
    NSInteger length;
    length=notePage.titile.length;
    if(length>=9)
    {
        _cellTitle=[notePage.titile substringWithRange:NSMakeRange(0,9)];
        _titleLabel.text=_cellTitle;
    }
    else
    {
        _titleLabel.text=notePage.titile;
    }
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
