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



@interface VCDiary ()

@end

@implementation VCDiary

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.seg setSelectedSegmentIndex:2];[self.seg addTarget:self action:@selector(chooseSeg:) forControlEvents:UIControlEventValueChanged];
    [self.labView setText:@"DIARY"];
    self.diaries=[[NSMutableArray alloc]init];
    //load diaries from file
    [self loadDiaries];
    if (self.diaries.count==0) {
        
    }
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
    if (self.tableView.editing==NO) {
        VCDiaryWrite *diaryWrite=[[VCDiaryWrite alloc]init];
        [diaryWrite setDelegate:self];
        diaryWrite.textView=[[UITextView alloc]initWithFrame:CGRectMake(5, 20, diaryWrite.view.frame.size.width, diaryWrite.view.frame.size.height)];
        [diaryWrite.view addSubview:diaryWrite.textView];
        [diaryWrite.textView becomeFirstResponder];
        [diaryWrite.textView setFont:[UIFont systemFontOfSize:16]];
        [diaryWrite.textView setText:@"开始记录你的生活吧"];
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
    self.diaries=[[NSMutableArray alloc]init];
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
    NSDate *currentTime=[NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *locationString=[dateFormatter stringFromDate:currentTime];
    [cell.labTime setText:locationString];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components=[calendar components:NSCalendarUnitDay fromDate:currentTime];
    cell.labDate.text=[NSString stringWithFormat:@"%ld",[components day]];
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:cell.labDate.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer =[[CAShapeLayer alloc]init];
    maskLayer.frame=cell.labDate.bounds;
    maskLayer.path=maskPath.CGPath;
    cell.labDate.layer.mask=maskLayer;
    [cell.labPlace setText:@"四川成都"];
    cell.labContent.text=[self.diaries objectAtIndex:indexPath.row+indexPath.section];
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
        diaryShow.textView=[[UITextView alloc]initWithFrame:CGRectMake(5, 20, diaryShow.view.frame.size.width, diaryShow.view.frame.size.height)];
        [diaryShow.view addSubview:diaryShow.textView];
        [diaryShow.textView becomeFirstResponder];
        [diaryShow.textView setFont:[UIFont systemFontOfSize:16]];
        diaryShow.textView.text=[self.diaries objectAtIndex:indexPath.row+indexPath.section];
        [self.navigationController pushViewController:diaryShow animated:YES];
    }
}
//
-(void)addDiary:(NSString *)text
{
    [self.diaries addObject:text];
    [self.tableView reloadData];
    UILabel *lableInToolBtn05=[self.toolBtn05 customView];
    lableInToolBtn05.text=[NSString stringWithFormat:@"%ld日记",self.diaries.count];
}
//
-(void)changeDiary:(NSString *)text
{
    NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
    MyTableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.labContent setText:text];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//
-(void)deleteDiary
{
    if (self.diaries.count!=0)
    {
        NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
        [self.diaries removeObjectAtIndex:indexPath.row+indexPath.section];
        [self.tableView reloadData];
        UILabel *label=[self.toolBtn05 customView];
        label.text=[NSString stringWithFormat:@"%ld日记",self.diaries.count];
    }
}
//
//
-(void)loadDiaries
{

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
