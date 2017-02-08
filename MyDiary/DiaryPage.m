//
//  DiaryPage.m
//  MyDiary
//
//  Created by Wujianyun on 17/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "DiaryPage.h"
#import "TimeDealler.h"
#define LL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define Iphone6ScaleWidth(x) ((x) * LL_SCREEN_WIDTH /375.0f)
#define Iphone6ScaleHeight(x) ((x)*LL_SCREEN_HEIGHT/667.0f)
@interface DiaryPage ()<UITextViewDelegate> {
    CGRect textViewFrame;
}

@end

@implementation DiaryPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    // Do any additional setup after loading the view from its nib.
}
-(void)drawView{
    
    if(_isNew) {
        _diary.time=[TimeDealler getCurrentTime];
        _diary.date=[TimeDealler getCurrentDate];
        [_diary setDates];
        _isSaved=NO;
    }else{
        _isSaved=YES;
    }
    _timeLabel.text=_diary.time;
    _locationLabel.text=_diary.location;
    _dateLabel.text=[[_diary.year stringByAppendingString:_diary.month]stringByAppendingString:_diary.day];
    _textField.text=_diary.title;
    _textView.text=_diary.content;
    
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

- (IBAction)backBtn:(UIButton *)sender {
    if(_isSaved) {
        CATransition* amin=[CATransition animation];
        [amin setDuration:1];
        [amin setType:@"cube"];
        [amin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [amin setSubtype:kCATransitionFromLeft];
        [self.navigationController.view.layer addAnimation:amin forKey:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"你还没保存呐！" message:@"确定要退出编辑吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDestructive handler:
                      ^(UIAlertAction*action)
                      {
                          CATransition* amin=[CATransition animation];
                          [amin setDuration:1];
                          [amin setType:@"cube"];
                          [amin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                          [amin setSubtype:kCATransitionFromLeft];
                          [self.navigationController.view.layer addAnimation:amin forKey:nil];
                          [self.navigationController popViewControllerAnimated:YES];
                          
                      }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:
                      ^(UIAlertAction*action)
                      {
                          NSLog(@"点击了Cancel按钮");
                      }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)saveBtn:(UIButton *)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"保存成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    _diary.title=_textField.text;
    _diary.content=_textField.text;
    if(_isNew){
        [_diary creatDiary];
    }else{
        [_diary updateDiary];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:
                      ^(UIAlertAction*action)
                      {
                          _isSaved=YES;
                      }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:2.0];
    [UIView setAnimationDelegate:self];
    textViewFrame=_textViewBackView.frame;
    [_textViewBackView setFrame:CGRectMake(_textViewBackView.frame.origin.x, Iphone6ScaleHeight(10), _textViewBackView.frame.size.width, _textViewBackView.frame.size.height)];
    [UIView commitAnimations];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:2.0];
    [UIView setAnimationDelegate:self];
    [_textViewBackView setFrame:textViewFrame];
    [UIView commitAnimations];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textField resignFirstResponder];
    [_textView resignFirstResponder];
}
@end
