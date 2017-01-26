//
//  VCElements.m
//  MyDiary
//
//  Created by Jimmy Fan on 2017/1/22.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import "VCElements.h"

@interface VCElements ()

@end

@implementation VCElements

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width - 50);
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel* _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35)];
    _label.text = @"ELEMENTS";
    _label.textColor = [UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [_label setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:_label];
    
    UIView* _backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 35, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIImageView* _imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage.jpg"]];
    [_backgroundview addSubview:_imageview];
    [self.view addSubview:_backgroundview];
    
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
