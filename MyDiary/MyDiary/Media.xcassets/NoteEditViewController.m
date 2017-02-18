//
//  NoteEditViewController.m
//  MyDiary
//
//  Created by tinoryj on 2017/2/8.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "NoteEditViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "RootViewController.h"

@interface NoteEditViewController ()<UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *dateSettingField;

@property (strong, nonatomic) IBOutlet UITextField *titleSettingField;

@property (strong, nonatomic) IBOutlet UITextView *contentText;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic,strong) NSString *date;

@property (nonatomic,strong) UIColor *themeColor;

//------------------location----------------------

@property(nonatomic, strong) CLLocationManager *locationManager;

@property(nonatomic, strong)  CLLocation *currLocation;

@property (strong, nonatomic) IBOutlet UITextView *locationView;

//------------------------------------------------------
@end

@implementation NoteEditViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    //定位服务管理对象初始化
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDistanceFilter:1000.0f];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    //主题颜色
    UIColor *blueThemeColor = [UIColor colorWithRed:107/255.0 green:183/255.0 blue:219/255.0 alpha:1];
    //UIColor *redThemeColor = [UIColor colorWithRed:246/255.0 green:120/255.0 blue:138/255.0 alpha:1];
    _themeColor = blueThemeColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self buildNavBar];
    [self buildTitleTextField];
    [self buildTimeTextField];
    [self buildContentText];
    [self buildLocation];
    //设置背景
    [self.view setBackgroundColor:[UIColor colorWithRed:1 green:252/255.0 blue:235/255.0 alpha:0.5]];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
//content------------------------------------------------
- (void)buildContentText{
    //标题显示
    UILabel *contentTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 80) / 2, 130, 80, 20)];
    [contentTitleLable setTextColor:_themeColor];
    [contentTitleLable setBackgroundColor:[UIColor clearColor]];
    [contentTitleLable setFont:[UIFont fontWithName:@"Futura" size:18]];
    [contentTitleLable setTextAlignment:NSTextAlignmentLeft];
    [contentTitleLable setText:@"项目内容"];
    [self.view addSubview:contentTitleLable];
    //content显示
    _contentText = [[UITextView alloc]initWithFrame:CGRectMake(5, 155,[UIScreen mainScreen].bounds.size.width - 10, [UIScreen mainScreen].bounds.size.height - 210)];
    [_contentText setBackgroundColor:[UIColor colorWithRed:107/255.0 green:183/255.0 blue:219/255.0 alpha:0.3]];
    [_contentText setDelegate:self];
    [_contentText setFont:[UIFont systemFontOfSize:16]];
    [_contentText setReturnKeyType:UIReturnKeyDefault];
    [_contentText setKeyboardType:UIKeyboardTypeDefault];
    [_contentText setText:_currentPage.content];
    //toolbar按钮回收键盘
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    [topView setBarStyle:UIBarStyleBlackTranslucent];
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(resignKeyboard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    [_contentText setInputAccessoryView:topView];
    
    [self.view addSubview:_contentText];
}
//回收键盘
- (void)resignKeyboard {
    
    [_contentText resignFirstResponder];
}
//编辑状态调整content设置
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    float offset = 0.0f;
    if(_contentText == textView){
        
        offset = - 165.0f;
    }
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    [UIView setAnimationDuration:animationDuration];
    [_contentText setBackgroundColor:[UIColor colorWithRed:107/255.0 green:183/255.0 blue:219/255.0 alpha:0.95]];
    _contentText.frame = CGRectMake(5, 70 ,[UIScreen mainScreen].bounds.size.width - 10,[UIScreen mainScreen].bounds.size.height - 360);
    [UIView  commitAnimations];
}
//编辑完成恢复content设置
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    [UIView setAnimationDuration:animationDuration];
        [_contentText setBackgroundColor:[UIColor colorWithRed:107/255.0 green:183/255.0 blue:219/255.0 alpha:0.3]];
    _contentText.frame= CGRectMake(5, 155,[UIScreen mainScreen].bounds.size.width - 10, [UIScreen mainScreen].bounds.size.height - 210);
    [UIView commitAnimations];
}
//location------------------------------------------------
- (void)buildLocation{
    
    //标题显示
    UILabel *locationTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height - 48, 50, 40)];
    [locationTitleLable setTextColor:_themeColor];
    [locationTitleLable setBackgroundColor:[UIColor clearColor]];
    [locationTitleLable setFont:[UIFont fontWithName:@"Futura" size:18]];
    [locationTitleLable setTextAlignment:NSTextAlignmentLeft];
    [locationTitleLable setText:@"位置:"];
    [self.view addSubview:locationTitleLable];
    //location显示
    _locationView = [[UITextView alloc]initWithFrame:CGRectMake(60, [UIScreen mainScreen].bounds.size.height - 48,[UIScreen mainScreen].bounds.size.width - 100, 40)];
    [_locationView setBackgroundColor:[UIColor clearColor]];
    [_locationView setDelegate:self];
    [_locationView setEditable:NO];
    [_locationView setFont:[UIFont systemFontOfSize:14]];
    [_locationView setReturnKeyType:UIReturnKeyDefault];
    [_locationView setKeyboardType:UIKeyboardTypeDefault];
    [self.view addSubview:_locationView];
    //button
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton setImage:[UIImage imageNamed:@"location2"] forState:UIControlStateNormal];
    [locationButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateHighlighted];
    [locationButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40,  [UIScreen mainScreen].bounds.size.height - 42, 30, 30)];
    [self.view addSubview:locationButton];
    [locationButton addTarget:self action:@selector(reverseGeocode) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //开始定位
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //停止定位
    [self.locationManager stopUpdatingLocation];
}

- (void)reverseGeocode{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.currLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if ([placemarks count] > 0) {
                           
                           CLPlacemark *placemark = placemarks[0];
                           NSDictionary *addressDictionary =  placemark.addressDictionary;
                           NSString *address = [addressDictionary
                                                objectForKey:(NSString *)kABPersonAddressStreetKey];
                           address = address == nil ? @"": address;
                           NSString *state = [addressDictionary
                                              objectForKey:(NSString *)kABPersonAddressStateKey];
                           state = state == nil ? @"": state;
                           NSString *city = [addressDictionary
                                             objectForKey:(NSString *)kABPersonAddressCityKey];
                           city = city == nil ? @"": city;
                           NSLog(@"%@ \n%@ \n%@",state, address,city);
                           _locationView.text = [NSString stringWithFormat:@"%@ %@ %@\n",state, city, address];
                       }
                   }
     ];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    self.currLocation = [locations lastObject];
    //NSLog(@"%3.5f\n",self.currLocation.coordinate.latitude);
    //NSLog(@"%3.5f\n",self.currLocation.coordinate.longitude);
    //NSLog(@"%3.5f\n",self.currLocation.altitude);
    if(_currentPage.location){
        
        _locationView.text = _currentPage.location;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"error: %@",error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"Authorized");
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"AuthorizedWhenInUse");
    } else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"Denied");
    } else if (status == kCLAuthorizationStatusRestricted) {
        NSLog(@"Restricted");
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"NotDetermined");
    }
}
//时间设置-----------------------------------
- (void)buildTimeTextField{
    
    //标题
    UILabel *dateSettingTitle = [[UILabel alloc]init];
    [dateSettingTitle setFrame:CGRectMake(20, 100, 100, 20)];
    [dateSettingTitle setTextColor:_themeColor];
    [dateSettingTitle setBackgroundColor:[UIColor clearColor]];
    [dateSettingTitle setFont:[UIFont fontWithName:@"Futura" size:18]];
    [dateSettingTitle setTextAlignment:NSTextAlignmentLeft];
    [dateSettingTitle setText:@"时间设定:"];
    [self.view addSubview:dateSettingTitle];
    //时间显示
    _dateSettingField = [[UITextField alloc]initWithFrame:CGRectMake(120, 100,[UIScreen mainScreen].bounds.size.width - 140, 20)];
    [_dateSettingField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_dateSettingField setTextAlignment:NSTextAlignmentCenter];
    [_dateSettingField setTextAlignment:NSTextAlignmentLeft];
    [_dateSettingField setBackgroundColor:[UIColor clearColor]];
    [_dateSettingField setTextColor:[UIColor blackColor]];
    [_dateSettingField setDelegate:self];
    [_dateSettingField setTag:10008];
    [_dateSettingField setFont:[UIFont fontWithName:@"Futura" size:18]];
    [_dateSettingField setReturnKeyType:UIReturnKeyNext];
    UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(110, 120, [UIScreen mainScreen].bounds.size.width - 130, 1)];
    underline.backgroundColor = [UIColor grayColor];
    [self.view addSubview:underline];
    [self.view addSubview:_dateSettingField];
    //数据预处理
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if(_currentPage.date){
        _date = [dateFormatter stringFromDate:_currentPage.date];
        [_dateSettingField setText:_date];
    }
    else{
        NSDate *now = [[NSDate alloc]init];
        _date = [dateFormatter stringFromDate:now];
        [_dateSettingField setText:_date];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //时间选取
    if([_dateSettingField isFirstResponder]){
        
        _datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0.0,0.0,0.0,0.0)];
        [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *minDateString = @"2010-01-01 00:00:00";
        NSString *maxDateString = @"2020-12-31 00:00:00";
        NSDate *minDate = [dateFormatter dateFromString:minDateString];
        NSDate *maxDate = [dateFormatter dateFromString:maxDateString];
        [_datePicker setMinimumDate:minDate];
        [_datePicker setMaximumDate:maxDate];
        [_datePicker setDate:[dateFormatter dateFromString:_date] animated:YES];
        [_dateSettingField setInputView:_datePicker];
        
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelPicker)];
        UIBarButtonItem *blankBarButton1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [blankBarButton1 setWidth:[UIScreen mainScreen].bounds.size.width -70];
        [toolBar setItems:[NSArray arrayWithObjects:blankBarButton1, right,nil]];
        
        [_dateSettingField setInputAccessoryView:toolBar];
    }
}

- (void)cancelPicker {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _date = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:_datePicker.date]];
    [_dateSettingField setText:_date];
    [_dateSettingField resignFirstResponder];
}
//标题设置------------------------------------
- (void)buildTitleTextField{
    
    UILabel *titleSettingTitle = [[UILabel alloc]init];
    [titleSettingTitle setFrame:CGRectMake(20, 70, 100, 20)];
    [titleSettingTitle setTextColor:_themeColor];
    [titleSettingTitle setBackgroundColor:[UIColor clearColor]];
    [titleSettingTitle setFont:[UIFont fontWithName:@"Futura" size:18]];
    [titleSettingTitle setTextAlignment:NSTextAlignmentLeft];
    [titleSettingTitle setText:@"标题设定:"];
    [self.view addSubview:titleSettingTitle];
    
    _titleSettingField = [[UITextField alloc]initWithFrame:CGRectMake(120, 70,[UIScreen mainScreen].bounds.size.width - 140, 20)];
    [_titleSettingField setKeyboardType:UIKeyboardTypeDefault];
    [_titleSettingField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_titleSettingField setAutocorrectionType:UITextAutocorrectionTypeYes];
    [_titleSettingField setTextAlignment:NSTextAlignmentLeft];
    [_titleSettingField setBackgroundColor:[UIColor clearColor]];
    [_titleSettingField setTextColor:[UIColor blackColor]];
    [_titleSettingField setDelegate:self];
    [_titleSettingField setTag:10007];
    [_titleSettingField setFont:[UIFont fontWithName:@"Futura" size:18]];
    //字号自适应显示
    [_titleSettingField setAdjustsFontSizeToFitWidth:YES];
    [_titleSettingField setMinimumFontSize:12];
    
    [_titleSettingField setReturnKeyType:UIReturnKeyDone];
    UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(110, 90, [UIScreen mainScreen].bounds.size.width - 130, 1)];
    underline.backgroundColor = [UIColor grayColor];
    [self.view addSubview:underline];
    
    [self.view addSubview:_titleSettingField];
    
    if(_currentPage.title){
        
        [_titleSettingField setText:_currentPage.title];
    }
    else{
        
        [_titleSettingField setPlaceholder:@"填写项目标题"];
    }
}
//导航栏-------------------------------------------------------
- (void)buildNavBar{
    
    //自定义navbar
    UINavigationBar *baseNav = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    [baseNav setBackgroundColor:_themeColor];
    [baseNav setBarTintColor:_themeColor];
    [baseNav setTranslucent:NO];
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [cancel setTitle:@"返回" forState:UIControlStateNormal];
    [cancel setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancel.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [cancel.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [cancel.titleLabel setTextColor:[UIColor whiteColor]];
    [cancel setBackgroundColor:[UIColor clearColor]];
    [cancel addTarget:self action:@selector(cancelEdit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];
    UIButton *save = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save.titleLabel setTextAlignment:NSTextAlignmentRight];
    [save.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [save.titleLabel setTextColor:[UIColor whiteColor]];
    [save setBackgroundColor:[UIColor clearColor]];
    [save addTarget:self action:@selector(saveEdit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    UIBarButtonItem *saveButton=[[UIBarButtonItem alloc]initWithCustomView:save];
    UINavigationItem *item = [[UINavigationItem alloc]init];
    
    [item setLeftBarButtonItem:cancelButton];
    [item setRightBarButtonItem:saveButton];
    
    UILabel *barTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 35)];
    [barTitle setTextAlignment:NSTextAlignmentCenter];
    [barTitle setText:@"编辑项目"];
    [barTitle setTextColor:[UIColor whiteColor]];
    [barTitle setFont:[UIFont fontWithName:@"Futura" size:22]];
    [item setTitleView:barTitle];
    [baseNav pushNavigationItem:item animated:NO];
    
    [self.view addSubview:baseNav];
}

- (void)cancelEdit{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveEdit{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if(_currentPage){
        //修改操作
        NoteBL *bl = [[NoteBL alloc]init];
        [bl removeNote:_currentPage];
        Note *note = [[Note alloc]init];
        note.date = [dateFormatter dateFromString:_dateSettingField.text];
        if(_titleSettingField.text.length == 0){
            NSString *noTitle = @"未命名项目";
            [_titleSettingField setText:noTitle];
        }
        if(_contentText.text.length == 0){
            NSString *noContent = @"未添加内容";
            [_contentText setText:noContent];
        }
        note.title = _titleSettingField.text;
        note.content = _contentText.text;
        note.location = _locationView.text;
        [bl createNote:note];
        //操作成功返回home界面 做更新操作
        [self.noteDelegate updateTheNoteList];
    }
    else{
        
        NoteBL *bl = [[NoteBL alloc]init];
        Note *note = [[Note alloc]init];
        note.date = [dateFormatter dateFromString:_dateSettingField.text];
        if(_titleSettingField.text.length == 0){
            NSString *noTitle = @"未命名项目";
            [_titleSettingField setText:noTitle];
        }
        if(_contentText.text.length == 0){
            NSString *noContent = @"未添加内容";
            [_contentText setText:noContent];
        }
        note.title = _titleSettingField.text;
        note.content = _contentText.text;
        note.location = _locationView.text;
        [bl createNote: note];
        [self.noteDelegate updateTheNoteList];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_titleSettingField resignFirstResponder];
    return YES;
}

@end
