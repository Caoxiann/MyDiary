//
//  ViewController.m
//  MyDiary
//
//  Created by Wujianyun on 16/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "ViewController.h"
#import "TimeDealler.h"

@interface ViewController ()
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - segment
- (IBAction)segment:(UISegmentedControl *)sender {
    //pageSwitch
    switch (sender.selectedSegmentIndex) {
        case 0:
            _topLabel.text=@"ELEMENTS";
            break;
        case 1:
            _topLabel.text=@"CALENDAR";
            break;
        case 2:
            _topLabel.text=@"DIARY";
            break;
        default:
            NSLog(@"segment error");
            break;
    }
    _currentPage=sender.selectedSegmentIndex;
}

#pragma mark - Buttons
- (IBAction)setButton:(UIButton *)sender {
}

- (IBAction)addButton:(UIButton *)sender {
}

- (IBAction)photoButton:(UIButton *)sender {
}
@end
