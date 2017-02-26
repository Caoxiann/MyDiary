//
//  VCElementLook.m
//  MyDiary
//
//  Created by Jimmy Fan on 2017/2/5.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import "VCElementLook.h"
#import "FMDatabase.h"
#import "VCElementEdit.h"

@interface VCElementLook ()

@end

@implementation VCElementLook

@synthesize myID = _id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView* _backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIImageView* _imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage.jpg"]];
    [_backgroundview addSubview:_imageview];
    [self.view addSubview:_backgroundview];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Element";
    UIBarButtonItem* btnChange = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStyleDone target:self action:@selector(pressChange)];
    self.navigationItem.rightBarButtonItem = btnChange;
    
    _title = [[UITextField alloc] initWithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, 50)];
    [_title setTextAlignment:NSTextAlignmentCenter];
    _title.font = [UIFont systemFontOfSize:30];
    _title.layer.cornerRadius = 10;
    _title.layer.masksToBounds = YES;
    _title.userInteractionEnabled = NO;
    _title.textColor = [UIColor blackColor];
    [self.view addSubview:_title];
    
    _time = [[UITextField alloc] initWithFrame:CGRectMake(0, 110, [UIScreen mainScreen].bounds.size.width, 40)];
    [_time setTextAlignment:NSTextAlignmentCenter];
    _time.font = [UIFont systemFontOfSize:20];
    _time.userInteractionEnabled = NO;
    _time.textColor = [UIColor blackColor];
    [self.view addSubview:_time];
    
    _content = [[UITextView alloc] initWithFrame:CGRectMake(20, 155, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 175)];
    _content.font = [UIFont systemFontOfSize:18];
    _content.layer.cornerRadius = 10;
    _content.layer.masksToBounds = YES;
    _content.delegate = self;
    _content.editable = NO;
    _content.textColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
    [self.view addSubview:_content];
    
}

- (void)changeID:(NSInteger)ID {
    self.myID = [NSNumber numberWithInteger:ID];
}

- (void)pressChange {
    VCElementEdit* _vcElementEdit = [[VCElementEdit alloc] init];
    _vcElementEdit.myID = [[NSNumber alloc] init];
    _vcElementEdit.myID = self.myID;
    _vcElementEdit.delegate = self;
    [self.navigationController pushViewController:_vcElementEdit animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    NSString* strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/datebase.db"];
    _mDB = [[FMDatabase alloc] initWithPath:strPath];
    BOOL find = NO;
    NSInteger maxid = 0;
    if ([_mDB open]) {
        NSString* strMonth;
        NSString* strDay;
        NSString* strMinute;
        NSString* strQuery = @"select * from elements;";
        FMResultSet* result = [_mDB executeQuery:strQuery];
        while ([result next]) {
            if ([result intForColumn:@"id"] == [self.myID intValue]) {
                _title.text = [result stringForColumn:@"title"];
                _content.text = [result stringForColumn:@"content"];
                strMonth = [result stringForColumn:@"month"];
                strDay = [result stringForColumn:@"day"];
                strMinute = [result stringForColumn:@"minute"];
                find = YES;
                break;
            }
            if ([result intForColumn:@"id"] > maxid) {
                maxid = [result intForColumn:@"id"];
                _title.text = [result stringForColumn:@"title"];
                _content.text = [result stringForColumn:@"content"];
                strMonth = [result stringForColumn:@"month"];
                strDay = [result stringForColumn:@"day"];
                strMinute = [result stringForColumn:@"minute"];
            }
        }
        _time.text = [NSString stringWithFormat:@"%@月%@日 %@",strMonth,[self longDay:strDay],strMinute];
    }
}

- (NSString*)longDay:(NSString*)day {
    if ([day isEqualToString:@"1"]) return @"01";
    if ([day isEqualToString:@"2"]) return @"02";
    if ([day isEqualToString:@"3"]) return @"03";
    if ([day isEqualToString:@"4"]) return @"04";
    if ([day isEqualToString:@"5"]) return @"05";
    if ([day isEqualToString:@"6"]) return @"06";
    if ([day isEqualToString:@"7"]) return @"07";
    if ([day isEqualToString:@"8"]) return @"08";
    if ([day isEqualToString:@"9"]) return @"09";
    return day;
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
