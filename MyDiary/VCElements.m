//
//  VCElements.m
//  MyDiary
//
//  Created by Jimmy Fan on 2017/1/22.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import "VCElements.h"
#import "VCCalendar.h"
#import "VCDiary.h"
#import "VCCharacters.h"
#import "VCCamera.h"
#import "FMDatabase.h"
#import "MyCell.h"
#import "VCElementLook.h"

@interface VCElements ()

@end

@implementation VCElements

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;

    
    _segControl = [[UISegmentedControl alloc] init];
    _segControl.frame = CGRectMake(10, 25, 300, 25);
    [_segControl setTintColor:[UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255]];
    
    [_segControl insertSegmentWithTitle:@"项目" atIndex:0 animated:NO];
    [_segControl insertSegmentWithTitle:@"日历" atIndex:1 animated:NO];
    [_segControl insertSegmentWithTitle:@"日记" atIndex:2 animated:NO];
    _segControl.selectedSegmentIndex = 0;
    [self.view addSubview: _segControl];
    [_segControl addTarget:self action:@selector(segChange) forControlEvents:UIControlEventValueChanged];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel* _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 35)];
    _label.text = @"ELEMENTS";
    _label.textColor = [UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [_label setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:_label];
    
    UIView* _backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 85, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIImageView* _imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage.jpg"]];
    [_backgroundview addSubview:_imageview];
    [self.view addSubview:_backgroundview];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 110) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    UIImage* _image = [UIImage imageNamed:@"list.png"];
    UIGraphicsBeginImageContext(CGSizeMake(16, 15.5));
    [_image drawInRect:CGRectMake(0, 0, 16, 15.5)];
    UIImage* _newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    btn01 = [[UIBarButtonItem alloc] initWithImage:_newImage style:UIBarButtonItemStylePlain target:self action:@selector(pressList)];
    
    _image = [UIImage imageNamed:@"characters.png"];
    UIGraphicsBeginImageContext(CGSizeMake(18, 18));
    [_image drawInRect:CGRectMake(0, 0, 18, 18)];
    _newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    btn02 = [[UIBarButtonItem alloc] initWithImage:_newImage style:UIBarButtonItemStylePlain target:self action:@selector(pressCharacters)];
    
    _image = [UIImage imageNamed:@"camera.png"];
    UIGraphicsBeginImageContext(CGSizeMake(20, 16));
    [_image drawInRect:CGRectMake(0, 0, 20, 16)];
    _newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    btn03 = [[UIBarButtonItem alloc] initWithImage:_newImage style:UIBarButtonItemStylePlain target:self action:@selector(pressCamera)];
    
    _image = [UIImage imageNamed:@"item.png"];
    UIGraphicsBeginImageContext(CGSizeMake(22, 20));
    [_image drawInRect:CGRectMake(0, 0, 22, 20)];
    _newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    btn04 = [[UIBarButtonItem alloc] initWithImage:_newImage style:UIBarButtonItemStylePlain target:nil action:nil];

    btn05 = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld 项目",_arrayDay.count] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    btnF01 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    btnF01.width = 10;
    btnF02 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    btnF02.width = 110;
    
    NSArray* arrayBtns = [NSArray arrayWithObjects:btn01,btnF01,btn02,btnF01,btn03,btnF02,btn04,btn05, nil];
    _toolbar.items = arrayBtns;
    
    _toolbar.barTintColor = [UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255];
    _toolbar.tintColor = [UIColor whiteColor];
    
    [self.view addSubview:_toolbar];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arrayDay.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellStr = @"cell";
    MyCell* cell = [_tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
    }
    
    [cell setMonth:[_arrayMonth objectAtIndex:indexPath.section] Day:[_arrayDay objectAtIndex:indexPath.section] Week:[_arrayWeek objectAtIndex:indexPath.section] Title:[_arrayTitle objectAtIndex:indexPath.section] Content:[_arrayContent objectAtIndex:indexPath.section] Minute:[_arrayMinute objectAtIndex:indexPath.section]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSString*)monthIntoChinese:(NSString*)month {
    if ([month isEqualToString:@"01"]) return @"一月";
    if ([month isEqualToString:@"02"]) return @"二月";
    if ([month isEqualToString:@"03"]) return @"三月";
    if ([month isEqualToString:@"04"]) return @"四月";
    if ([month isEqualToString:@"05"]) return @"五月";
    if ([month isEqualToString:@"06"]) return @"六月";
    if ([month isEqualToString:@"07"]) return @"七月";
    if ([month isEqualToString:@"08"]) return @"八月";
    if ([month isEqualToString:@"09"]) return @"九月";
    if ([month isEqualToString:@"10"]) return @"十月";
    if ([month isEqualToString:@"11"]) return @"十一月";
    if ([month isEqualToString:@"12"]) return @"十二月";
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || [_arrayMonth objectAtIndex:section - 1] != [_arrayMonth objectAtIndex:section]) {
        UILabel* headerTitle = [[UILabel alloc] init];
        headerTitle.text = [@"   " stringByAppendingString:[self monthIntoChinese:[_arrayMonth objectAtIndex:section]]];
        headerTitle.textColor = [UIColor whiteColor];
        headerTitle.font = [UIFont systemFontOfSize:26];
        return headerTitle;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || [_arrayMonth objectAtIndex:section - 1] != [_arrayMonth objectAtIndex:section]) {
        return 50;
    }
    return 20;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
    //    return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/datebase.db"];
    _mDB = [[FMDatabase alloc] initWithPath:strPath];
    if ([_mDB open]) {
        NSString* strDel = [[NSString alloc] initWithFormat:@"delete from elements where id = %d;", [[_arrayID objectAtIndex:indexPath.section] intValue]];
        [_mDB executeUpdate:strDel];
    }
    [_arrayMonth removeObjectAtIndex:indexPath.section];
    [_arrayDay removeObjectAtIndex:indexPath.section];
    [_arrayTitle removeObjectAtIndex:indexPath.section];
    [_arrayContent removeObjectAtIndex:indexPath.section];
    [_arrayID removeObjectAtIndex:indexPath.section];
    [_arrayMinute removeObjectAtIndex:indexPath.section];
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VCElementLook* _vcElementLook = [[VCElementLook alloc] init];
    _vcElementLook.myID = [[NSNumber alloc] init];
    _vcElementLook.myID = [_arrayID objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:_vcElementLook animated:YES];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

 
- (void)segChange {
    if (_segControl.selectedSegmentIndex == 0) {

    }
    if (_segControl.selectedSegmentIndex == 1) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    if (_segControl.selectedSegmentIndex == 2) {
        VCDiary* vcdiary = [[VCDiary alloc] init];
        [self.navigationController pushViewController:vcdiary animated:NO];
        
    }
}

- (void)pressList {
    
}

- (void)pressCharacters {
    VCCharacters* vcCharacters = [[VCCharacters alloc] init];
    [self.navigationController pushViewController:vcCharacters animated:YES];
}

- (void)pressCamera {
    VCCamera* vcCamera = [[VCCamera alloc] init];
    [self presentViewController:vcCamera animated:YES completion:^{ }];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    _arrayDay = [[NSMutableArray alloc] init];
    _arrayMonth = [[NSMutableArray alloc] init];
    _arrayWeek = [[NSMutableArray alloc] init];
    _arrayTitle = [[NSMutableArray alloc] init];
    _arrayContent = [[NSMutableArray alloc] init];
    _arrayID = [[NSMutableArray alloc] init];
    _arrayMinute = [[NSMutableArray alloc] init];
    NSString* strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/datebase.db"];
    _mDB = [[FMDatabase alloc] initWithPath:strPath];
    if ([_mDB open]) {
        NSString* strQuery = @"select * from elements order by id desc;";
        FMResultSet* result = [_mDB executeQuery:strQuery];
        while ([result next]) {
            NSString* _month = [result stringForColumn:@"month"];
            NSString* _day = [result stringForColumn:@"day"];
            NSString* _week = [result stringForColumn:@"week"];
            NSString* _title = [result stringForColumn:@"title"];
            NSString* _content = [result stringForColumn:@"content"];
            NSInteger _id = [result intForColumn:@"id"];
            NSString* _minute = [result stringForColumn:@"minute"];
            [_arrayDay addObject:_day];
            [_arrayMonth addObject:_month];
            [_arrayWeek addObject:_week];
            [_arrayTitle addObject:_title];
            [_arrayContent addObject:_content];
            [_arrayID addObject:[NSNumber numberWithInteger:_id]];
            [_arrayMinute addObject:_minute];
        }
    }
    
    btn05 = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld 项目",_arrayDay.count] style:UIBarButtonItemStylePlain target:nil action:nil];
    NSArray* arrayBtns = [NSArray arrayWithObjects:btn01,btnF01,btn02,btnF01,btn03,btnF02,btn04,btn05, nil];
    _toolbar.items = arrayBtns;
    [_tableView reloadData];

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
