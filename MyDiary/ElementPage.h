//
//  ElementPage.h
//  MyDiary
//
//  Created by Wujianyun on 17/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Element.h"
@protocol ElementReloadDelegate <NSObject>

@required - (void)reloadData;

@end
@interface ElementPage : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *timeSetBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationSetBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateSetBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *dateSetView;
@property (weak, nonatomic) IBOutlet UIView *TimeSetView;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,strong) UIViewController <ElementReloadDelegate> *delegate;
@property (assign, nonatomic) BOOL isNew;
- (IBAction)editingDidEnd:(UITextField *)sender;
- (IBAction)saveBtn:(UIButton *)sender;
- (IBAction)cancelBtn:(UIButton *)sender;
- (IBAction)setTime:(UIButton *)sender;
- (IBAction)setLocation:(UIButton *)sender;
- (IBAction)setDate:(UIButton *)sender;
- (IBAction)timeConfirm:(UIButton *)sender;
- (IBAction)timeCancel:(UIButton *)sender;
- (IBAction)dateConfirm:(UIButton *)sender;
- (IBAction)dateCancel:(UIButton *)sender;
@property (nonatomic,strong)Element* element;
@end

