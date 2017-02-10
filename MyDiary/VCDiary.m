//
//  VCDiary.m
//  MyDiary
//
//  Created by Jimmy Fan on 2017/1/22.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import "VCCalendar.h"
#import "VCElements.h"
#import "VCDiary.h"
#import "VCDiaryAdd.h"
#import "VCCamera.h"
#import "MyCellDiary.h"
#import "VCDiaryEdit.h"

@interface VCDiary ()

@end

@implementation VCDiary

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _segControl = [[UISegmentedControl alloc] init];
    _segControl.frame = CGRectMake(10, 25, [UIScreen mainScreen].bounds.size.width - 20, 25);
    [_segControl setTintColor:[UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255]];
    
    [_segControl insertSegmentWithTitle:@"项目" atIndex:0 animated:NO];
    [_segControl insertSegmentWithTitle:@"日历" atIndex:1 animated:NO];
    [_segControl insertSegmentWithTitle:@"日记" atIndex:2 animated:NO];
    _segControl.selectedSegmentIndex = 2;
    [self.view addSubview: _segControl];
    [_segControl addTarget:self action:@selector(segChange) forControlEvents:UIControlEventValueChanged];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel* _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 35)];
    _label.text = @"DIARY";
    _label.textColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
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
    
    btnF01 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    btnF01.width = 20;
    btnF02 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    btnF02.width = [UIScreen mainScreen].bounds.size.width - 230;
    
    _toolbar.barTintColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
    _toolbar.tintColor = [UIColor whiteColor];
    
    [self.view addSubview:_toolbar];
    
    _arrayDay = [[NSMutableArray alloc] init];
    _arrayMonth = [[NSMutableArray alloc] init];
    _arrayWeek = [[NSMutableArray alloc] init];
    _arrayTitle = [[NSMutableArray alloc] init];
    _arrayContent = [[NSMutableArray alloc] init];
    _arrayID = [[NSMutableArray alloc] init];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arrayDay.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellStr = @"cell";
/*    MyCellDiary* cell = [_tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[MyCellDiary alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
    }
*/
    MyCellDiary* cell = [[MyCellDiary alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    [cell setMonth:[_arrayMonth objectAtIndex:indexPath.section] Day:[_arrayDay objectAtIndex:indexPath.section] Week:[_arrayWeek objectAtIndex:indexPath.section] Title:[_arrayTitle objectAtIndex:indexPath.section] Content:[_arrayContent objectAtIndex:indexPath.section]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel* _content = [[UILabel alloc] initWithFrame:CGRectMake(30, 90, [UIScreen mainScreen].bounds.size.width - 60, 0)];
    _content.numberOfLines = 0;
    _content.lineBreakMode = NSLineBreakByCharWrapping;
    _content.text = [_arrayContent objectAtIndex:indexPath.section];
    _content.font = [UIFont systemFontOfSize:18];
    CGRect contentRect = [_content.text boundingRectWithSize:_content.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_content.font, NSFontAttributeName, nil] context:nil];
    if (contentRect.size.height >= 200) contentRect.size.height = 215;
    return contentRect.size.height + 100;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/datebase.db"];
    _mDB = [[FMDatabase alloc] initWithPath:strPath];
    if ([_mDB open]) {
        NSString* strDel = [[NSString alloc] initWithFormat:@"delete from diary where id = %d;", [[_arrayID objectAtIndex:indexPath.section] intValue]];
        [_mDB executeUpdate:strDel];
    }
    [_arrayMonth removeObjectAtIndex:indexPath.section];
    [_arrayDay removeObjectAtIndex:indexPath.section];
    [_arrayTitle removeObjectAtIndex:indexPath.section];
    [_arrayContent removeObjectAtIndex:indexPath.section];
    [_arrayID removeObjectAtIndex:indexPath.section];
    btn05 = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld 项目",_arrayDay.count] style:UIBarButtonItemStylePlain target:nil action:nil];
    NSArray* arrayBtns = [NSArray arrayWithObjects:btn01,btnF01,btn02,btnF01,btn03,btnF02,btn04,btn05, nil];
    _toolbar.items = arrayBtns;
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VCDiaryEdit* _vcDiaryEdit = [[VCDiaryEdit alloc] init];
    _vcDiaryEdit.myID = [[NSNumber alloc] init];
    _vcDiaryEdit.myID = [_arrayID objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:_vcDiaryEdit animated:YES];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)segChange {
    if (_segControl.selectedSegmentIndex == 0) {
        VCElements* vcelements = [[VCElements alloc] init];
        [self.navigationController pushViewController:vcelements animated:NO];
    }
    if (_segControl.selectedSegmentIndex == 1) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    if (_segControl.selectedSegmentIndex == 2) {

    }
}

- (void)pressList {
    
}

- (void)pressCharacters {
    VCDiaryAdd* vcDiaryAdd = [[VCDiaryAdd alloc] init];
    [self.navigationController pushViewController:vcDiaryAdd animated:YES];
}

- (void)pressCamera {
    VCCamera* vcCamera = [[VCCamera alloc] init];
    [self.navigationController pushViewController:vcCamera animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [_arrayDay removeAllObjects];
    [_arrayMonth removeAllObjects];
    [_arrayWeek removeAllObjects];
    [_arrayTitle removeAllObjects];
    [_arrayContent removeAllObjects];
    [_arrayID removeAllObjects];
    NSString* strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/datebase.db"];
    _mDB = [[FMDatabase alloc] initWithPath:strPath];
    if ([_mDB open]) {
        NSString* strQuery = @"select * from diary order by id desc;";
        FMResultSet* result = [_mDB executeQuery:strQuery];
        while ([result next]) {
            NSString* _month = [result stringForColumn:@"month"];
            NSString* _day = [result stringForColumn:@"day"];
            NSString* _week = [result stringForColumn:@"week"];
            NSString* _title = [result stringForColumn:@"title"];
            NSString* _content = [result stringForColumn:@"content"];
            NSInteger _id = [result intForColumn:@"id"];
            [_arrayDay addObject:_day];
            [_arrayMonth addObject:_month];
            [_arrayWeek addObject:_week];
            [_arrayTitle addObject:_title];
            [_arrayContent addObject:_content];
            [_arrayID addObject:[NSNumber numberWithInteger:_id]];
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
