//
//  DiaryPage.m
//  MyDiary
//
//  Created by Wujianyun on 17/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "DiaryPage.h"
#import "TimeDealler.h"
#import <CoreLocation/CoreLocation.h>
#define LL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define Iphone6ScaleWidth(x) ((x) * LL_SCREEN_WIDTH /375.0f)
#define Iphone6ScaleHeight(x) ((x)*LL_SCREEN_HEIGHT/667.0f)
@interface DiaryPage ()<UITextViewDelegate,CLLocationManagerDelegate>{
    CGRect textViewFrame;
}
@property (strong,nonatomic) CLGeocoder *geocoder;
@property (strong,nonatomic) CLLocationManager *locationManager;

@end

@implementation DiaryPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    [self getPermission];
    // Do any additional setup after loading the view from its nib.
}
-(void)drawView{
    _diary.time=[TimeDealler getCurrentTime];
    _diary.date=[TimeDealler getCurrentDate];
    [_diary setDates];
    _timeLabel.text=_diary.time;
    _locationLabel.text=_diary.location;
    _dateLabel.text=[[[[[_diary.year stringByAppendingString:@"年"] stringByAppendingString:_diary.month]stringByAppendingString:@"月"]stringByAppendingString:_diary.day]stringByAppendingString:@"日"];
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
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"保存成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    _diary.title=_textField.text;
    _diary.content=_textView.text;
    if(!_locationLabel.text){
        _diary.location=@"";
        _locationLabel.text=_diary.location;
    }
    if(_isNew){
        [_diary creatDiary];
        _isNew=NO;
    }else{
        [_diary updateDiary];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:
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
- (IBAction)getLocation:(UIButton *)sender {
    [self getPermission];
}
- (void)getPermission {
    _locationManager=[[CLLocationManager alloc]init];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    if ([CLLocationManager locationServicesEnabled])
    {
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestAlwaysAuthorization];
        }
        [_locationManager startUpdatingLocation];
    }else {
        [self permissionDenyAlart];
    }
}
- (void)permissionDenyAlart {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"您未授权地点定位功能" message:@"请到设置中开启权限" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:
                      ^(UIAlertAction*action){
                          _diary.location=@"";
                          _locationLabel.text=_diary.location;
                      }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)networkError {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"网络错误" message:@"请再次尝试" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDestructive handler:
                      ^(UIAlertAction*action){
                          _diary.location=@"";
                          _locationLabel.text=_diary.location;
                      }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [_locationManager stopUpdatingLocation];
    _geocoder=[[CLGeocoder alloc]init];
    [_geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:
     ^(NSArray< CLPlacemark *> * placemarks, NSError * error){
         if (error != nil) {
             [self networkError];
         }
         
         if (placemarks.count > 0) {
             CLPlacemark *pm = placemarks[0];
             NSString *locationStr=[[NSString alloc]init];
             if(pm.country!=nil) {
                 locationStr=[[NSString alloc]initWithString:[NSString stringWithFormat:@" %@",pm.country]];
                 if(pm.administrativeArea!=nil) {
                     locationStr=[locationStr stringByAppendingString:[NSString stringWithFormat:@" %@",pm.administrativeArea]];
                     if(pm.locality!=nil){
                         locationStr=[locationStr stringByAppendingString:[NSString stringWithFormat:@" %@",pm.locality]];
                     }
                 }
             }
             _diary.location=locationStr;
             _locationLabel.text=_diary.location;
         } else {
             //错误
         }
     }];
}
@end
