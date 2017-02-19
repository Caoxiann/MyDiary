//
//  VCCamera.m
//  MyDiary
//
//  Created by Jimmy Fan on 2017/2/4.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import "VCCamera.h"

@interface VCCamera ()

@end

@implementation VCCamera

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Camera";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel* _label = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, [UIScreen mainScreen].bounds.size.width - 60, 100)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"相机功能暂未开放";
    _label.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:_label];
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
