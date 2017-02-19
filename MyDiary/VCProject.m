//
//  VC_Project.m
//  MyDairy
//
//  Created by 向尉 on 2017/1/13.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "VCProject.h"
#import "VCDaily.h"
#import "VCDiary.h"
#import "VCProjectWrite.h"

@interface VCProject ()

@end

@implementation VCProject

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.seg setSelectedSegmentIndex:0];
    [self.seg addTarget:self action:@selector(chooseSeg:) forControlEvents:UIControlEventValueChanged];
    [self.labView setText:@"ELEMENTS"];
    // Do any additional setup after loading the view.
}
-(void)pressToolBtn02
{
    VCProjectWrite *projWrite=[[VCProjectWrite alloc]init];
    [self.navigationController pushViewController:projWrite animated:YES];
}

-(void)chooseSeg:(UISegmentedControl *) segmentedControl
{
    if (segmentedControl.selectedSegmentIndex == 1) {
        VCDaily *daily=[[VCDaily alloc]init];
        [self.navigationController pushViewController:daily animated:NO];
        [self.seg setSelectedSegmentIndex:0];
        
    }
    else if(segmentedControl.selectedSegmentIndex == 2)
    {
        VCDiary *diary=[[VCDiary alloc]init];
        [self.navigationController pushViewController:diary animated:NO];
        [self.seg setSelectedSegmentIndex:0];
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
