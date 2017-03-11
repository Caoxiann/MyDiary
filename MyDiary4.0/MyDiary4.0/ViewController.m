//
//  ViewController.m
//  MyDiary02
//
//  Created by 向尉 on 2017/1/20.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //set background image;
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    [imgView setImage:[UIImage imageNamed:@"cloud.jpg"]];
    [self.view addSubview:imgView];
    
    
    //set navigationBar
    UIColor *designedColor=[UIColor colorWithRed:105/255.0 green:215/255.0 blue:221/255.0 alpha:1.0];
    self.centreView=[[UIView alloc]initWithFrame:self.navigationController.navigationBar.frame];
    [self.navigationItem setTitleView:self.centreView];
    _seg=[[UISegmentedControl alloc]initWithFrame:CGRectMake(40, 1, self.centreView.frame.size.width-80, 20)];
    [_seg insertSegmentWithTitle:@"项目" atIndex:0 animated:NO];
    [_seg insertSegmentWithTitle:@"日历" atIndex:1 animated:NO];
    [_seg insertSegmentWithTitle:@"日记" atIndex:2 animated:NO];
    [_centreView addSubview:self.seg];
    _labView=[[UILabel alloc]initWithFrame:CGRectMake(self.centreView.frame.size.width/2-60, 20, 120, 30)];
    [_labView setTextColor:designedColor];
    [_labView setTextAlignment:NSTextAlignmentCenter];
    [_centreView addSubview:self.labView];
    
    
    //set toolBarItems
    [self.navigationController.toolbar setBarTintColor:designedColor];
    [self.navigationController.toolbar setTintColor:[UIColor whiteColor]];
    
    //set firstToolBarItem
    UIButton *btnInToolBtn01=[UIButton buttonWithType:UIButtonTypeSystem];
    [btnInToolBtn01 setImage:[UIImage imageNamed:@"list@2x.png"] forState:UIControlStateNormal];
    [btnInToolBtn01 setFrame:CGRectMake(0, 0, 18, 18)];
    //[btnInToolBtn01 addTarget:self action:@selector(pressToolBtn01) forControlEvents:UIControlEventTouchUpInside];
    _toolBtn01=[[UIBarButtonItem alloc]initWithCustomView:btnInToolBtn01];
    //self.toolBtn01=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(pressToolBtn01)];
    
    
    //set secondToolBarItem
    //self.toolBtn02=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(pressToolBtn02)];
    UIButton *btnInToolBtn02=[UIButton buttonWithType:UIButtonTypeSystem];
    [btnInToolBtn02 setImage:[UIImage imageNamed:@"characters@2x.png"] forState:UIControlStateNormal];
    [btnInToolBtn02 setFrame:CGRectMake(0, 0, 22, 22)];
    //[btnInToolBtn02 addTarget:self action:@selector(pressToolBtn02) forControlEvents:UIControlEventTouchUpInside];
    _toolBtn02=[[UIBarButtonItem alloc]initWithCustomView:btnInToolBtn02];
    
    
    //set thirdToolBarItem
    UIButton *btnInToolBtn03=[UIButton buttonWithType:UIButtonTypeSystem];
    [btnInToolBtn03 setImage:[UIImage imageNamed:@"camera@2x.png"] forState:UIControlStateNormal];
    [btnInToolBtn03 setFrame:CGRectMake(0, 0, 25, 20)];
    _toolBtn03=[[UIBarButtonItem alloc]initWithCustomView:btnInToolBtn03];
    
    //set fixedToolBarItem between toolBarItems
    _fixedBtn01=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [_fixedBtn01 setWidth:20];
    
    //set fixedToolBarItem in the centre
    _fixedBtn02=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [_fixedBtn02 setWidth:self.view.frame.size.width-235];
    
    //set fourthToolBarItem
    UIButton *btnInToolBtn04=[UIButton buttonWithType:UIButtonTypeSystem];
    [btnInToolBtn04 setImage:[UIImage imageNamed:@"item.png"] forState:UIControlStateNormal];
    //[btnInToolBtn04 setImage:[UIImage imageNamed:@"item.png"] forState:UIControlStateHighlighted];
    [btnInToolBtn04 setFrame:CGRectMake(0, 0, 20, 20)];
    _toolBtn04=[[UIBarButtonItem alloc]initWithCustomView:btnInToolBtn04];
    
    //set fifthToolBarItem
    UILabel *labInToolBtn05=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    [labInToolBtn05 setTag:101];
    [labInToolBtn05 setText:@""];
    [labInToolBtn05 setTextColor:[UIColor whiteColor]];
    _toolBtn05=[[UIBarButtonItem alloc]initWithCustomView:labInToolBtn05];
    //add toolBarItems
    NSArray *toolBtns=[NSArray arrayWithObjects:self.toolBtn01, self.fixedBtn01,self.toolBtn02, self.fixedBtn01, self.toolBtn03, self.fixedBtn02, self.toolBtn04, self.toolBtn05, nil];
    [self setToolbarItems:toolBtns];
}

-(void)pressToolBtn01
{
    
}

-(void)pressToolBtn02
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
