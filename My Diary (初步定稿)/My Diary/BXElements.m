//
//  BXElements.m
//  My Diary
//
//  Created by 徐贤达 on 2017/2/2.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import "BXElements.h"
#import "NotePageController.h"
#import "SqlService.h"
#import "TimeDealler.h"
#import "NotePage.h"
#import "NotePageUpdateDelegate.h"
#import "NotePageSearvice.h"

@interface BXElements ()<UITableViewDelegate,UITableViewDataSource,NotePageUpdateDelegate,backFirst,UISearchDisplayDelegate>

@property (nonatomic,strong)UITableView *noteListTableView;

@property (nonatomic,strong)NSArray *noteListArray;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)NSMutableArray *monthArray;

@property (nonatomic,strong)NSMutableArray *monthDetail;


@end

@implementation BXElements
@synthesize noteListArray;
@synthesize dataArray;

//初始化
-(id)init{
    self = [super init];
    if(self)
    {
        _update=0;
        [self setUpNavigationBar];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//还是把导航栏关掉吧
    self.navigationController.navigationBar.hidden=YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
//初始化TableView
    _noteListTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_noteListTableView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,deviceHeight*78/100)];
    _noteListTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_noteListTableView];
//Table背景
    UIImage *backImage=[UIImage imageNamed:@"loveSky.jpg"];
    _noteListTableView.layer.contents=(id)backImage.CGImage;
    _noteListTableView.layer.backgroundColor=[UIColor clearColor].CGColor;
//Table协议
    _noteListTableView.delegate = self;
    _noteListTableView.dataSource = self;
    noteListArray = [[SqlService sqlInstance] queryDBtable];
    dataArray = [[NSMutableArray alloc]initWithArray:noteListArray];
    [self updateMonth];
    [self setUpNavigationBar];
    [_noteListTableView reloadData];
    
}

-(NSInteger)backFirst
{
    _update++;
    return _update;
}

-(void)updateMonth
{
    //将所有的NotePage对象分类，便于UITableView分组
    int i;
    int j=0;
    int z=1;
    NSInteger month1;
    NSInteger month2;
    _monthArray=[[NSMutableArray alloc]init];
    _monthDetail=[[NSMutableArray alloc]init];
    if ([noteListArray count]>1)
    {
    for (i=0;i<[noteListArray count]-1;i++)
    {
        NotePage *page1=noteListArray[i];
        NotePage *page2=noteListArray[i+1];
        month1=[[page1.time substringWithRange:NSMakeRange(5, 2)]intValue];
        month2=[[page2.time substringWithRange:NSMakeRange(5, 2)]intValue];
        if (month1==month2&&i!=[noteListArray count]-2)
        {
            z++;
        }
        if (month1==month2&&i==[noteListArray count]-2)
        {
            z++;
            NSNumber *number=[NSNumber numberWithInt:z];
            NSNumber *month=[NSNumber numberWithInteger:month1];
            [_monthArray insertObject:number atIndex:j];
            [_monthDetail insertObject:month atIndex:j];
            j++;
        }
        if (month1!=month2&&i!=[noteListArray count]-2)
        {
            NSNumber *number=[NSNumber numberWithInt:z];
            NSNumber *month=[NSNumber numberWithInteger:month1];
            [_monthArray insertObject:number atIndex:j];
            [_monthDetail insertObject:month atIndex:j];
            z=1;
            j++;
        }
        if (month1!=month2&&i==[noteListArray count]-2)
        {
            NSNumber *number=[NSNumber numberWithInt:z];
            NSNumber *month=[NSNumber numberWithInteger:month1];
            [_monthArray insertObject:number atIndex:j];
            [_monthDetail insertObject:month atIndex:j];
            j++;
            z=1;
            NSNumber *snumber=[NSNumber numberWithInt:z];
            NSNumber *smonth=[NSNumber numberWithInteger:month2];
            [_monthArray insertObject:snumber atIndex:j];
            [_monthDetail insertObject:smonth atIndex:j];
            j++;
        }
    }
    }
    else if([noteListArray count]==1)
    {
        NotePage *page=noteListArray[0];
        month1=[[page.time substringWithRange:NSMakeRange(5, 2)]intValue];
        NSNumber *number=[NSNumber numberWithInt:z];
        NSNumber *month=[NSNumber numberWithInteger:month1];
        [_monthArray insertObject:number atIndex:0];
        [_monthDetail insertObject:month atIndex:0];
    }
    if ([noteListArray count]==0)
    {
        NSNumber *number=[NSNumber numberWithInt:0];
        [_monthArray insertObject:number atIndex:0];
        [_monthDetail insertObject:number atIndex:0];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

//设置头部标题
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor=[UIColor clearColor];
    UILabel *headerLabel=[[UILabel alloc]init];
    if ([_monthArray count]>=1)
    {
    for (int i=0;i<[_monthArray count];i++)
    {
        if (section==i)
        {
            NSNumber *mon=[_monthDetail objectAtIndex:i];
            NSInteger month=[mon integerValue];
            NSMutableArray *array=[NSMutableArray arrayWithObjects:@"空项目",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",nil];
            NSString *st=[array objectAtIndex:month];
            if (month!=0)
            {
                NSString *stringForMonth=[NSString stringWithFormat:@"%@ 月",st];
                headerLabel.text=stringForMonth;
            }
            if (month==0)
            {
                NSString *stringForMonth=[NSString stringWithFormat:@"%@",st];
                headerLabel.text=stringForMonth;

            }
        }
    }
    }
    headerLabel.frame=CGRectMake(15, 20, 80, 30);
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"Verdana-Bold" size:20];
    [header addSubview:headerLabel];
    return header;
}

//分成几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self updateMonth];
    return [_monthArray count];
}

//获取项目数
-(NSInteger)getNumberOfActivities
{
    return [noteListArray count];
}

//进入书写界面操作
-(void)rightButtonAction
{
    NotePageController *noteController = [[NotePageController alloc]init];
    noteController.noteDelegate = self;
    noteController.backFirst=self;
    [self.navigationController pushViewController:noteController animated:YES];
}

//设置导航栏
-(void)setUpNavigationBar
{
    self.navigationController.navigationBar.translucent=YES;
    self.navigationController.navigationBar.barStyle=UIBarStyleDefault;
}

//获取行数
#pragma mark -tableViewdelegate
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self updateMonth];
    if ([_monthArray count]!=0)
    {
    NSInteger totalSection=[_monthArray count];
    for(int i=0;i<totalSection;i++)
    {
        if (section==i)
        {
            NSNumber *numbers;
            numbers=[_monthArray objectAtIndex:i];
            return [numbers intValue];
        }
    }
    }
    return 0;
}

//自定义cell风格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetifier = @"cell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
    }
    
    NotePage *notePage = noteListArray[[noteListArray count]-indexPath.row-1];
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
//创建中的UIView对象
    _cellLeftView=[[UIView alloc]init];
    _cellLeftView.frame=CGRectMake(0, 0, 80, 80);
    _cellLeftView.backgroundColor=themecolor;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_cellLeftView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: (CGSize){10, 10}].CGPath;
    _cellLeftView.layer.mask = maskLayer;
    [_cellView addSubview:_cellLeftView];
//显示标题
    _titleLabel=[[UILabel alloc]init];
    _titleLabel.frame=CGRectMake(100,30,deviceWidth-160, 15);
    _titleLabel.font=[UIFont systemFontOfSize:20];
    _cellTitle=[[NSString alloc]init];
    _titleLabel.text=notePage.titile;
    _titleLabel.numberOfLines=0;
    _titleLabel.tag=indexPath.row;
    _titleLabel.textColor=themecolor;
    [_cellView addSubview:_titleLabel];
//显示地理位置(偷懒没做定位==)
    _locationTitle=[[UILabel alloc]init];
    _locationTitle.text=[NSString stringWithFormat:@"江苏省 江阴市"];
    _locationTitle.textColor=themecolor;
    _locationTitle.frame=CGRectMake(100, 52, 200, 20);
    _locationTitle.font=[UIFont systemFontOfSize:13];
    [_cellView addSubview:_locationTitle];
//显示时间
    _time=[[NSString alloc]init];
    _time=notePage.time;
    _date=[[_time substringWithRange:NSMakeRange(8, 2)]intValue];
    _hour=[[_time substringWithRange:NSMakeRange(11, 2)]intValue];
    _minute=[[_time substringWithRange:NSMakeRange(14,2)]intValue];
    _year=[[_time substringWithRange:NSMakeRange(0,4)]intValue];
    _month=[[_time substringWithRange:NSMakeRange(5, 2)]intValue];
    
    _hourLabel=[[UILabel alloc]init];
    _hourLabel.frame=CGRectMake(100,5, 200, 20);
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
//显示星期
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setYear:_year];
    [comps setMonth:_month];
    [comps setDay:_date];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *today = [calendar dateFromComponents:comps];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"日曜日", @"月曜日", @"火曜日", @"水曜日", @"木曜日", @"金曜日", @"土曜日", nil];
    NSCalendar *calendarSecond = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    [calendarSecond setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *theComponents = [calendarSecond components:calendarUnit fromDate:today];
    _xinTitle=[[UILabel alloc]init];
    _xinTitle.text=weekdays[theComponents.weekday];
    _xinTitle.textColor=[UIColor whiteColor];
    _xinTitle.font=[UIFont systemFontOfSize:20];
    _xinTitle.frame=CGRectMake(0,15, 80, 80);
    _xinTitle.textAlignment=NSTextAlignmentCenter;
    [_cellLeftView addSubview:_xinTitle];
//显示几号
    _dateLabel=[[UILabel alloc]init];
    _dateLabel.frame=CGRectMake(0,-15, 80, 80);
    _dateLabel.text=[NSString stringWithFormat:@"%d",_date];
    _dateLabel.textAlignment=NSTextAlignmentCenter;
    _dateLabel.font=[UIFont systemFontOfSize:35];
    _dateLabel.textColor=[UIColor whiteColor];
    _dateLabel.backgroundColor=[UIColor clearColor];
    _dateLabel.layer.masksToBounds = YES;
    [_cellLeftView addSubview:_dateLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

//设置cell行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

//选择便可进入编辑界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NotePageController *noteController = [[NotePageController alloc]init];
    
    noteController.noteDelegate = self;
    
    noteController.backFirst=self;
    
    noteController.currentPage = noteListArray[indexPath.row];
    
    [self.navigationController pushViewController:noteController animated:YES];
    
}

//滑动删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
{
        NotePage *notePage = noteListArray[[noteListArray count]-indexPath.row-1];
        [NotePageSearvice deleteNotePage:nil title:nil currentNotePage:notePage];
        noteListArray = [[SqlService sqlInstance]queryDBtable];
        [_noteListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self backFirst];
        [_noteListTableView reloadData];
}
}

-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//更新TableView
#pragma mark --updateNoteDelegate
-(void)updateTheNoteList
{
    NSLog(@"queryDBtable");
    noteListArray = [[SqlService sqlInstance] queryDBtable];
    [_noteListTableView reloadData];
}



@end


@interface HomeNavigationController()


@end

@implementation HomeNavigationController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
