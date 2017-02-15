//
//  VCDiary.m
//  MyDiary02
//
//  Created by 向尉 on 2017/1/20.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "VCDiary.h"
#import "VCProject.h"
#import "VCDiaryWrite.h"
#import "MyTableViewCell.h"
#import "PDTSimpleCalendarViewFlowLayout.h"
#import "PDTSimpleCalendarViewController.h"
#import "FMDatabase.h"
#import "TableViewCellDataSource.h"



@interface VCDiary ()

@end

@implementation VCDiary

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.seg setSelectedSegmentIndex:2];
    [self.seg addTarget:self action:@selector(chooseSeg:) forControlEvents:UIControlEventValueChanged];
    [self.labView setText:@"DIARY"];
    self.diaries=[[NSMutableArray alloc]init];
    //load diaries from file
    [self loadDiaries];
    //set toolBatItem
    UIButton *btnInToolBarBtn01=[self.toolBtn01 customView];
    [btnInToolBarBtn01 addTarget:self action:@selector(pressToolBtn01) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btnInToolBarBtn02=[self.toolBtn02 customView];
    [btnInToolBarBtn02 addTarget:self action:@selector(pressToolBtn02) forControlEvents:UIControlEventTouchUpInside];
    UILabel *labInToolBarBtn05=[self.toolBtn05 customView];
    labInToolBarBtn05.text=[NSString stringWithFormat:@"%ld日记",self.diaries.count];
    //set tableView
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.frame.size.width-60, self.view.frame.size.height-75) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setAllowsMultipleSelectionDuringEditing:YES];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    UILabel *labMonth=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 40, 30)];
    NSDate *currentTime=[NSDate date];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components=[calendar components:NSCalendarUnitMonth fromDate:currentTime];
    labMonth.text=[NSString stringWithFormat:@"%ld月",[components month]];
    [self.tableView setTableHeaderView:labMonth];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCell"];
    //set navigationBarItem
    self.deleteBtn=[[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(pressDelete)];
    self.finishBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(pressFinish)];
}
//
-(void)pressToolBtn01
{
    [self setTitle:@"编辑"];
    [self.navigationItem setRightBarButtonItem:self.finishBtn];
    [self.navigationItem setLeftBarButtonItem:self.deleteBtn];
    [self.navigationItem setTitleView:nil];
    [self.tableView setEditing:YES];
}
//
-(void)pressToolBtn02
{
    if (self.tableView.editing==NO)
    {
        VCDiaryWrite *diaryWrite=[[VCDiaryWrite alloc]init];
        [diaryWrite setDelegate:self];
        diaryWrite.textView=[[UITextView alloc]initWithFrame:CGRectMake(5, 20, diaryWrite.view.frame.size.width-10, diaryWrite.view.frame.size.height-150)];
        [diaryWrite.view addSubview:diaryWrite.textView];
        [diaryWrite.textView becomeFirstResponder];
        [diaryWrite.textView setFont:[UIFont systemFontOfSize:16]];
        [diaryWrite.textView setText:@"开始记录你的生活吧"];
        diaryWrite.textView.layer.borderColor=[[UIColor colorWithRed:105/255.0 green:215/255.0 blue:221/255.0 alpha:1.0] CGColor];
        [diaryWrite.textView.layer setBorderWidth:1];
        [diaryWrite.textView.layer setMasksToBounds:YES];
        [diaryWrite.textView.layer setCornerRadius:10];
        [self.navigationController pushViewController:diaryWrite animated:YES];
    }
}
//
-(void)chooseSeg:(UISegmentedControl *) segmentedControl
{
    if (self.seg.selectedSegmentIndex == 0)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else if(self.seg.selectedSegmentIndex == 1)
    {
        NSArray *viewControllers=[self.navigationController viewControllers];
        if ([[viewControllers objectAtIndex:viewControllers.count-2] isKindOfClass:[VCProject class]])
        {
            PDTSimpleCalendarViewFlowLayout *layout=[[PDTSimpleCalendarViewFlowLayout alloc]init];
            PDTSimpleCalendarViewController *daily=[[PDTSimpleCalendarViewController alloc] initWithCollectionViewLayout:layout];
            [self.navigationController pushViewController:daily animated:NO];
            [self.seg setSelectedSegmentIndex:2];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
}
//
-(void)pressDelete
{
    NSArray *selectedIndexes=[self.tableView indexPathsForSelectedRows];
    NSString *dataBasePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/MyDiary02"];
    self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
    if (self.dataBase != nil)
    {
        [self.dataBase open];
        NSMutableArray *subArray=[[NSMutableArray alloc]init];
        for (int k=0; k<selectedIndexes.count; ++k)
        {
            NSIndexPath *indexInSelectedIndexes=[selectedIndexes objectAtIndex:k];
            [subArray addObject:[self.diaries objectAtIndex:indexInSelectedIndexes.row+indexInSelectedIndexes.section]];
            TableViewCellDataSource *data=[self.diaries objectAtIndex:indexInSelectedIndexes.row+indexInSelectedIndexes.section];
            NSDate *currentTime=[NSDate date];
            NSCalendar *calendar=[NSCalendar currentCalendar];
            NSDateComponents *components=[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentTime];
            NSString *tableName=[NSString stringWithFormat:@"diariesInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
            NSString *strDelete=[NSString stringWithFormat:@"delete from %@ where diary='%@' and hour=%ld and minute=%ld and place='%@';",tableName,data.text,data.hour,data.minute,data.place];
            BOOL isDelete=[self.dataBase executeUpdate:strDelete];
            NSLog(@"%d",isDelete);
        }
        [self.diaries removeObjectsInArray:subArray];
        [self.dataBase close];
    }
    UILabel *label=[self.toolBtn05 customView];
    label.text=[NSString stringWithFormat:@"%ld日记",self.diaries.count];
    [self.tableView reloadData];
    [self pressFinish];
}
//
-(void)pressFinish
{
    [self setTitle:@"编辑"];
    [self.tableView setEditing:NO];
    [self.navigationItem setRightBarButtonItem:nil];
    [self.navigationItem setLeftBarButtonItem:nil];
    [self.centreView setFrame:self.navigationController.navigationBar.frame];
    [self.navigationItem setTitleView:self.centreView];
}
//
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.diaries.count;
}
//
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (cell==nil)
    {
        cell=[[NSBundle mainBundle]loadNibNamed:@"MyTableViewCell" owner:nil options:nil].firstObject;
    }
    TableViewCellDataSource *data=[self.diaries objectAtIndex:indexPath.row+indexPath.section];
    NSDate *currentTime=[NSDate date];
    cell.labTime.text=[NSString stringWithFormat:@"%02ld:%02ld",data.hour,data.minute];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components=[calendar components:NSCalendarUnitDay fromDate:currentTime];
    cell.labDate.text=[NSString stringWithFormat:@"%ld",[components day]];
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:cell.labDate.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer =[[CAShapeLayer alloc]init];
    maskLayer.frame=cell.labDate.bounds;
    maskLayer.path=maskPath.CGPath;
    cell.labDate.layer.mask=maskLayer;
    [cell.labPlace setText:data.place];
    [cell.labContent setText:data.text];
    [cell.layer setMasksToBounds:YES];
    [cell.layer setCornerRadius:10];
    return cell;
}
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}
//
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
    //return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//}
//
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dataBasePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/MyDiary02"];
    self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
    if (self.dataBase != nil)
    {
        [self.dataBase open];
        TableViewCellDataSource *data=[self.diaries objectAtIndex:indexPath.row+indexPath.section];
        NSDate *currentTime=[NSDate date];
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components=[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentTime];
        NSString *tableName=[NSString stringWithFormat:@"diariesInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
        NSString *strDelete=[NSString stringWithFormat:@"delete from %@ where diary='%@' and hour=%ld and minute=%ld and place='%@';",tableName,data.text,data.hour,data.minute,data.place];
        BOOL isDelete=[self.dataBase executeUpdate:strDelete];
        NSLog(@"%d",isDelete);
        [self.dataBase close];
    }
    [self.diaries removeObjectAtIndex:indexPath.row+indexPath.section];
    [self.tableView reloadData];
    UILabel *label=[self.toolBtn05 customView];
    label.text=[NSString stringWithFormat:@"%ld日记",self.diaries.count];
}
//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing==NO)
    {
        VCDiaryWrite *diaryShow=[[VCDiaryWrite alloc]init];
        [diaryShow setDelegate:self];
        diaryShow.textView=[[UITextView alloc]initWithFrame:CGRectMake(5, 20, diaryShow.view.frame.size.width-10, diaryShow.view.frame.size.height-150)];
        [diaryShow.view addSubview:diaryShow.textView];
        diaryShow.textView.layer.borderColor=[[UIColor colorWithRed:105/255.0 green:215/255.0 blue:221/255.0 alpha:1.0] CGColor];
        [diaryShow.textView.layer setBorderWidth:1];
        [diaryShow.textView.layer setMasksToBounds:YES];
        [diaryShow.textView.layer setCornerRadius:10];
        [diaryShow.textView becomeFirstResponder];
        [diaryShow.textView setFont:[UIFont systemFontOfSize:16]];
        TableViewCellDataSource *data=[self.diaries objectAtIndex:indexPath.row+indexPath.section];
        [diaryShow setOriginData:data];
        [diaryShow.textView setText:data.text];
        [self.navigationController pushViewController:diaryShow animated:YES];
    }
}
//
#pragma mark - VCDiaryWrite Delegate
-(void)addDiary:(TableViewCellDataSource *)data
{
    [self.diaries addObject:data];
    [self.tableView reloadData];
    UILabel *lableInToolBtn05=[self.toolBtn05 customView];
    lableInToolBtn05.text=[NSString stringWithFormat:@"%ld日记",self.diaries.count];
    NSString *dataBasePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/MyDiary02"];
    self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
    if (self.dataBase != nil)
    {
        [self.dataBase open];
        NSDate *currentTime=[NSDate date];
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components=[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentTime];
        NSString *tableName=[NSString stringWithFormat:@"diariesInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
        NSString *strInsert=[NSString stringWithFormat:@"insert into %@ values(%ld,%ld,'%@','%@');",tableName,data.hour,data.minute,data.text,data.place];
        BOOL isAdd=[self.dataBase executeUpdate:strInsert];
        if (isAdd)
        {
            NSLog(@"added");
        }
        [self.dataBase close];
    }
}
//
-(void)changeDiary:(TableViewCellDataSource *)data
{
    NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
    MyTableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.labContent setText:data.text];
    TableViewCellDataSource *originData=[self.diaries objectAtIndex:indexPath.row+indexPath.section];
    NSString *dataBasePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/MyDiary02"];
    self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
    if (self.dataBase != nil)
    {
        [self.dataBase open];
        NSDate *currentTime=[NSDate date];
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components=[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentTime];
        NSString *tableName=[NSString stringWithFormat:@"diariesInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
        NSString *strUpdate=[NSString stringWithFormat:@"update %@ set diary='%@',hour=%ld,minute=%ld where diary='%@' and hour=%ld and minute=%ld and place='%@';",tableName,data.text,data.hour,data.minute,originData.text,originData.hour,originData.minute,originData.place];
        BOOL isUpDated=[self.dataBase executeUpdate:strUpdate];
        NSLog(@"%d",isUpDated);
        [self.dataBase close];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//
-(void)deleteDiary
{
    if (self.diaries.count!=0)
    {
        NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
        TableViewCellDataSource *data=[self.diaries objectAtIndex:indexPath.row+indexPath.section];
        NSString *dataBasePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/MyDiary02"];
        self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
        if (self.dataBase != nil)
        {
            [self.dataBase open];
            NSDate *currentTime=[NSDate date];
            NSCalendar *calendar=[NSCalendar currentCalendar];
            NSDateComponents *components=[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentTime];
            NSString *tableName=[NSString stringWithFormat:@"diariesInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
            NSString *strDelete=[NSString stringWithFormat:@"delete from %@ where diary='%@' and hour=%ld and minute=%ld and place='%@';",tableName,data.text,data.hour,data.minute,data.place];
            BOOL isDelete=[self.dataBase executeUpdate:strDelete];
            NSLog(@"%d",isDelete);
            [self.dataBase close];
        }
        [self.diaries removeObjectAtIndex:indexPath.row+indexPath.section];
        [self.tableView reloadData];
        UILabel *label=[self.toolBtn05 customView];
        label.text=[NSString stringWithFormat:@"%ld日记",self.diaries.count];
    }
}
//
//read Diaries from Sqlite dataBase
-(void)loadDiaries
{
    NSString *dataBasePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/MyDiary02"];
    self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
    if (self.dataBase != nil)
    {
        [self.dataBase open];
        NSDate *currentTime=[NSDate date];
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components=[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentTime];
        NSString *tableName=[NSString stringWithFormat:@"diariesInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
        NSString *strCreateTable=[NSString stringWithFormat:@"create table if not exists %@(hour integer,minute integer,diary varchar(500),place varchar(50));",tableName];
        BOOL isExecuted=[self.dataBase executeUpdate:strCreateTable];
        if (isExecuted)
        {
            NSLog(@"Excuted");
            NSString *strQuery=[NSString stringWithFormat:@"select * from %@;",tableName];
            FMResultSet *resultForProjects=[self.dataBase executeQuery:strQuery];
            while ([resultForProjects next])
            {
                TableViewCellDataSource *data=[[TableViewCellDataSource alloc]initWithText:[resultForProjects stringForColumn:@"diary"] Hour:[resultForProjects intForColumn:@"hour"] Minute:[resultForProjects intForColumn:@"minute"] Place:[resultForProjects stringForColumn:@"place"]];
                [self.diaries addObject:data];
            }
            [self.dataBase close];
        }
    }
    else
    {
        NSLog(@"database falied");
    }
}
//
-(void)deleteTable
{
    NSString *dataBasePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/MyDiary02"];
    self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
    [self.dataBase open];
    NSDate *currentTime=[NSDate date];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components=[calendar components:NSCalendarUnitYear fromDate:currentTime];
    NSString *tableName=[NSString stringWithFormat:@"diariesInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
    NSString *str=[NSString stringWithFormat:@"DROP TABLE %@",tableName];
    BOOL isdelete=[self.dataBase executeUpdate:str];
    NSLog(@"%d",isdelete);
    [self.dataBase close];
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
