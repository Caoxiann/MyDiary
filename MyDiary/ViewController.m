//
//  ViewController.m
//  MyDairy
//
//  Created by 向尉 on 2017/1/19.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //set background image;
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    [imgView setImage:[UIImage imageNamed:@"5.jpg"]];
    [self.view addSubview:imgView];
    
    
    //set navigationBar
    UIColor *designedColor=[UIColor colorWithRed:105/255.0 green:215/255.0 blue:221/255.0 alpha:1.0];
    UIView *view=[[UIView alloc]initWithFrame:self.navigationController.navigationBar.frame];
    [self.navigationItem setTitleView:view];
    self.seg=[[UISegmentedControl alloc]initWithFrame:CGRectMake(view.frame.size.width/2.0-150, 1, 300, 20)];
    [self.seg insertSegmentWithTitle:@"Project" atIndex:0 animated:NO];
    [self.seg insertSegmentWithTitle:@"Daily" atIndex:1 animated:NO];
    [self.seg insertSegmentWithTitle:@"Diary" atIndex:2 animated:NO];
    [view addSubview:self.seg];
    self.labView=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width/2-60, 20, 120, 30)];
    [self.labView setTextColor:designedColor];
    [self.labView setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:self.labView];
    
    
    //set toolBarItems
    [self.navigationController.toolbar setBarTintColor:designedColor];
    [self.navigationController.toolbar setTintColor:[UIColor whiteColor]];
    
    //set firstToolBarItem
    UIButton *btnInToolBtn01=[UIButton buttonWithType:UIButtonTypeSystem];
    [btnInToolBtn01 setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    [btnInToolBtn01 setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateHighlighted];
    [btnInToolBtn01 setFrame:CGRectMake(0, 0, 15, 15)];
    self.toolBtn01=[[UIBarButtonItem alloc]initWithCustomView:btnInToolBtn01];
    
    //set secondToolBarItem
    self.toolBtn02=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(pressToolBtn02)];
    
    //set thirdToolBarItem
    UIButton *btnInToolBtn03=[UIButton buttonWithType:UIButtonTypeSystem];
    [btnInToolBtn03 setImage:[UIImage imageNamed:@"camera@2x.png"] forState:UIControlStateNormal];
    [btnInToolBtn03 setImage:[UIImage imageNamed:@"camera@2x.png"] forState:UIControlStateHighlighted];
    [btnInToolBtn03 setFrame:CGRectMake(0, 0, 25, 20)];
    self.toolBtn03=[[UIBarButtonItem alloc]initWithCustomView:btnInToolBtn03];
    
    //set fixedToolBarItem between toolBarItems
    self.fixedBtn01=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [self.fixedBtn01 setWidth:20];
    
    //set fixedToolBarItem in the centre
    self.fixedBtn02=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [self.fixedBtn02 setWidth:self.view.frame.size.width-235];
    
    //set fourthToolBarItem
    UIButton *btnInToolBtn04=[UIButton buttonWithType:UIButtonTypeSystem];
    [btnInToolBtn04 setImage:[UIImage imageNamed:@"item.png"] forState:UIControlStateNormal];
    [btnInToolBtn04 setImage:[UIImage imageNamed:@"item.png"] forState:UIControlStateHighlighted];
    [btnInToolBtn04 setFrame:CGRectMake(0, 0, 20, 20)];
    self.toolBtn04=[[UIBarButtonItem alloc]initWithCustomView:btnInToolBtn04];
    
    //set fifthToolBarItem
    NSString *str=[NSString stringWithFormat:@"%d项目",2];
    UILabel *labInToolBtn05=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    [labInToolBtn05 setText:str];
    [labInToolBtn05 setTextColor:[UIColor whiteColor]];
    self.toolBtn05=[[UIBarButtonItem alloc]initWithCustomView:labInToolBtn05];
    
    //
    NSArray *toolBtns=[NSArray arrayWithObjects:_toolBtn01, _fixedBtn01,_toolBtn02, _fixedBtn01, _toolBtn03, _fixedBtn02, _toolBtn04, _toolBtn05, nil];
    [self setToolbarItems:toolBtns];
    // Do any additional setup after loading the view.
}

-(void)pressToolBtn02
{

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
