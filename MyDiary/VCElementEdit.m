//
//  VCElementEdit.m
//  MyDiary
//
//  Created by Jimmy Fan on 2017/2/7.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import "VCElementEdit.h"
#import "FMDatabase.h"

@interface VCElementEdit ()

@end

@implementation VCElementEdit

@synthesize myID = _id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView* _backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIImageView* _imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage.jpg"]];
    [_backgroundview addSubview:_imageview];
    [self.view addSubview:_backgroundview];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Edit Element";
    UIBarButtonItem* btnFinish = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(pressFinish)];
    self.navigationItem.rightBarButtonItem = btnFinish;
    
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 80, 50)];
    _lbTitle.text = @"标题：";
    _lbTitle.font = [UIFont systemFontOfSize:25];
    _lbTitle.textColor = [UIColor blackColor];
    [self.view addSubview:_lbTitle];
    _title = [[UITextField alloc] initWithFrame:CGRectMake(100, 80, [UIScreen mainScreen].bounds.size.width - 120, 50)];
    _title.borderStyle = UITextBorderStyleRoundedRect;
    _title.keyboardType = UIKeyboardTypeDefault;
    _title.font = [UIFont systemFontOfSize:25];
    _title.textColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
    [self.view addSubview:_title];
    _lbContent = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, [UIScreen mainScreen].bounds.size.width, 50)];
    _lbContent.text = @"内容";
    _lbContent.font = [UIFont systemFontOfSize:20];
    _lbContent.textColor = [UIColor blackColor];
    [_lbContent setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_lbContent];
    
    
    _content = [[UITextView alloc] initWithFrame:CGRectMake(20, 180, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 230)];
    _content.delegate = self;
    _content.layer.cornerRadius = 10;
    _content.layer.masksToBounds = YES;
    _content.font = [UIFont systemFontOfSize:18];
    _content.textColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
    [self.view addSubview:_content];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];

    NSString* strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/datebase.db"];
    _mDB = [[FMDatabase alloc] initWithPath:strPath];
    maxid = 0;
    if ([_mDB open]) {
        NSString* strQuery = @"select * from elements;";
        FMResultSet* result = [_mDB executeQuery:strQuery];
        while ([result next]) {
            if ([result intForColumn:@"id"] > maxid) maxid = [result intForColumn:@"id"];
            if ([result intForColumn:@"id"] == [self.myID intValue]) {
                _title.text = [result stringForColumn:@"title"];
                _content.text = [result stringForColumn:@"content"];
            }
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    _content.frame = CGRectMake(20, 180, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 180 - keyboardRect.size.height);
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    _content.frame = CGRectMake(20, 180, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 230);
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_title resignFirstResponder];
    [_content resignFirstResponder];
}

- (NSString*)shortDay:(NSString*)day {
    if ([day isEqualToString:@"01"]) return @"1";
    if ([day isEqualToString:@"02"]) return @"2";
    if ([day isEqualToString:@"03"]) return @"3";
    if ([day isEqualToString:@"04"]) return @"4";
    if ([day isEqualToString:@"05"]) return @"5";
    if ([day isEqualToString:@"06"]) return @"6";
    if ([day isEqualToString:@"07"]) return @"7";
    if ([day isEqualToString:@"08"]) return @"8";
    if ([day isEqualToString:@"09"]) return @"9";
    return day;
}

- (void)pressFinish {
    if ([_mDB open]) {
        NSDate* date = [NSDate date];
/*        NSTimeZone* zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:date];
        NSDate* localDate = [date dateByAddingTimeInterval:interval];
 */
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM"];
        NSString* strMonth = [dateFormatter stringFromDate:date];
        [dateFormatter setDateFormat:@"dd"];
        NSString* strDay = [self shortDay:[dateFormatter stringFromDate:date]];
        [dateFormatter setDateFormat:@"EEEE"];
        NSString* strWeek = [dateFormatter stringFromDate:date];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString* strMinute = [dateFormatter stringFromDate:date];
        NSString* strTitle = _title.text;
        NSString* strContent = _content.text;
        NSString* strDel = [[NSString alloc] initWithFormat:@"delete from elements where id = %d;", [self.myID intValue]];
        [_mDB executeUpdate:strDel];
        NSString* strInsert = [[NSString alloc] initWithFormat:@"insert into elements values('%ld','%@','%@','%@','%@','%@','%@');",maxid + 1, strMonth, strDay, strWeek, strTitle, strContent, strMinute];
        [_mDB executeUpdate:strInsert];
    }
    [_delegate changeID:maxid + 1];
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
