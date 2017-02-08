//
//  DiaryViewController.m
//  MyDiary
//
//  Created by Wujianyun on 18/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "DiaryViewController.h"
#import "diaryTableViewCell.h"
#import "Diary.h"
#import "DiaryPage.h"
#import "TimeDealler.h"
#import "UIColorCategory.h"
#import "DateDeal.h"

@interface DiaryViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DiaryViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadDate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _cellHeights = [[NSMutableArray alloc]init];
    [self setMyTableView];
    
    // Do any additional setup after loading the view.
}
- (void)reloadDate {
    _diaryForMonthArray=[DateDeal dateDealFor:ViewControllerDiary andDate:nil];
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setMyTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,_tableViewHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    UIImageView* backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1"]];
    [backgroundView setFrame:self.view.bounds];
    [_tableView setBackgroundView:backgroundView];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_tableView.rowHeight=UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight=Iphone6ScaleHeight(200);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_diaryForMonthArray.count) {
        _monthArr=[[NSMutableArray alloc]init];
        //NSLog(@"_diaryForMonthArray.count:%lu",(unsigned long)_diaryForMonthArray.count);
        NSInteger numOfSection=0;
        for(int i=1;i<13;i++) {
            NSArray *arr=_diaryForMonthArray[i-1];
            if(arr.count) {
                numOfSection++;
                //NSLog(@"%d",i);
                [_monthArr addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        //NSLog(@"numOfSection:%ld",(long)numOfSection);
        return numOfSection;
    }
    return _diaryForMonthArray.count;
}// Default is 1 if not implemented

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"[_monthArr[section] integerValue]:%ld",(long)[_monthArr[section] integerValue]);
    //NSLog(@"_diaryForMonthArray[[_monthArr[section] integerValue]-1].count:%ld",(long) _diaryForMonthArray[[_monthArr[section] integerValue]-1].count);
    return _diaryForMonthArray[[_monthArr[section] integerValue]-1].count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indetifier = @"myTableViewCell";
    
    diaryTableViewCell *cell = (diaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indetifier];
    
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"diaryTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    Diary *diary=_diaryForMonthArray[[_monthArr[indexPath.section] integerValue]-1][indexPath.row];
    [cell setDiary:diary];
    if(!(_cellHeights.count>indexPath.section)){
        NSMutableArray * arr=[[NSMutableArray alloc]init];
        [arr addObject:[NSString stringWithFormat:@"%ld",(long)cell.height]];
        [_cellHeights addObject:arr];
    }else if (_cellHeights[indexPath.section].count>indexPath.row) {
        [_cellHeights[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%ld",(long)cell.height]];
    }else {
        [_cellHeights[indexPath.section] addObject:[NSString stringWithFormat:@"%ld",(long)cell.height]];
    }
    //NSLog(@"diaryCellForRowAtIndexPath");
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *month=_monthArr[section];
    month=[month stringByAppendingString:@"月"];
    return month;
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"DiaryHeightForRowAtIndexPath" );
    NSString * height=(NSString *)_cellHeights[indexPath.section][indexPath.row];
    //NSLog(@"%@",height);
    return [height floatValue];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Iphone6ScaleHeight(40);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Diary * diary =_diaryForMonthArray[[_monthArr[indexPath.section] integerValue]-1][indexPath.row];
    [self.delegate turnToDiaryPage:diary];
    //NSLog(@"DiaryDidSelectRowAtIndexPath");
    NSArray * arr=[[NSArray alloc]initWithObjects:indexPath, nil];
    [_tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationMiddle];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Diary * diary=_diaryForMonthArray[[_monthArr[indexPath.section] integerValue]-1][indexPath.row];
    [diary deleteDiary];
    [_diaryForMonthArray[[_monthArr[indexPath.section] integerValue]-1] removeObjectAtIndex:indexPath.row];
    [self reloadDate];
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
