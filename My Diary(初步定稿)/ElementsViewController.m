//
//  ElementsViewController.m
//  My Diary
//
//  Created by 徐贤达 on 2017/1/15.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import "ElementsViewController.h"
#import "BXMainPage.h"

@interface ElementsViewController ()

@end

@implementation ElementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIColor *color=[UIColor colorWithPatternImage:[UIImage imageNamed:@"yourname.jpg"]];
//    self.view.backgroundColor=color;
    
    UIImage *backImage=[UIImage imageNamed:@"yourname.jpg"];
    self.view.layer.contents=(id)backImage.CGImage;
    self.view.layer.backgroundColor=[UIColor clearColor].CGColor;
    
    // Do any additional setup after loading the view.
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
