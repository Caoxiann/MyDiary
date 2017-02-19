//
//  VCProject.m
//  MyDiary02
//
//  Created by 向尉 on 2017/1/20.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "VCProject.h"
#import "VCDiary.h"
#import "VCProjectWrite.h"
#import "PDTSimpleCalendarViewController.h"
#import "PDTSimpleCalendarViewFlowLayout.h"
#import "MyTableViewCell.h"
#import "TableViewCellDataSource.h"
#import "FMDatabase.h"



@interface VCProject ()

@end

@implementation VCProject

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.seg setSelectedSegmentIndex:0];
    [self.seg addTarget:self action:@selector(chooseSeg:) forControlEvents:UIControlEventValueChanged];
    [self.labView setText:@"ELEMENTS"];
    //set toolBarItem
    UIButton *btnInToolBarBtn01=[self.toolBtn01 customView];
    [btnInToolBarBtn01 addTarget:self action:@selector(pressToolBtn01) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btnInToolBarBtn02=[self.toolBtn02 customView];
    [btnInToolBarBtn02 addTarget:self action:@selector(pressToolBtn02) forControlEvents:UIControlEventTouchUpInside];
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
    //set navigationBarItems
    self.deleteBtn=[[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(pressDelete)];
    self.finishBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(pressFinish)];
    //
    self.projects=[[NSMutableArray alloc]init];
    //load projects from file
    [self loadProjects];
    //[self deleteTable];
    //
    if (self.projects.count==0)
    {
        UIAlertView *noProjectAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你今天还未制定计划" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"新建项目" ,nil];
        [noProjectAlert show];
    }
    UILabel *labInToolBarBtn05=[self.toolBtn05 customView];
    labInToolBarBtn05.text=[NSString stringWithFormat:@"%ld项目",self.projects.count];
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
        VCProjectWrite *projWrite=[[VCProjectWrite alloc]init];
        projWrite.textView=[[UITextView alloc]initWithFrame:CGRectMake(5, 20, projWrite.view.frame.size.width-10, projWrite.view.frame.size.height/2)];
        [projWrite.textView setText:@"写下你的计划吧"];
        [projWrite.view addSubview:projWrite.textView];
        //[projWrite.textView becomeFirstResponder];
        [projWrite.textView setFont:[UIFont systemFontOfSize:16]];
        projWrite.textView.layer.borderColor=[[UIColor colorWithRed:105/255.0 green:215/255.0 blue:221/255.0 alpha:1.0] CGColor];
        [projWrite.textView.layer setBorderWidth:1];
        [projWrite.textView.layer setMasksToBounds:YES];
        [projWrite.textView.layer setCornerRadius:10];
        [projWrite setDelegate:self];
        projWrite.timePicker=[[UIPickerView alloc]initWithFrame:CGRectMake(5, 40+projWrite.view.frame.size.height/2, projWrite.view.frame.size.width-10, projWrite.view.frame.size.height/2-200)];
        [projWrite.view addSubview:projWrite.timePicker];
        [projWrite.timePicker setDelegate:projWrite];
        UILabel *tipLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 10+projWrite.view.frame.size.height/2, 80, 40)];
        //[tipLab setFont:[UIFont systemFontOfSize:15]];
        [tipLab setText:@"执行时间"];
        [projWrite.view addSubview:tipLab];
        [self.navigationController pushViewController:projWrite animated:YES];
    }
}
//
-(void)chooseSeg:(UISegmentedControl *) segmentedControl
{
    if (segmentedControl.selectedSegmentIndex == 1)
    {
        PDTSimpleCalendarViewFlowLayout *layout=[[PDTSimpleCalendarViewFlowLayout alloc]init];
        PDTSimpleCalendarViewController *daily=[[PDTSimpleCalendarViewController alloc] initWithCollectionViewLayout:layout];
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
            [subArray addObject:[self.projects objectAtIndex:indexInSelectedIndexes.row+indexInSelectedIndexes.section]];
            TableViewCellDataSource *data=[self.projects objectAtIndex:indexInSelectedIndexes.row+indexInSelectedIndexes.section];
            NSDate *currentTime=[NSDate date];
            NSCalendar *calendar=[NSCalendar currentCalendar];
            NSDateComponents *components=[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentTime];
            NSString *tableName=[NSString stringWithFormat:@"projectsInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
            NSString *strDelete=[NSString stringWithFormat:@"delete from %@ where project='%@' and hour=%ld and minute=%ld and place='%@';",tableName,data.text,data.hour,data.minute,data.place];
            BOOL isDelete=[self.dataBase executeUpdate:strDelete];
            NSLog(@"%d",isDelete);
        }
        [self.projects removeObjectsInArray:subArray];
        [self.dataBase close];
    }
    UILabel *label=[self.toolBtn05 customView];
    label.text=[NSString stringWithFormat:@"%ld日记",self.projects.count];
    [self.tableView reloadData];
    [self pressFinish];
}
//
-(void)pressFinish
{
    [self setTitle:nil];
    [self.tableView setEditing:NO];
    [self.navigationItem setRightBarButtonItem:nil];
    [self.navigationItem setLeftBarButtonItem:nil];
    [self.centreView setFrame:self.navigationController.navigationBar.frame];
    [self.navigationItem setTitleView:self.centreView];
}
//
#pragma tableview data source
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.projects.count;
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
    NSDate *currentTime=[NSDate date];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components=[calendar components:NSCalendarUnitDay fromDate:currentTime];
    cell.labDate.text=[NSString stringWithFormat:@"%ld",[components day]];
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:cell.labDate.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer =[[CAShapeLayer alloc]init];
    maskLayer.frame=cell.labDate.bounds;
    maskLayer.path=maskPath.CGPath;
    cell.labDate.layer.mask=maskLayer;
    TableViewCellDataSource *data=[self.projects objectAtIndex:indexPath.row+indexPath.section];
    [cell.labContent setText:data.text];
    cell.hour=data.hour;
    cell.minute=data.minute;
    cell.labTime.text=[NSString stringWithFormat:@"%02ld:%02ld",cell.hour,cell.minute];
    [cell.labPlace setText:data.place];
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
        TableViewCellDataSource *data=[self.projects objectAtIndex:indexPath.row+indexPath.section];
        NSDate *currentTime=[NSDate date];
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components=[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentTime];
        NSString *tableName=[NSString stringWithFormat:@"projectsInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
        NSString *strDelete=[NSString stringWithFormat:@"delete from %@ where project='%@' and hour=%ld and minute=%ld and place='%@';",tableName,data.text,data.hour,data.minute,data.place];
        BOOL isDelete=[self.dataBase executeUpdate:strDelete];
        NSLog(@"%d",isDelete);
        [self.dataBase close];
    }

    [self.projects removeObjectAtIndex:indexPath.row+indexPath.section];
    [self.tableView reloadData];
    UILabel *label=[self.toolBtn05 customView];
    label.text=[NSString stringWithFormat:@"%ld日记",self.projects.count];
}
//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing==NO)
    {
        VCProjectWrite *projShow=[[VCProjectWrite alloc]init];
        [projShow setDelegate:self];
        projShow.textView=[[UITextView alloc]initWithFrame:CGRectMake(5, 20, projShow.view.frame.size.width, projShow.view.frame.size.height/2)];
        [projShow.view addSubview:projShow.textView];
        [projShow.textView setFont:[UIFont systemFontOfSize:16]];
        //[projShow.textView becomeFirstResponder];
        projShow.timePicker=[[UIPickerView alloc]initWithFrame:CGRectMake(5, 40+projShow.view.frame.size.height/2, projShow.view.frame.size.width-5, projShow.view.frame.size.height/2-200)];
        [projShow.view addSubview:projShow.timePicker];
        [projShow.timePicker setDelegate:projShow];
        projShow.textView.layer.borderColor=[[UIColor colorWithRed:105/255.0 green:215/255.0 blue:221/255.0 alpha:1.0] CGColor];
        [projShow.textView.layer setBorderWidth:1];
        [projShow.textView.layer setMasksToBounds:YES];
        [projShow.textView.layer setCornerRadius:10];
        MyTableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        projShow.textView.text=cell.labContent.text;
        [projShow.timePicker selectRow:cell.hour inComponent:0 animated:NO];
        [projShow.timePicker selectRow:cell.minute inComponent:1 animated:NO];
        UILabel *tipLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 10+projShow.view.frame.size.height/2, 80, 40)];
        //[tipLab setFont:[UIFont systemFontOfSize:15]];
        [tipLab setText:@"执行时间"];
        [projShow.view addSubview:tipLab];
        [self.navigationController pushViewController:projShow animated:YES];
    }
}
//
#pragma mark-VCProject delegate
-(void)addProject:(TableViewCellDataSource *)data
{
    [self.projects addObject:data];
    [self.tableView reloadData];
    UILabel *lableInToolBtn05=[self.toolBtn05 customView];
    lableInToolBtn05.text=[NSString stringWithFormat:@"%ld项目",self.projects.count];
    NSString *dataBasePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/MyDiary02"];
    self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
    if (self.dataBase != nil)
    {
        [self.dataBase open];
        NSDate *currentTime=[NSDate date];
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components=[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentTime];
        NSString *tableName=[NSString stringWithFormat:@"projectsInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
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
-(void)changeProject:(TableViewCellDataSource *)data
{
    NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
    MyTableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.labContent setText:data.text];
    cell.hour=data.hour;
    cell.minute=data.minute;
    cell.labTime.text=[NSString stringWithFormat:@"%02ld:%02ld",cell.hour,cell.minute];
    TableViewCellDataSource *originData=[self.projects objectAtIndex:indexPath.row+indexPath.section];
    NSString *dataBasePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/MyDiary02"];
    self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
    if (self.dataBase != nil)
    {
        [self.dataBase open];
        NSDate *currentTime=[NSDate date];
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components=[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentTime];
        NSString *tableName=[NSString stringWithFormat:@"projectsInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
        NSString *strUpdate=[NSString stringWithFormat:@"update %@ set project='%@',hour=%ld,minute=%ld where project='%@' and hour=%ld and minute=%ld and place='%@';",tableName,data.text,data.hour,data.minute,originData.text,originData.hour,originData.minute,originData.place];
        BOOL isUpDated=[self.dataBase executeUpdate:strUpdate];
        NSLog(@"%d",isUpDated);
        [self.dataBase close];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//
-(void)deleteProject
{
    if (self.projects.count!=0)
    {
        NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
        TableViewCellDataSource *data=[self.projects objectAtIndex:indexPath.row+indexPath.section];
        NSString *dataBasePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/MyDiary02"];
        self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
        if (self.dataBase != nil)
        {
            [self.dataBase open];
            NSDate *currentTime=[NSDate date];
            NSCalendar *calendar=[NSCalendar currentCalendar];
            NSDateComponents *components=[calendar components:NSCalendarUnitDay fromDate:currentTime];
            NSString *tableName=[NSString stringWithFormat:@"projectsIn%ld",[components day]];
            NSString *strDelete=[NSString stringWithFormat:@"delete from %@ where project='%@' and hour=%ld and minute=%ld and place='%@';",tableName,data.text,data.hour,data.minute,data.place];
            BOOL isDelete=[self.dataBase executeUpdate:strDelete];
            NSLog(@"%d",isDelete);
            [self.dataBase close];
        }
        [self.projects removeObjectAtIndex:indexPath.row+indexPath.section];
        [self.tableView reloadData];
        UILabel *label=[self.toolBtn05 customView];
        label.text=[NSString stringWithFormat:@"%ld日记",self.projects.count];
    }
}
//read projects from Sqlite database
-(void)loadProjects
{
    NSString *dataBasePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/MyDiary02"];
    self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
    if (self.dataBase != nil)
    {
        [self.dataBase open];
        NSDate *currentTime=[NSDate date];
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components=[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentTime];
        NSString *tableName=[NSString stringWithFormat:@"projectsInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
        NSString *strCreateTable=[NSString stringWithFormat:@"create table if not exists %@(hour integer,minute integer,project varchar(500),place varchar(50));",tableName];
        BOOL isExecuted=[self.dataBase executeUpdate:strCreateTable];
        if (isExecuted)
        {
            NSLog(@"Excuted");
            NSString *strQuery=[NSString stringWithFormat:@"select * from %@;",tableName];
            FMResultSet *resultForProjects=[self.dataBase executeQuery:strQuery];
            while ([resultForProjects next])
            {
                TableViewCellDataSource *data=[[TableViewCellDataSource alloc]initWithText:[resultForProjects stringForColumn:@"project"] Hour:[resultForProjects intForColumn:@"hour"] Minute:[resultForProjects intForColumn:@"minute"] Place:[resultForProjects stringForColumn:@"place"]];
                [self.projects addObject:data];
            }
            [self.dataBase close];
        }
    }
    else
    {
        NSLog(@"database falied");
    }
}
//write projects into Sqlite database
-(void)deleteTable
{
    NSString *dataBasePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/MyDiary02"];
    self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
    [self.dataBase open];
    NSDate *currentTime=[NSDate date];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components=[calendar components:NSCalendarUnitYear fromDate:currentTime];
    NSString *tableName=[NSString stringWithFormat:@"projectsInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
    NSString *str=[NSString stringWithFormat:@"DROP TABLE %@",tableName];
    BOOL isdelete=[self.dataBase executeUpdate:str];
    NSLog(@"%d",isdelete);
    [self.dataBase close];
}
#pragma mark-AlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self pressToolBtn02];
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
