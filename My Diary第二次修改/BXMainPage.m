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

@interface BXMainPage ()

@end

@implementation BXMainPage

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    numbers=0;
    
//主题颜色调配
    NSString *colorname =@"0x69D7DD";
    long colorLong = strtoul([colorname cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    int R = (colorLong & 0xFF0000 )>>16;
    int G = (colorLong & 0x00FF00 )>>8;
    int B =  colorLong & 0x0000FF;
    UIColor *themecolor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    
    //UIColor *theme=[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    
//创建UISegmentControl对象
    UISegmentedControl *mainSegmentControl=[[UISegmentedControl alloc]init];
    mainSegmentControl.frame=CGRectMake(30, 22, 260, 20);
    [mainSegmentControl setTintColor:themecolor];
    [mainSegmentControl insertSegmentWithTitle:@"项目" atIndex:1 animated:NO];
    [mainSegmentControl insertSegmentWithTitle:@"日历" atIndex:2 animated:NO];
    [mainSegmentControl insertSegmentWithTitle:@"日记" atIndex:3 animated:NO];
    mainSegmentControl.selectedSegmentIndex=0;
    [mainSegmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mainSegmentControl];
    
//创建子ViewController对象
    self.elements=[[ElementsViewController alloc]init];
    [self.elements.view setFrame:CGRectMake(0, 85, 320, 450)];
    [self addChildViewController:_elements];
    
    self.calendar=[[CalendarViewController alloc]init];
    [self.calendar.view setFrame:CGRectMake(0, 85, 320, 450)];
    [self addChildViewController:_calendar];
    
    self.diary=[[DiaryViewController alloc]init];
    [self.diary.view setFrame:CGRectMake(0, 85, 320, 450)];
    [self addChildViewController:_diary];
    
    [self.view addSubview:self.diary.view];
    [self.view addSubview:self.calendar.view];
    [self.view addSubview:self.elements.view];
    
//创建UILabel对象
    UIColor *color=[UIColor colorWithRed:255/255.0 green:99/255.0 blue:71/255.0 alpha:1.0];
    _label=[[UILabel alloc]init];
    _label.frame=CGRectMake(120,45, 100, 30);
    _label.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:20];
    _label.textColor=color;
    _label.text=@"Elements";
    [self.view addSubview:_label];
    
//创建工具栏UIToolBar对象
    UIColor *color2=[UIColor colorWithRed:0 green:191/255.0 blue:255/255.0 alpha:1.0];
    UIToolbar *toolbar=[[UIToolbar alloc]init];
    self.navigationController.toolbar.hidden=NO;
    self.navigationController.toolbar.translucent=NO;
    toolbar.frame=CGRectMake(0, 530, 320, 38);
    toolbar.barTintColor=color2;
    
//创建工具栏按钮UIBarButtonItem对象
    UIBarButtonItem *btn01=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:nil];
    btn01.tintColor=[UIColor whiteColor];
    UIBarButtonItem *btn02=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:nil];
    btn02.tintColor=[UIColor whiteColor];
    UIBarButtonItem *btn03=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:nil];
    btn03.tintColor=[UIColor whiteColor];
    UIBarButtonItem *btnZ=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    [btnZ setWidth:20];
    NSArray *array=[NSArray arrayWithObjects:btn01,btnZ,btn02,btnZ,btn03,nil];
    toolbar.items=array;
    [self.view addSubview:toolbar];
    
//创建右侧label对象
    UILabel *rightLabel=[[UILabel alloc]init];
    NSString *string=[NSString stringWithFormat:@"%d 项目",numbers];
    rightLabel.text=string;
    rightLabel.frame=CGRectMake(270, 530, 70, 38);
    rightLabel.font=[UIFont fontWithName:@"Helvetica" size:15];
    rightLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:rightLabel];
    
    // Do any additional setup after loading the view.
}

-(void)change:(UISegmentedControl*)mainSegmentControl
{
    if(mainSegmentControl.selectedSegmentIndex==0)
    {
        [self jumpToOne];
    }
    if (mainSegmentControl.selectedSegmentIndex==1)
    {
        [self jumpToTwo];
    }
    if (mainSegmentControl.selectedSegmentIndex==2)
    {
        [self jumpToThree];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
