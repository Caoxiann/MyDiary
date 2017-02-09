//
//  DiaryEditViewController.m
//  MyDiary
//
//  Created by tinoryj on 2017/2/8.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "DiaryEditViewController.h"
#import "Note.h"
#import "NoteBL.h"

@interface DiaryEditViewController ()

@end

@implementation DiaryEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor redColor]];
    [self configureView];
    
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    if (self.detailItem) {
        Note* note = self.detailItem;
        UILabel *detailDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, [UIScreen mainScreen].bounds.size.width, 300)];
        [detailDescriptionLabel setTextColor:[UIColor blackColor]];
        [detailDescriptionLabel setBackgroundColor:[UIColor yellowColor]];
        [self.view addSubview:detailDescriptionLabel];
        detailDescriptionLabel.text = note.content;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
