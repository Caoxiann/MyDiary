//
//  VCProjectWrite.m
//  MyDiary02
//
//  Created by 向尉 on 2017/1/20.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "VCProjectWrite.h"
#import "TableViewCellDataSource.h"

@interface VCProjectWrite ()

@end

@implementation VCProjectWrite

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //set navigationItem.
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(pressFinishBtn)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    [self.view addSubview:self.timePicker];
    [self.timePicker setDelegate:self];
}
//
-(void)viewDidAppear:(BOOL)animated
{
    if ([self.textView.text isEqualToString:@"写下你的计划吧"]) {
        [self doWithoutText];
    }
    else
    {
        [self doWithText];
    }
}
//
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
//
-(void)doWithoutText
{
    [self setTitle:@" 新建项目"];
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
//
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
    if ([self.textView.text isEqualToString:@"写下你的计划吧"] ||
        [self.textView.text isEqualToString:@""])
    {
        return;
    }
    else
    {
        TableViewCellDataSource *data=[[TableViewCellDataSource alloc]initWithText:self.textView.text Hour:[self.timePicker selectedRowInComponent:0] Minute:[self.timePicker selectedRowInComponent:1] Place:@"四川成都"];
        [self.delegate addProject:data];
    }
}
//
-(void)pressBackBtnWithText
{
    if ([self.textView.text isEqualToString:@""])
    {
        [self pressTrashWithText];
    }
    else
    {
        TableViewCellDataSource *data=[[TableViewCellDataSource alloc]initWithText:self.textView.text Hour:[self.timePicker selectedRowInComponent:0] Minute:[self.timePicker selectedRowInComponent:1] Place:@"四川成都"];
        [self.delegate changeProject:data];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
//
-(void)pressFinishBtn
{
    [self.textView resignFirstResponder];
}
//
-(void)pressTrashWithoutText
{
    [self.navigationController popViewControllerAnimated:YES];
}
//
-(void)pressTrashWithText
{
    [self.delegate deleteProject];
    [self.navigationController popViewControllerAnimated:YES];
}
//
-(void)pressAdd
{

}
//
-(void)pressAction
{

}
#pragma UIPickerView data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return 24;
    }
    else
    {
        return 60;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%02ld",row];
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
