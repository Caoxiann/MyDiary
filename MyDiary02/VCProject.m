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
    //
    if (self.projects.count==0)
    {
        
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
        projWrite.textView=[[UITextView alloc]initWithFrame:CGRectMake(5, 20, projWrite.view.frame.size.width, projWrite.view.frame.size.height)];
        [projWrite.textView setText:@"写下你的计划吧"];
        [projWrite.view addSubview:projWrite.textView];
        [projWrite.textView becomeFirstResponder];
        [projWrite.textView setFont:[UIFont systemFontOfSize:16]];
        [projWrite setDelegate:self];
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
        [daily setProjects:self.projects];
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
#pragma datasource in tableview
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
    cell.labContent.text=[self.projects objectAtIndex:indexPath.row+indexPath.section];
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
        projShow.textView=[[UITextView alloc]initWithFrame:CGRectMake(5, 20, projShow.view.frame.size.width, projShow.view.frame.size.height)];
        [projShow.view addSubview:projShow.textView];
        [projShow.textView setFont:[UIFont systemFontOfSize:16]];
        projShow.textView.text=[self.projects objectAtIndex:indexPath.row+indexPath.section];
        [projShow.textView becomeFirstResponder];
        [self.navigationController pushViewController:projShow animated:YES];
    }
}
//
-(void)addProject:(NSString *)text
{
    [self.projects addObject:text];
    [self.tableView reloadData];
    UILabel *lableInToolBtn05=[self.toolBtn05 customView];
    lableInToolBtn05.text=[NSString stringWithFormat:@"%ld项目",self.projects.count];
}
//
-(void)changeProject:(NSString *)text
{
    NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
    MyTableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.labContent setText:text];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//
-(void)deleteProject
{
    if (self.projects.count!=0)
    {
        NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
        [self.projects removeObjectAtIndex:indexPath.row+indexPath.section];
        [self.tableView reloadData];
        UILabel *label=[self.toolBtn05 customView];
        label.text=[NSString stringWithFormat:@"%ld日记",self.projects.count];
    }
}
//
-(void)loadProjects
{
    /*if (<#condition#>) {
        <#statements#>
    }
    else
    {
    
    }*/
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
