//
//  ViewController.m
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "RootViewController.h"

@interface ViewController ()

@property (nonatomic) CGSize deviceScreenSize;

@property (nonatomic) CGRect buttonRect;
//主题颜色
@property (nonatomic,strong) UIColor *themeColor;

@property (nonatomic,retain) UILabel *titleLabel;

@property (nonatomic,retain) UILabel *itemShowLabel;

@property (nonatomic) NSInteger page;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self themeSetting];
    [self viewControllersInit];
    [self titleLableInit];
    [self buildSegmentControl];
    [self buildToolBar];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

//主题设置
- (void)themeSetting {
    //主题颜色
    UIColor *blueThemeColor = [UIColor colorWithRed:107/255.0 green:183/255.0 blue:219/255.0 alpha:1];
    //UIColor *redThemeColor = [UIColor colorWithRed:246/255.0 green:120/255.0 blue:138/255.0 alpha:1];
    _themeColor = blueThemeColor;
    //控件大小设置
    _deviceScreenSize = [UIScreen mainScreen].bounds.size;
    _buttonRect = CGRectMake(0, 0, 20, 20);
    //属性设置
    self.navigationController.navigationBar.hidden=YES;
    self.navigationController.toolbar.hidden=NO;
}

- (void)titleLableInit {
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( _deviceScreenSize.width / 2 - 100, 66, 200, 20)];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:_themeColor];
    [_titleLabel setFont:[UIFont fontWithName:@"AppleGothic" size:20]];
    [self.view addSubview:_titleLabel];
}

- (void)viewControllersInit {
    
    _elementVC = [[ElementViewController alloc]init];
    [_elementVC.view setFrame:CGRectMake(0, 90, _deviceScreenSize.width, _deviceScreenSize.height-140)];
    [self addChildViewController:_elementVC];
    [self.view addSubview:self.elementVC.view];
    
    _diaryVC = [[DiaryViewController alloc]init];
    [_diaryVC.view setFrame:CGRectMake(0, 90, _deviceScreenSize.width, _deviceScreenSize.height-140)];
    [self addChildViewController:_diaryVC];
    [self.view addSubview:self.diaryVC.view];
    
    _calendarVC = [[CalendarViewController alloc]init];
    [_calendarVC.view setFrame:CGRectMake(0, 90, _deviceScreenSize.width, _deviceScreenSize.height-140)];
    [self addChildViewController:_calendarVC];
    [self.view addSubview:self.calendarVC.view];

}

- (void)buildSegmentControl {
    
    UISegmentedControl *baseSegmentControl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(40, 30, _deviceScreenSize.width - 80, 30)];

    [baseSegmentControl setTintColor:_themeColor];
    [baseSegmentControl setMultipleTouchEnabled:YES];

    [baseSegmentControl insertSegmentWithTitle:@"项目" atIndex:0 animated:YES];
    [baseSegmentControl insertSegmentWithTitle:@"日历" atIndex:1 animated:YES];
    [baseSegmentControl insertSegmentWithTitle:@"日记" atIndex:2 animated:YES];
    
    [baseSegmentControl setSelectedSegmentIndex:0];
    [_titleLabel setText:@"ELEMENTS"];
    [self.view bringSubviewToFront:_elementVC.view];
    _page = 0;
    [baseSegmentControl addTarget:self action:@selector(selectView:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:baseSegmentControl];
}
//切换视图
- (void)selectView:(UISegmentedControl*)baseSegmentControl{
    
    if(baseSegmentControl.selectedSegmentIndex == 0){
        
        [_titleLabel setText:@"ELEMENTS"];
        [self.view bringSubviewToFront:_elementVC.view];
        _page = 0;
    }
    if (baseSegmentControl.selectedSegmentIndex == 1){

        [_titleLabel setText:@"CALENDER"];
        [self.view bringSubviewToFront:_calendarVC.view];
        _page = 1;
    }
    if (baseSegmentControl.selectedSegmentIndex == 2){
        
        [_titleLabel setText:@"DIARY"];
        [self.view bringSubviewToFront:_diaryVC.view];
        _page = 2;
    }
}

- (void)buildToolBar {

    UIToolbar *baseToolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 50)];
    [baseToolbar setBarTintColor:_themeColor];
    //自定义按钮
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [listButton setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
    [listButton setFrame:_buttonRect];
    UIButton *charactersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [charactersButton setImage:[UIImage imageNamed:@"characters"] forState:UIControlStateNormal];
    [charactersButton setFrame:_buttonRect];
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [cameraButton setFrame:_buttonRect];
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton setImage:[UIImage imageNamed:@"item"] forState:UIControlStateNormal];
    [itemButton setFrame:_buttonRect];
    
    [listButton addTarget:self.elementVC action:@selector(note) forControlEvents:UIControlEventTouchUpInside];
    [charactersButton addTarget:self.diaryVC action:@selector(diary) forControlEvents:UIControlEventTouchUpInside];
    //添加按钮到toolBar
    UIBarButtonItem *listBarButton = [[UIBarButtonItem alloc]initWithCustomView:listButton];
    UIBarButtonItem *itemBarButton = [[UIBarButtonItem alloc]initWithCustomView:itemButton];
    UIBarButtonItem *cameraBarButton = [[UIBarButtonItem alloc]initWithCustomView:cameraButton];
    UIBarButtonItem *charactersBarButton = [[UIBarButtonItem alloc]initWithCustomView:charactersButton];
    //间距修正
    UIBarButtonItem *blankBarButton1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    [blankBarButton1 setWidth:10];
    UIBarButtonItem *blankBarButton2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    if(_deviceScreenSize.width == 375)
        [blankBarButton2 setWidth:136 - (_buttonRect.size.width -23)*3];
    else if(_deviceScreenSize.width == 320)
        [blankBarButton2 setWidth:91 - (_buttonRect.size.width -23)*3];
    else if(_deviceScreenSize.width == 414)
        [blankBarButton2 setWidth:185 - (_buttonRect.size.width -23)*3];
    else if(_deviceScreenSize.width == 768)
        [blankBarButton2 setWidth:539 - (_buttonRect.size.width -23)*3];
    else if(_deviceScreenSize.width == 1024)
        [blankBarButton2 setWidth:795 - (_buttonRect.size.width -23)*3];
    
    NSArray *baseToolBarItem=[NSArray arrayWithObjects:listBarButton,blankBarButton1,charactersBarButton,blankBarButton1,cameraBarButton,blankBarButton2,itemBarButton,nil];
    [baseToolbar setItems:baseToolBarItem];
    [self.view addSubview:baseToolbar];
    //项目数显示lable
    _itemShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(_deviceScreenSize.width - 70,_deviceScreenSize.height - 24 - (_buttonRect.size.height / 2), 60, _buttonRect.size.height)];
    [_itemShowLabel setTextAlignment:NSTextAlignmentRight];
    [_itemShowLabel setTextColor:[UIColor whiteColor]];
    [_itemShowLabel setFont:[UIFont systemFontOfSize:_buttonRect.size.height-3]];
    [self.view addSubview:_itemShowLabel];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(catchItemNumber) userInfo:nil repeats:YES];
}

-(void)catchItemNumber{

    itemNumber = [_elementVC.listData count];
    NSString *itemNumberShow=[NSString stringWithFormat:@"%ld 项目",itemNumber];
    [_itemShowLabel setText:itemNumberShow];
}

@end
