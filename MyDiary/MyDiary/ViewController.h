//
//  ViewController.h
//  MyDiary
//
//  Created by Wujianyun on 16/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
- (IBAction)segment:(UISegmentedControl *)sender;
- (IBAction)setButton:(UIButton *)sender;
- (IBAction)addButton:(UIButton *)sender;
- (IBAction)photoButton:(UIButton *)sender;

@end

