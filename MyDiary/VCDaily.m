//
//  VCDaily.m
//  MyDairy
//
//  Created by 向尉 on 2017/1/13.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "VCDaily.h"
#import "VCDiary.h"

@interface VCDaily ()

@end

@implementation VCDaily

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.seg setSelectedSegmentIndex:1];
    [self.seg addTarget:self action:@selector(chooseSeg:) forControlEvents:UIControlEventValueChanged];
    [self.labView setText:@"CALENDAR"];
    // Do any additional setup after loading the view.
}

-(void)pressToolBtn02
{

}

-(void)chooseSeg:(UISegmentedControl *) segmentedControl
{
    if (self.seg.selectedSegmentIndex ==0)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if (self.seg.selectedSegmentIndex ==2)
    {
        VCDiary *diary=[[VCDiary alloc]init];
        [self.navigationController pushViewController:diary animated:NO];
        [self.seg setSelectedSegmentIndex:1];
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
