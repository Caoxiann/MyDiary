//
//  ElementsDetails.m
//  My Diary
//
//  Created by 徐贤达 on 2017/1/28.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import "ElementsDetails.h"
#import "ElementsDetails.h"

@interface ElementsDetails ()

@end

@implementation ElementsDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor grayColor];
    
    //创建工具栏UIToolBar对象
    self.navigationController.navigationBar.hidden=YES;
    UIColor *color2=[UIColor colorWithRed:0 green:191/255.0 blue:255/255.0 alpha:1.0];
    UIToolbar *toolbar=[[UIToolbar alloc]init];
    self.navigationController.toolbar.hidden=NO;
    self.navigationController.toolbar.translucent=NO;
    toolbar.frame=CGRectMake(0,deviceHeight*93/100,deviceWidth,deviceHeight*7/100);
    toolbar.barTintColor=color2;
    
    //创建工具栏按钮UIBarButtonItem对象
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(0, 0,15, 15);
    [btn1 setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn01=[[UIBarButtonItem alloc]initWithCustomView:btn1];
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(0, 0, 15, 15);
    [btn2 setImage:[UIImage imageNamed:@"characters.png"] forState:UIControlStateNormal];
    UIBarButtonItem *btn02=[[UIBarButtonItem alloc]initWithCustomView:btn2];
    UIButton *btn3=[UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame=CGRectMake(0, 0, 15, 15);
    [btn3 setImage:[UIImage imageNamed:@"camera.jpg"] forState:UIControlStateNormal];
    UIBarButtonItem *btn03=[[UIBarButtonItem alloc]initWithCustomView:btn3];
    UIBarButtonItem *btnZ=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    [btnZ setWidth:20];
    UIBarButtonItem *btnX=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    [btnX setWidth:deviceWidth*37/100];
    UIButton *btn4=[UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame=CGRectMake(deviceWidth*77/100,deviceHeight*95.2/100,15,15);
    [btn4 setImage:[UIImage imageNamed:@"item.png"] forState:UIControlStateNormal];
    NSArray *array=[NSArray arrayWithObjects:btn01,btnZ,btn02,btnZ,btn03,nil];
    toolbar.items=array;
    [self.view addSubview:toolbar];
    [self.view addSubview:btn4];

    
    // Do any additional setup after loading the view.
}

-(void)pressBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
