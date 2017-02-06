//
//  NotePageController.m
//  My Diary
//
//  Created by 徐贤达 on 2017/2/2.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import "NotePageController.h"
#import "SqlService.h"
#import "TimeDealler.h"
#import "NotePageSearvice.h"
#import "BXElements.h"

@interface NotePageController ()<UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITextView *pageTextView;

@property (strong, nonatomic) IBOutlet UIButton *back;

@property (strong, nonatomic) IBOutlet UIButton *save;

@property (strong, nonatomic) IBOutlet UILabel *myTitle;

@property (strong, nonatomic) IBOutlet UILabel *myMainTitle;

@property (strong, nonatomic) IBOutlet UITextView *pageLabelTextView;

@property (strong, nonatomic) IBOutlet UILabel *currentTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *warnTitle;

@property (strong, nonatomic) IBOutlet UIButton *cancel;

@property (nonatomic,strong) BXMainPage *mainPage;

@end

@implementation NotePageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if(_pageLabelTextView.text.length>=5)
    {
        _pageLabelTextView.text=[_pageLabelTextView.text substringWithRange:NSMakeRange(0, 5)];
    }
    if(_currentPage)
    {
        _pageTextView.text = _currentPage.content;
        _currentTimeLabel.text = _currentPage.time;
        _pageLabelTextView.text=_currentPage.titile;
    }
    _pageTextView.keyboardType=UIKeyboardTypeNamePhonePad;
    _pageLabelTextView.keyboardType=UIKeyboardTypeNamePhonePad;
    _warnTitle.textAlignment=NSTextAlignmentCenter;
//设置背景
    UIImage *backImage=[UIImage imageNamed:@"inputBackground.jpg"];
    self.view.layer.contents=(id)backImage.CGImage;
    self.view.layer.backgroundColor=[UIColor clearColor].CGColor;
//设置按钮和标题的风格
    UIColor *color=[UIColor colorWithRed:255/255.0 green:99/255.0 blue:71/255.0 alpha:1.0];
    _back.tintColor=color;
    _back.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
    _save.tintColor=color;
    _save.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
    _myTitle.textColor=color;
    _myTitle.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
    _myMainTitle.textColor=color;
    _myMainTitle.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
    _warnTitle.textColor=color;
    _warnTitle.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
    _cancel.tintColor=[UIColor blackColor];
    _cancel.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
//模糊主色调
    NSString *colorname =@"0x69D7DD";
    long colorLong = strtoul([colorname cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    int R = (colorLong & 0xFF0000 )>>16;
    int G = (colorLong & 0x00FF00 )>>8;
    int B =  colorLong & 0x0000FF;
    UIColor *themecolor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:0.5];
//清晰主色调
    NSString *colorname2 =@"0x69D7DD";
    long colorLong2 = strtoul([colorname2 cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    int R2 = (colorLong2 & 0xFF0000 )>>16;
    int G2 = (colorLong2 & 0x00FF00 )>>8;
    int B2 =  colorLong2 & 0x0000FF;
    UIColor *themecolor2 = [UIColor colorWithRed:R2/255.0 green:G2/255.0 blue:B2/255.0 alpha:1.0];
    _pageTextView.backgroundColor=themecolor;
    _pageLabelTextView.backgroundColor=themecolor;
    _currentTimeLabel.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:17];
    _currentTimeLabel.textColor=themecolor2;
//手动调整控件位置
    _pageTextView.frame=CGRectMake(deviceWidth*10/100, deviceHeight*50/100, deviceWidth*80/100, deviceHeight*40/100);
    _pageLabelTextView.frame=CGRectMake(deviceWidth*10/100, deviceHeight*25/100, deviceWidth*80/100, deviceHeight*15/100);
    _myMainTitle.frame=CGRectMake((deviceWidth/2)-30, deviceHeight*42/100,60, deviceHeight*6/100);
    _myTitle.frame=CGRectMake((deviceWidth/2)-30, deviceHeight*12/100, 60, deviceHeight*6/100);
    _warnTitle.frame=CGRectMake((deviceWidth/2)-80, deviceHeight*17/100, 160, deviceHeight*6/100);
    _cancel.frame=CGRectMake((deviceWidth/2)-30, deviceHeight*92/100, 60, deviceHeight*6/100);
    _currentTimeLabel.frame=CGRectMake((deviceWidth/2)-deviceWidth*40/100, deviceHeight*6/100, deviceWidth*80/100, deviceHeight*6/100);
    _currentTimeLabel.textAlignment=NSTextAlignmentCenter;
    _myTitle.textAlignment=NSTextAlignmentCenter;
    _myMainTitle.textAlignment=NSTextAlignmentCenter;
    
    _mainPage=[[BXMainPage alloc]init];

}

//删除提示
- (IBAction)deleteButtonAction:(id)sender
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    
}

//删除操作
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        if(_currentPage){
            [NotePageSearvice deleteNotePage:nil title:nil currentNotePage:_currentPage];
                [self.noteDelegate updateTheNoteList];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_pageLabelTextView resignFirstResponder];
    [_pageTextView resignFirstResponder];
}

//返回操作
- (IBAction)pressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//保存操作
- (IBAction)rightButtonAction:(id)sender
{
    if(_currentPage)
    {
        //修改操作
        if([_pageTextView.text length] == 0)
        {
            [NotePageSearvice deleteNotePage:_pageTextView.text title:_pageLabelTextView.text currentNotePage:_currentPage];
        }
        else
        {
            [NotePageSearvice updateNotePage:_pageTextView.text title:_pageLabelTextView.text currentNotePage:_currentPage];
        }
        //操作成功返回home界面 做更新操作
    }
    else
    {
        [NotePageSearvice creatNotepage:_pageTextView.text title:_pageLabelTextView.text];
    }
    [_mainPage updateTimes];
    [self.noteDelegate updateTheNoteList];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
