//
//  ViewController.m
//  MyDiary
//
//  Created by Wujianyun on 16/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

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
- (IBAction)segment:(UISegmentedControl *)sender {
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
}

- (IBAction)setButton:(UIButton *)sender {
}

- (IBAction)addButton:(UIButton *)sender {
}

- (IBAction)photoButton:(UIButton *)sender {
}
@end
