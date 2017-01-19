//
//  ElementViewController.m
//  MyDiary
//
//  Created by Wujianyun on 18/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "ElementViewController.h"
#import "myTableViewCell.h"
#import "Element.h"
#import "ElementPage.h"
#import "TimeDealler.h"
@interface ElementViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ElementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMyTableView];
    [self divideIntoGroupsAccordingToMonth];
    
    //假数据
    Element * eleForExample=[[Element alloc]init];
    [eleForExample setDate:[TimeDealler getCurrentDate]];
    [eleForExample setDates];
    [eleForExample setTime:[TimeDealler getCurrentTime]];
    [eleForExample setContent:@"今天很开心哦"];
    NSArray * arrEx=[[NSArray alloc]initWithObjects:eleForExample, nil];
    _elementForMonthArray=[[NSMutableArray alloc]init];
    [_elementForMonthArray addObject:arrEx];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)setMyTableView{
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setFrame:CGRectMake(0, 0, 375, 510)];
    [self.view addSubview:_tableView];
    UIImageView* backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1"]];
    [backgroundView setFrame:self.view.bounds];
    [_tableView setBackgroundView:backgroundView];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)divideIntoGroupsAccordingToMonth{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _elementForMonthArray[section].count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indetifier = @"myTableViewCell";
    
    myTableViewCell *cell = (myTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indetifier];
    
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"myTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    Element * ele=_elementForMonthArray[indexPath.section][indexPath.row];
    [cell setElement:ele];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _elementForMonthArray.count;
}// Default is 1 if not implemented

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    Element * ele= _elementForMonthArray[section][0];
    NSString * month=[ele.month stringByAppendingString:@"月"];
    return month;
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
