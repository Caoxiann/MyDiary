//
//  VCDiary.m
//  MyDairy
//
//  Created by 向尉 on 2017/1/15.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "VCDiary.h"
#import "VCDiaryWrite.h"

@interface VCDiary ()

@end

@implementation VCDiary

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.seg setSelectedSegmentIndex:2];[self.seg addTarget:self action:@selector(chooseSeg:) forControlEvents:UIControlEventValueChanged];
    [self.labView setText:@"DIARY"];
    // Do any additional setup after loading the view.
}

-(void)pressToolBtn02
{
    VCDiaryWrite *diaryWrite=[[VCDiaryWrite alloc]init];
    [self.navigationController pushViewController:diaryWrite animated:YES];
}

-(void)chooseSeg:(UISegmentedControl *) segmentedControl
{
    if (self.seg.selectedSegmentIndex == 0)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else if(self.seg.selectedSegmentIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
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
