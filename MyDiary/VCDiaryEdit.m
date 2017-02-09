//
//  VCDiaryEdit.m
//  MyDiary
//
//  Created by Jimmy Fan on 2017/2/8.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import "VCDiaryEdit.h"

@interface VCDiaryEdit ()

@end

@implementation VCDiaryEdit

@synthesize myID = _id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView* _backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIImageView* _imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage.jpg"]];
    [_backgroundview addSubview:_imageview];
    [self.view addSubview:_backgroundview];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Edit Diary";
    UIBarButtonItem* btnFinish = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(pressFinish)];
    self.navigationItem.rightBarButtonItem = btnFinish;
    
    UILabel* _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 80, 50)];
    _lbTitle.text = @"标题：";
    _lbTitle.font = [UIFont systemFontOfSize:25];
    _lbTitle.textColor = [UIColor blackColor];
    [self.view addSubview:_lbTitle];
    _title = [[UITextField alloc] initWithFrame:CGRectMake(100, 80, 200, 50)];
    _title.borderStyle = UITextBorderStyleRoundedRect;
    _title.keyboardType = UIKeyboardTypeDefault;
    _title.font = [UIFont systemFontOfSize:25];
    _title.textColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
    [self.view addSubview:_title];
    UILabel* _lbContent = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, [UIScreen mainScreen].bounds.size.width, 50)];
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
    
    NSString* strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/datebase.db"];
    _mDB = [[FMDatabase alloc] initWithPath:strPath];
    if ([_mDB open]) {
        NSString* strQuery = @"select * from diary;";
        FMResultSet* result = [_mDB executeQuery:strQuery];
        while ([result next]) {
            if ([result intForColumn:@"id"] == [self.myID intValue]) {
                _title.text = [result stringForColumn:@"title"];
                _content.text = [result stringForColumn:@"content"];
            }
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_title resignFirstResponder];
    [_content resignFirstResponder];
}

- (void)pressFinish {
    if ([_mDB open]) {
        NSString* strTitle = [[NSString alloc] initWithFormat:@"update diary set title='%@' where id = %d;",_title.text, [self.myID intValue]];
        NSString* strContent = [[NSString alloc] initWithFormat:@"update diary set content='%@' where id = %d;",_content.text, [self.myID intValue]];
        [_mDB executeUpdate:strTitle];
        [_mDB executeUpdate:strContent];
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
