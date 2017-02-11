//
//  CalenderViewController.h
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "NoteBL.h"

@protocol selectedUpdate <NSObject>

- (void)selectedUpdate:(NSString*)string;

- (void)updateList;

@end

@interface CalendarViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,selectedUpdate> {
    
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    CGRect initFrame;
    int key;
}

@property (nonatomic,strong) NoteBL *bl;

@end
