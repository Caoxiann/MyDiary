//
//  BXMainPage.m
//  My Diary
//
//  Created by 徐贤达 on 2017/1/15.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import "BXMainPage.h"
#import "ElementsViewController.h"
#import "CalendarViewController.h"
#import "DiaryViewController.h"
#import "NotePageController.h"
#import "BXElements.h"

@interface BXMainPage ()

@end

@implementation BXMainPage

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        update=0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    numbers=0;
    subNumbers=0;
    page1=YES;
    
    
//主题颜色调配
//    NSString *colorname =@"0x69D7DD";
//    long colorLong = strtoul([colorname cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
//    int R = (colorLong & 0xFF0000 )>>16;
//    int G = (colorLong & 0x00FF00 )>>8;
//    int B =  colorLong & 0x0000FF;
//    UIColor *themecolor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    
    UIColor *themecolor = [UIColor colorWithRed:107/255.0 green:183/255.0 blue:219/255.0 alpha:1];
    
    //UIColor *theme=[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    
//创建UISegmentControl对象
    UISegmentedControl *mainSegmentControl=[[UISegmentedControl alloc]init];
    mainSegmentControl.frame=CGRectMake(30,deviceHeight*4/100,deviceWidth-60,24);
    [mainSegmentControl setTintColor:themecolor];
    [mainSegmentControl insertSegmentWithTitle:@"项目" atIndex:1 animated:NO];
    [mainSegmentControl insertSegmentWithTitle:@"日历" atIndex:2 animated:NO];
    [mainSegmentControl insertSegmentWithTitle:@"日记" atIndex:3 animated:NO];
    mainSegmentControl.selectedSegmentIndex=0;
    [mainSegmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mainSegmentControl];
    
//创建子ViewController对象
    
    self.elements=[[BXElements alloc]init];
    [self.elements.view setFrame:CGRectMake(0,deviceHeight*15/100,deviceWidth,deviceHeight*78/100)];
    [self addChildViewController:_elements];
    
    self.calendar=[[CalendarViewController alloc]init];
    [self.calendar.view setFrame:CGRectMake(0,deviceHeight*15/100,deviceWidth,deviceHeight*78/100)];
    [self addChildViewController:_calendar];
    
    self.diary=[[DiaryViewController alloc]init];
    [self.diary.view setFrame:CGRectMake(0,deviceHeight*15/100,deviceWidth,deviceHeight*78/100)];
    [self addChildViewController:_diary];
    
    [self.view addSubview:self.diary.view];
    [self.view addSubview:self.calendar.view];
    [self.view addSubview:self.elements.view];
    
//创建UILabel对象
    UIColor *color=[UIColor colorWithRed:255/255.0 green:99/255.0 blue:71/255.0 alpha:1.0];
    _label=[[UILabel alloc]init];
    _label.frame=CGRectMake((deviceWidth/2)-35,deviceHeight*9/100, 100, 30);
    _label.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:22];
    _label.textColor=color;
    _label.text=@"Elements";
    [self.view addSubview:_label];
    
//创建工具栏UIToolBar对象
    self.navigationController.navigationBar.hidden=YES;
    UIColor *color2=[UIColor colorWithRed:0 green:191/255.0 blue:255/255.0 alpha:1.0];
    UIToolbar *toolbar=[[UIToolbar alloc]init];
    self.navigationController.toolbar.hidden=NO;
    self.navigationController.toolbar.translucent=NO;
    toolbar.frame=CGRectMake(0,deviceHeight*93/100,deviceWidth,deviceHeight*7/100);
    toolbar.barTintColor=color2;
    
//创建工具栏按钮UIBarButtonItem对象
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(0, 0,20, 20);
    [btn1 setImage:[UIImage imageNamed:@"list@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *btn01=[[UIBarButtonItem alloc]initWithCustomView:btn1];
    
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(0, 0, 20, 20);
    [btn2 setImage:[UIImage imageNamed:@"characters@2x.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self.elements action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn02=[[UIBarButtonItem alloc]initWithCustomView:btn2];
    
    UIButton *btn3=[UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame=CGRectMake(0, 0, 20, 20);
    [btn3 setImage:[UIImage imageNamed:@"camera@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *btn03=[[UIBarButtonItem alloc]initWithCustomView:btn3];
    
    UIBarButtonItem *btnZ=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    [btnZ setWidth:22];
    
    UIBarButtonItem *btnX=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    [btnX setWidth:deviceWidth*37/100];
    
    UIButton *btn4=[UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame=CGRectMake(deviceWidth*77/100,deviceHeight*95.2/100,20,20);
    [btn4 setImage:[UIImage imageNamed:@"item@2x.png"] forState:UIControlStateNormal];
    
    NSArray *array=[NSArray arrayWithObjects:btn01,btnZ,btn02,btnZ,btn03,nil];
    toolbar.items=array;
    [self.view addSubview:toolbar];
    [self.view addSubview:btn4];
    
//创建右侧label对象并且定时更新
    _rightLabel=[[UILabel alloc]init];
    numbers=[_elements getNumberOfActivities];
    NSString *string=[NSString stringWithFormat:@"%ld 项目",numbers];
    _rightLabel.text=string;
    _rightLabel.frame=CGRectMake(deviceWidth*85/100,deviceHeight*93/100, 70,deviceHeight*6.5/100);
    _rightLabel.font=[UIFont fontWithName:@"Helvetica" size:15];
    _rightLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:_rightLabel];
    NSTimer *time=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimes) userInfo:nil repeats:YES];
    
    // Do any additional setup after loading the view.
}

//切换视图
-(void)change:(UISegmentedControl*)mainSegmentControl
{
    if(mainSegmentControl.selectedSegmentIndex==0)
    {
        [self jumpToOne];
        page1=YES;
    }
    if (mainSegmentControl.selectedSegmentIndex==1)
    {
        [self jumpToTwo];
        page1=NO;
    }
    if (mainSegmentControl.selectedSegmentIndex==2)
    {
        [self jumpToThree];
        page1=NO;
    }

}

-(void)jumpToOne
{
    _label.text=@"Elements";
    [self.view bringSubviewToFront:self.elements.view];
}

-(void)jumpToTwo
{
    _label.text=@"Calendar";
    [self.view bringSubviewToFront:self.calendar.view];
}

-(void)jumpToThree
{
    _label.text=@"My Diary";
    [self.view bringSubviewToFront:self.diary.view];
}

//更新时间
-(void)updateTimes
{
    numbers=[_elements getNumberOfActivities];
    NSString *string=[NSString stringWithFormat:@"%ld 项目",numbers];
    _rightLabel.text=string;
    _rightLabel.frame=CGRectMake(deviceWidth*85/100,deviceHeight*93/100, 70,deviceHeight*6.5/100);
    [self.view addSubview:_rightLabel];
    if (update!=[_elements update])
    {
        [_diary updateTheNote];
        [_calendar updateTheNoteList];
        update=[_elements update];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
