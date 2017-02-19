//
//  DiaryPage.h
//  MyDiary
//
//  Created by Wujianyun on 17/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary.h"
@protocol DiaryReloadDelegate <NSObject>

@required - (void)reloadData;

@end
@interface DiaryPage : UIViewController
- (IBAction)backBtn:(UIButton *)sender;
- (IBAction)saveBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *textViewBackView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,strong) UIViewController <DiaryReloadDelegate> *delegate;
- (IBAction)getLocation:(UIButton *)sender;

@property (nonatomic ,strong)Diary *diary;
@property (assign, nonatomic) BOOL isNew;
@property (assign, nonatomic) BOOL isSaved;
@end
