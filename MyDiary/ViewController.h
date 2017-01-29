//
//  ViewController.h
//  MyDiary
//
//  Created by Wujianyun on 16/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Element.h"
#import "Diary.h"
#import "ElementPage.h"
#import "DiaryPage.h"
#import "ElementViewController.h"
#import "CalendarViewController.h"
#import "DiaryViewController.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
- (IBAction)segment:(UISegmentedControl *)sender;
- (IBAction)setButton:(UIButton *)sender;
- (IBAction)addButton:(UIButton *)sender;
- (IBAction)photoButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *testTimeLabel;
@property (nonatomic ,strong) UIViewController *currentVC;
@property (nonatomic,strong)NSMutableArray *childControllersArray;
@end

