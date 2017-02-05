//
//  EditViewController.m
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)buildNavigationBar {
    
    UINavigationBar *elementNavigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 85)];
    
    [elementNavigationBar setTintColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    
    UILabel *elementTitle = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 20, 60, 40, 20)];
    [elementTitle setText:@"Element"];
    
    
    NSDictionary *nagivationBarItem = [NSDictionary dictionaryWithObjectsAndKeys:@"Element", @"Key1", @"Calender", @"Key2", @"Diary", @"Key3", nil];
    
    [elementNavigationBar setTitleTextAttributes:nagivationBarItem];
    
    [self.view addSubview:elementTitle];
    [self.view addSubview:elementNavigationBar];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

