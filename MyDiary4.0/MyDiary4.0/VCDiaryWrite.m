//
//  VCDiaryWrite.m
//  MyDiary02
//
//  Created by 向尉 on 2017/1/20.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "VCDiaryWrite.h"
#import "TableViewCellDataSource.h"

@interface VCDiaryWrite ()

@end

@implementation VCDiaryWrite

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //set navigationItem.
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(pressFinishBtn)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
}
//
-(void)viewWillAppear:(BOOL)animated
{
    if ([self.textView.text isEqualToString:@"开始记录你的生活吧"])
    {
        [self doWithoutText];
    }
    else
    {
        [self doWithText];
    }
}
//if the textview is "开始记录你的生活吧",new a diary
-(void)doWithoutText
{
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(pressBackBtnWithoutText)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    //set toolBarItems
    UIBarButtonItem *trashBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(pressTrashWithoutText)];
    UIBarButtonItem *centreBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *addBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pressAdd)];
    UIBarButtonItem *itemActionBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pressAction)];
    NSArray *toolBarItems=[NSArray arrayWithObjects:trashBtn, centreBtn, addBtn, centreBtn, itemActionBtn,nil];
    [self setToolbarItems:toolBarItems];
}
//if the textView has origin text,do something with the text
-(void)doWithText
{
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(pressBackBtnWithText)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    //set toolBarItems
    UIBarButtonItem *trashBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(pressTrashWithText)];
    UIBarButtonItem *centreBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *addBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pressAdd)];
    UIBarButtonItem *itemActionBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pressAction)];
    NSArray *toolBarItems=[NSArray arrayWithObjects:trashBtn, centreBtn, addBtn, centreBtn, itemActionBtn,nil];
    [self setToolbarItems:toolBarItems];
}
//
-(void)pressBackBtnWithoutText
{
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.textView.text isEqualToString:@"开始记录你的生活吧"] ||
        [self.textView.text isEqualToString:@""])
    {
        return;
    }
    else
    {
        NSDate *currentTime=[NSDate date];
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components=[calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay fromDate:currentTime];
        TableViewCellDataSource *data=[[TableViewCellDataSource alloc]initWithText:self.textView.text Day:[components day] Hour:[components hour] Minute:[components minute] Place:@" 四川成都"];
        [self.delegate addDiary:data];
    }
}
//
-(void)pressBackBtnWithText
{
    if ([self.textView.text isEqualToString:@""])
    {
        [self pressTrashWithText];
        return;
    }
    TableViewCellDataSource *data=[[TableViewCellDataSource alloc]initWithText:self.textView.text Day:self.originData.day Hour:self.originData.hour Minute:self.originData.minute Place:@"四川成都"];
    [self.delegate changeDiary:data];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pressFinishBtn
{
    [self.textView resignFirstResponder];
}

-(void)pressTrashWithoutText
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pressTrashWithText
{
    [self.delegate deleteDiary];
}

-(void)pressAdd
{

}

-(void)pressAction
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
