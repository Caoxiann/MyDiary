//
//  VCDiaryAdd.m
//  MyDiary
//
//  Created by Jimmy Fan on 2017/2/8.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import "VCDiaryAdd.h"
#import "FMDatabase.h"

@interface VCDiaryAdd ()

@end

@implementation VCDiaryAdd

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView* _backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIImageView* _imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage.jpg"]];
    [_backgroundview addSubview:_imageview];
    [self.view addSubview:_backgroundview];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"New Diary";
    UIBarButtonItem* btnFinish = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(pressFinish)];
    self.navigationItem.rightBarButtonItem = btnFinish;
    
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 80, 50)];
    _lbTitle.text = @"标题：";
    _lbTitle.font = [UIFont systemFontOfSize:25];
    _lbTitle.textColor = [UIColor blackColor];
    [self.view addSubview:_lbTitle];
    _tfTitle = [[UITextField alloc] initWithFrame:CGRectMake(100, 80, [UIScreen mainScreen].bounds.size.width - 120, 50)];
    _tfTitle.borderStyle = UITextBorderStyleRoundedRect;
    _tfTitle.keyboardType = UIKeyboardTypeDefault;
    _tfTitle.font = [UIFont systemFontOfSize:25];
    _tfTitle.textColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
    [self.view addSubview:_tfTitle];
    _lbContent = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, [UIScreen mainScreen].bounds.size.width, 50)];
    _lbContent.text = @"内容";
    _lbContent.font = [UIFont systemFontOfSize:20];
    _lbContent.textColor = [UIColor blackColor];
    [_lbContent setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_lbContent];
    
    _tvContent = [[UITextView alloc] initWithFrame:CGRectMake(20, 180, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 230)];
    _tvContent.delegate = self;
    _tvContent.layer.cornerRadius = 10;
    _tvContent.font = [UIFont systemFontOfSize:18];
    _tvContent.layer.masksToBounds = YES;
    _tvContent.textColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
    [self.view addSubview:_tvContent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
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
    _tvContent.frame = CGRectMake(20, 180, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 180 - keyboardRect.size.height);
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    _tvContent.frame = CGRectMake(20, 180, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 230);
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_tfTitle resignFirstResponder];
    [_tvContent resignFirstResponder];
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
    NSString* strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/datebase.db"];
    _mDB = [[FMDatabase alloc] initWithPath:strPath];
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
        
        NSString* strTitle = _tfTitle.text;
        NSString* strContent = _tvContent.text;
        
        NSString* strQuery = @"select id from diary;";
        FMResultSet* result = [_mDB executeQuery:strQuery];
        NSInteger maxid = 0;
        while ([result next]) if ([result intForColumn:@"id"] > maxid) maxid = [result intForColumn:@"id"];
        NSString* strInsert = [[NSString alloc] initWithFormat:@"insert into diary values('%ld','%@','%@','%@','%@','%@');",maxid + 1, strMonth, strDay, strWeek, strTitle, strContent];
        [_mDB executeUpdate:strInsert];
    }
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
