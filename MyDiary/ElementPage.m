//
//  ElementPage.m
//  MyDiary
//
//  Created by Wujianyun on 17/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "ElementPage.h"
#import "TimeDealler.h"
#define LL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define Iphone6ScaleWidth(x) ((x) * LL_SCREEN_WIDTH /375.0f)
#define Iphone6ScaleHeight(x) ((x)*LL_SCREEN_HEIGHT/667.0f)
@interface ElementPage ()<UITextViewDelegate>

@end

@implementation ElementPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    // Do any additional setup after loading the view from its nib.
}
-(void)drawView{
    _timeSetBtn.layer.cornerRadius=15;
    _timeSetBtn.layer.masksToBounds = YES;
    _locationSetBtn.layer.cornerRadius=15;
    _locationSetBtn.layer.masksToBounds = YES;
    _dateSetBtn.layer.cornerRadius=15;
    _dateSetBtn.layer.masksToBounds = YES;
    
    if(_isNew) {
        _element.time=[TimeDealler getCurrentTime];
        _element.date=[TimeDealler getCurrentDate];
        [_element setDates];
        _isSaved=NO;
    }else{
        _isSaved=YES;
    }
    _timeLabel.text=_element.time;
    _locationLabel.text=_element.location;
    _dateLabel.text=[[_element.year stringByAppendingString:_element.month]stringByAppendingString:_element.day];
    _textField.text=_element.title;
    _textView.text=_element.content;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)editingDidEnd:(UITextField *)sender {
    if(![_textField.text isEqualToString:_element.title]){
        _element.title=_textField.text;
        _isSaved=NO;
    }
    
}

- (IBAction)saveBtn:(UIButton *)sender {
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"保存成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    _element.title=_textField.text;
    _element.content=_textView.text;
    _element.isSelected=NO;
    if(_isNew){
        [_element creatElement];
    }else{
        [_element updateElement];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:
                      ^(UIAlertAction*action)
                      {
                          _isSaved=YES;
                      }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)cancelBtn:(UIButton *)sender {
    if(_isSaved) {
        CATransition* amin=[CATransition animation];
        [amin setDuration:1];
        [amin setType:@"cube"];
        [amin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [amin setSubtype:kCATransitionFromLeft];
        [self.navigationController.view.layer addAnimation:amin forKey:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else {
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
}

- (IBAction)setTime:(UIButton *)sender {
    [self.view bringSubviewToFront:_TimeSetView];
}

- (IBAction)setLocation:(UIButton *)sender {
}

- (IBAction)setDate:(UIButton *)sender {
    [self.view bringSubviewToFront:_dateSetView];
}

- (IBAction)timeConfirm:(UIButton *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    if(![[formatter stringFromDate:_timePicker.date] isEqualToString:_element.time]) {
        _element.time=[formatter stringFromDate:_timePicker.date];
        _timeLabel.text=_element.time;
        _isSaved=NO;
    }
    [self.view bringSubviewToFront:_normalView];
}

- (IBAction)timeCancel:(UIButton *)sender {
    [self.view bringSubviewToFront:_normalView];
}

- (IBAction)dateConfirm:(UIButton *)sender {
    NSMutableDictionary *dateDic=[[NSMutableDictionary alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString * year = [formatter stringFromDate:_datePicker.date];
    [formatter setDateFormat:@"MM"];
    NSString * month=[formatter stringFromDate:_datePicker.date];
    [formatter setDateFormat:@"dd"];
    NSString * day=[formatter stringFromDate:_datePicker.date];
    if(!([_element.year isEqualToString:year]&&[_element.month isEqualToString:month]&&[_element.day isEqualToString:day])) {
        _isSaved=NO;
        [dateDic setObject:year forKey:@"year"];
        [dateDic setObject:month forKey:@"month"];
        [dateDic setObject:day forKey:@"day"];
        _element.date=dateDic;
        [_element setDates];
        _dateLabel.text=[[_element.year stringByAppendingString:_element.month]stringByAppendingString:_element.day];
    }
    [self.view bringSubviewToFront:_normalView];
}

- (IBAction)dateCancel:(UIButton *)sender {
    [self.view bringSubviewToFront:_normalView];
}
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:2.0];
    [UIView setAnimationDelegate:self];
    [_normalView setFrame:CGRectMake(_TimeSetView.frame.origin.x,Iphone6ScaleHeight(50), _TimeSetView.frame.size.width, _TimeSetView.frame.size.height)];
    [UIView commitAnimations];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:2.0];
    [UIView setAnimationDelegate:self];
    [_normalView setFrame:_TimeSetView.frame];
    [UIView commitAnimations];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
    if(!([_textView.text isEqualToString:_element.content]&&[_textField.text isEqualToString:_element.title])) {
        
    }
}

@end
