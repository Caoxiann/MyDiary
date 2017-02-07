//
//  VCCalendar.m
//  MyDiary
//
//  Created by Jimmy Fan on 2017/1/22.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import "VCCalendar.h"
#import <PDTSimpleCalendar/PDTSimpleCalendar.h>
#import "VCElements.h"
#import "VCDiary.h"
#import "VCCharacters.h"
#import "VCCamera.h"
#import "FMDatabase.h"

@interface VCCalendar ()

@end

@implementation VCCalendar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    NSString* strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/datebase.db"];
    _mDB = [[FMDatabase alloc] initWithPath:strPath];
    if ([_mDB open]) {
/*        NSString* strDle = @"drop table elements;";
        [_mDB executeUpdate:strDle];
*/        NSString* strCreateTable = @"create table if not exists elements(id integer primary key, month varchar(5), day varchar(5), week varchar(10), title varchar(30), content varchar(100), minute varchar(10));";
        [_mDB executeUpdate:strCreateTable];
    }
    
    _segControl = [[UISegmentedControl alloc] init];
    _segControl.frame = CGRectMake(10, 25, 300, 25);
    [_segControl setTintColor:[UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255]];
    
    [_segControl insertSegmentWithTitle:@"项目" atIndex:0 animated:NO];
    [_segControl insertSegmentWithTitle:@"日历" atIndex:1 animated:NO];
    [_segControl insertSegmentWithTitle:@"日记" atIndex:2 animated:NO];
    _segControl.selectedSegmentIndex = 1;
    [self.view addSubview: _segControl];
    [_segControl addTarget:self action:@selector(segChange) forControlEvents:UIControlEventValueChanged];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel* _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 35)];
    _label.text = @"CALENDAR";
    _label.textColor = [UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [_label setFont:[UIFont systemFontOfSize:20]];    
    [self.view addSubview:_label];

    UIView* _backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 85, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 150)];
    UIImageView* _imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage.jpg"]];
    [_backgroundview addSubview:_imageview];
    [self.view addSubview:_backgroundview];
    
    UIToolbar* _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
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
    _toolbar.items = arrayBtns;
    
    _toolbar.barTintColor = [UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255];
    _toolbar.tintColor = [UIColor whiteColor];
    
    [self.view addSubview:_toolbar];
    
}

- (void)viewDidAppear:(BOOL)animated {
    PDTSimpleCalendarViewController* vcCalendar = [[PDTSimpleCalendarViewController alloc] init];
    vcCalendar.view.layer.cornerRadius = 10;
    vcCalendar.view.layer.masksToBounds = YES;
    [[PDTSimpleCalendarViewCell appearance] setCircleDefaultColor:[UIColor whiteColor]];
    [[PDTSimpleCalendarViewCell appearance] setCircleSelectedColor:[UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255]];
    [[PDTSimpleCalendarViewCell appearance] setCircleTodayColor:[UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255]];
    [[PDTSimpleCalendarViewCell appearance] setTextDefaultColor:[UIColor blackColor]];
    [[PDTSimpleCalendarViewCell appearance] setTextSelectedColor:[UIColor whiteColor]];
    [[PDTSimpleCalendarViewCell appearance] setTextTodayColor:[UIColor whiteColor]];
    [self.view addSubview:vcCalendar.view];
    vcCalendar.view.frame = CGRectMake(15, 105, [UIScreen mainScreen].bounds.size.width - 30, 280);
}

- (void)viewWillAppear:(BOOL)animated {
    _segControl.selectedSegmentIndex = 1;
    self.navigationController.navigationBarHidden = YES;
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
        [self.navigationController pushViewController:vcelements animated:NO];
    }
    if (_segControl.selectedSegmentIndex == 1) {

    }
    if (_segControl.selectedSegmentIndex == 2) {
        VCDiary* vcdiary = [[VCDiary alloc] init];
        [self.navigationController pushViewController:vcdiary animated:NO];
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
