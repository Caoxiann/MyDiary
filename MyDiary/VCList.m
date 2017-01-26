//
//  VCList.m
//  MyDiary
//
//  Created by Jimmy Fan on 2017/1/23.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import "VCList.h"
#import "VCCalendar.h"
#import "VCElements.h"
#import "VCDiary.h"
#import "VCCharacters.h"
#import "VCCamera.h"

@interface VCList ()

@end

@implementation VCList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _segControl = [[UISegmentedControl alloc] init];
    _segControl.frame = CGRectMake(10, 25, 300, 25);
    [_segControl setTintColor:[UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255]];
    
    [_segControl insertSegmentWithTitle:@"项目" atIndex:0 animated:NO];
    [_segControl insertSegmentWithTitle:@"日历" atIndex:1 animated:NO];
    [_segControl insertSegmentWithTitle:@"日记" atIndex:2 animated:NO];
    
    _segControl.selectedSegmentIndex = 1;
    VCCalendar* vccalendar = [[VCCalendar alloc] init];
    [self.view addSubview:vccalendar.view];
    
    [_segControl addTarget:self action:@selector(segChange) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_segControl];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    self.navigationController.navigationBarHidden = YES;
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.translucent = NO;

    UIImage* _image = [UIImage imageNamed:@"list.png"];
    UIGraphicsBeginImageContext(CGSizeMake(16, 15.5));
    [_image drawInRect:CGRectMake(0, 0, 16, 15.5)];
    UIImage* _newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIBarButtonItem* btn01 = [[UIBarButtonItem alloc] initWithImage:_newImage style:UIBarButtonItemStylePlain target:self action:@selector(pressList)];
    
    _image = [UIImage imageNamed:@"characters.png"];
    UIGraphicsBeginImageContext(CGSizeMake(18, 18));
    [_image drawInRect:CGRectMake(0, 0, 18, 18)];
    _newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIBarButtonItem* btn02 = [[UIBarButtonItem alloc] initWithImage:_newImage style:UIBarButtonItemStylePlain target:self action:@selector(pressCharacters)];
    
    _image = [UIImage imageNamed:@"camera.png"];
    UIGraphicsBeginImageContext(CGSizeMake(20, 16));
    [_image drawInRect:CGRectMake(0, 0, 20, 16)];
    _newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIBarButtonItem* btn03 = [[UIBarButtonItem alloc] initWithImage:_newImage style:UIBarButtonItemStylePlain target:self action:@selector(pressCamera)];
    
    _image = [UIImage imageNamed:@"item.png"];
    UIGraphicsBeginImageContext(CGSizeMake(22, 20));
    [_image drawInRect:CGRectMake(0, 0, 22, 20)];
    _newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIBarButtonItem* btn04 = [[UIBarButtonItem alloc] initWithImage:_newImage style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    UIBarButtonItem* btnF01 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    btnF01.width = 10;
    UIBarButtonItem* btnF02 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    btnF02.width = 120;
    
    NSArray* arrayBtns = [NSArray arrayWithObjects:btn01,btnF01,btn02,btnF01,btn03,btnF02,btn04, nil];
    self.toolbarItems = arrayBtns;
    
    self.navigationController.toolbar.barTintColor = [UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255];
    self.navigationController.toolbar.tintColor = [UIColor whiteColor];
    

}


- (void)pressList {

}

- (void)pressCharacters {
    VCCharacters* vcCharacters = [[VCCharacters alloc] init];
    [self.navigationController pushViewController:vcCharacters animated:YES];
}

- (void)pressCamera {
    VCCamera* vcCamera = [[VCCamera alloc] init];
    [self.navigationController pushViewController:vcCamera animated:YES];
}



- (void)segChange {
    if (_segControl.selectedSegmentIndex == 0) {
        VCElements* vcelements = [[VCElements alloc] init];
        [self.view addSubview:vcelements.view];
    }
    if (_segControl.selectedSegmentIndex == 1) {
        VCCalendar* vccalendar = [[VCCalendar alloc] init];
        [self.view addSubview:vccalendar.view];
    }
    if (_segControl.selectedSegmentIndex == 2) {
        VCDiary* vcdiary = [[VCDiary alloc] init];
        [self.view addSubview:vcdiary.view];
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
