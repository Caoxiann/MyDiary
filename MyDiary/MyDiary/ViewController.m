//
//  ViewController.m
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNavigationBar];
    [self buildSegmentBar];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildNavigationBar {
    
    UINavigationBar *elementNavigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    
    [elementNavigationBar setTintColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    
    UILabel *elementTitle = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 20, 55, 40, 20)];
    [elementTitle setText:@"Element"];
    
    
    NSDictionary *nagivationBarItem = [NSDictionary dictionaryWithObjectsAndKeys:@"Element", @"Key1", @"Calender", @"Key2", @"Diary", @"Key3", nil];
    
    [elementNavigationBar setTitleTextAttributes:nagivationBarItem];
    
    [self.view addSubview:elementTitle];
    [self.view addSubview:elementNavigationBar];
    
}

- (void)buildSegmentBar {
    
    UISegmentedControl *baseSegmentBar = [[UISegmentedControl alloc]initWithFrame:CGRectMake(15, 30, [UIScreen mainScreen].bounds.size.width - 30, 20)];
    
    [baseSegmentBar setTintColor:[UIColor colorWithRed:107/255.0 green:183/255.0 blue:219/255.0 alpha:1]];
    
    [baseSegmentBar setMultipleTouchEnabled:YES];
    [baseSegmentBar setSelectedSegmentIndex:0];
    
    [baseSegmentBar insertSegmentWithTitle:@"Element" atIndex:0 animated:YES];
    [baseSegmentBar insertSegmentWithTitle:@"Calender" atIndex:1 animated:YES];
    [baseSegmentBar insertSegmentWithTitle:@"Diary" atIndex:2 animated:YES];
    
    
    
    [self.view addSubview:baseSegmentBar];
}







@end
