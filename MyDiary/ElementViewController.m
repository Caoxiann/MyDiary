//
//  ElementViewController.m
//  MyDiary
//
//  Created by Wujianyun on 18/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "ElementViewController.h"
#import "myTableViewCell.h"
#import "ElementPage.h"
#import "TimeDealler.h"
#import "UIColorCategory.h"
#import "SqlService.h"

#define INITIALHEIGHT Iphone6ScaleHeight(100)
@interface ElementViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSString *numOfElements;

@end

@implementation ElementViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadDate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _cellHeights = [[NSMutableArray alloc]init];
    [self setMyTableView];

    // Do any additional setup after loading the view from its nib.
}

- (void)reloadDate {
    _elementForMonthArray=[self dateDeal];
    [self.delegate updateNumOfItems:_numOfElements];
    [_tableView reloadData];
}
- (NSMutableArray <__kindof NSMutableArray *> *)dateDeal{
    NSMutableArray <__kindof NSMutableArray *> *resultArr=[[NSMutableArray alloc]init];
    NSArray *array=[[SqlService sqlInstance] queryElementDBtable];
    if(array.count) {
        _numOfElements=[NSString stringWithFormat:@"%lu",array.count];
        for(int i=1;i<13;i++) {
            NSMutableArray *arr=[[NSMutableArray alloc]init];
            [resultArr addObject:arr];
        }
        for(Element * ele in array) {
            for(int i=1;i<13;i++){
                NSString * monthStr=[NSString stringWithFormat:@"%02d",i];
                if([ele.month isEqualToString:monthStr]) {
                    //NSLog(@"%@",monthStr);
                    [resultArr[i-1] addObject:ele];
                    break;
                }
            }
        }
    }else {
        _numOfElements=[NSString stringWithFormat:@"%d",0];
    }
    return resultArr;
}
-(void)setMyTableView{
    NSLog(@"%f",_tableViewHeight);
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,_tableViewHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    UIImageView* backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1"]];
    [backgroundView setFrame:self.view.bounds];
    [_tableView setBackgroundView:backgroundView];
   
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight=Iphone6ScaleHeight(100);
     
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_elementForMonthArray.count) {
        _monthArr=[[NSMutableArray alloc]init];
        //NSLog(@"_elementForMonthArray.count:%lu",(unsigned long)_elementForMonthArray.count);
        NSInteger numOfSection=0;
        for(int i=1;i<13;i++) {
            NSArray *arr=_elementForMonthArray[i-1];
            if(arr.count) {
                numOfSection++;
                 //NSLog(@"%d",i);
                [_monthArr addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
         //NSLog(@"numOfSection:%ld",(long)numOfSection);
        return numOfSection;
    }
    return _elementForMonthArray.count;
}// Default is 1 if not implemented

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     //NSLog(@"[_monthArr[section] integerValue]:%ld",(long)[_monthArr[section] integerValue]);
     //NSLog(@"_elementForMonthArray[[_monthArr[section] integerValue]-1].count:%ld",(long) _elementForMonthArray[[_monthArr[section] integerValue]-1].count);
    return _elementForMonthArray[[_monthArr[section] integerValue]-1].count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"ElementCellForRowAtIndexPath");
    static NSString *indetifier = @"myTableViewCell";
    
    myTableViewCell *cell = (myTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indetifier];
    
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"myTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    Element * ele=_elementForMonthArray[[_monthArr[indexPath.section] integerValue]-1][indexPath.row];
    [_elementForMonthArray[[_monthArr[indexPath.section] integerValue]-1] replaceObjectAtIndex:indexPath.row withObject:[cell setMyElement:ele]];
    ele=_elementForMonthArray[[_monthArr[indexPath.section] integerValue]-1][indexPath.row];
    if(ele.isSelected) {
        [cell drawDetailView];
        if(!(_cellHeights.count>indexPath.section)){
            NSMutableArray * arr=[[NSMutableArray alloc]init];
            [arr addObject:ele.cellHeight];
            [_cellHeights addObject:arr];
        }else if (_cellHeights[indexPath.section].count>indexPath.row) {
            [_cellHeights[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:ele.cellHeight];
        }else {
            [_cellHeights[indexPath.section] addObject:ele.cellHeight];
        }

    }else{
        [cell drawInitialView];
        if(!(_cellHeights.count>indexPath.section)){
            NSMutableArray * arr=[[NSMutableArray alloc]init];
            [arr addObject:[[NSString alloc]initWithFormat:@"%f",INITIALHEIGHT]];
            [_cellHeights addObject:arr];
        }else if (_cellHeights[indexPath.section].count>indexPath.row) {
            [_cellHeights[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:[[NSString alloc]initWithFormat:@"%f",INITIALHEIGHT]];
        }else {
            [_cellHeights[indexPath.section] addObject:[[NSString alloc]initWithFormat:@"%f",INITIALHEIGHT]];
        }

    }
    //[_cellHeights[_monthArr[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:cell.height];
    return cell;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *month=_monthArr[section];
    month=[month stringByAppendingString:@"月"];
    return month;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"ElementHeightForRowAtIndexPath" );
    NSString * height=(NSString *)_cellHeights[indexPath.section][indexPath.row];
    //NSLog(@"%@",height);
    return [height floatValue];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Iphone6ScaleHeight(40);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Element * element =_elementForMonthArray[[_monthArr[indexPath.section] integerValue]-1][indexPath.row];
    if([_cellHeights[indexPath.section][indexPath.row] isEqualToString:[[NSString alloc]initWithFormat:@"%f",INITIALHEIGHT]]){
        element.isSelected=YES;
    }else{
        element.isSelected=NO;
        [self.delegate turnToElementPage:element];
    }
    [_elementForMonthArray[[_monthArr[indexPath.section] integerValue]-1] replaceObjectAtIndex:indexPath.row withObject:element];
    //NSLog(@"ElementDidSelectRowAtIndexPath");
    //NSLog(@"%@",element.cellHeight);
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
    Element * ele=_elementForMonthArray[[_monthArr[indexPath.section] integerValue]-1][indexPath.row];
    [ele deleteElement];
    [_elementForMonthArray[[_monthArr[indexPath.section] integerValue]-1] removeObjectAtIndex:indexPath.row];
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
