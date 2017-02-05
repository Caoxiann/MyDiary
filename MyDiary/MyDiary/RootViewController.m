//
//  ViewController.m
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "RootViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self themeSetting];
    [self buildSegmentBar];
    [self buildToolBar];
    // Do any additional setup after loading the view, typically from a nib.
}
//主题设置
-(void)themeSetting {
    //主题颜色
    UIColor *blueThemeColor = [UIColor colorWithRed:107/255.0 green:183/255.0 blue:219/255.0 alpha:1];
    UIColor *redThemeColor = [UIColor colorWithRed:246/255.0 green:120/255.0 blue:138/255.0 alpha:1];
    _themeColor = blueThemeColor;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)buildSegmentBar {
    
    UISegmentedControl *baseSegmentBar = [[UISegmentedControl alloc]initWithFrame:CGRectMake(15, 30, [UIScreen mainScreen].bounds.size.width - 30, 25)];
    
    [baseSegmentBar setTintColor:_themeColor];
    
    [baseSegmentBar setMultipleTouchEnabled:YES];
    [baseSegmentBar setSelectedSegmentIndex:0];
    
    [baseSegmentBar insertSegmentWithTitle:@"Element" atIndex:0 animated:YES];
    [baseSegmentBar insertSegmentWithTitle:@"Calender" atIndex:1 animated:YES];
    [baseSegmentBar insertSegmentWithTitle:@"Diary" atIndex:2 animated:YES];
    
    
    [baseSegmentBar addTarget:self action:@selector(select:) forControlEvents:UIControlEventValueChanged];
    

    
    [self.view addSubview:baseSegmentBar];
}


-(void)select:(id)sender {
    UISegmentedControl* viewControl = (UISegmentedControl*) sender;
    switch (viewControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"0");
            break;
        case 1:
            NSLog(@"1");
            break;
        case 2:
            NSLog(@"2");
            break;
        default:
            NSLog(@"3");
            break;
    }
}

-(void)buildToolBar {
    //属性设置
    self.navigationController.navigationBar.hidden=YES;
    self.navigationController.toolbar.hidden=NO;
    self.navigationController.toolbar.translucent=NO;

    UIToolbar *baseToolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 50)];
    [baseToolbar setBarTintColor:_themeColor];
    
    //自定义按钮
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [listButton setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
    [listButton setFrame:CGRectMake(0, 0, 20, 20)];
    UIButton *charactersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [charactersButton setImage:[UIImage imageNamed:@"characters"] forState:UIControlStateNormal];
    [charactersButton setFrame:CGRectMake(0, 0, 20, 20)];
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [cameraButton setFrame:CGRectMake(0, 0, 20, 20)];
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton setImage:[UIImage imageNamed:@"item"] forState:UIControlStateNormal];
    [itemButton setFrame:CGRectMake(0, 0, 20, 20)];

    //[charactersButton addTarget:self.elements action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];

    //添加按钮到toolBar
    UIBarButtonItem *listBarButton = [[UIBarButtonItem alloc]initWithCustomView:listButton];
    UIBarButtonItem *itemBarButton = [[UIBarButtonItem alloc]initWithCustomView:itemButton];
    UIBarButtonItem *cameraBarButton = [[UIBarButtonItem alloc]initWithCustomView:cameraButton];
    UIBarButtonItem *charactersBarButton = [[UIBarButtonItem alloc]initWithCustomView:charactersButton];
    //间距修正
    UIBarButtonItem *blankBarButton1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    [blankBarButton1 setWidth:20];
    UIBarButtonItem *blankBarButton2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    [blankBarButton2 setWidth:[UIScreen mainScreen].bounds.size.width * 3 / 5 - 100];
    //添加
    NSArray *baseToolBarItem=[NSArray arrayWithObjects:listBarButton,blankBarButton1,charactersBarButton,blankBarButton1,cameraBarButton,blankBarButton2,itemBarButton,nil];
    [baseToolbar setItems:baseToolBarItem];
    [self.view addSubview:baseToolbar];
    
    
    //项目数显示lable
    UILabel *itemShowLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 70, [UIScreen mainScreen].bounds.size.height - 35, 70, 20)];
    
    self.bl = [[DiaryBL alloc] init];
    self.listData = [self.bl findAll];
    itemNumber = _listData.count;
    
    NSString *itemNumberShow=[NSString stringWithFormat:@"%ld Item",itemNumber];
    [itemShowLabel setText:itemNumberShow];
    [itemShowLabel setTextColor:[UIColor whiteColor]];
    [itemShowLabel setFont:[UIFont fontWithName:@"Times new roman" size:17]];
    
    [self.view addSubview:itemShowLabel];
}


@end
