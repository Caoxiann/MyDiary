//
//  DiaryViewController.h
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary.h"
#import "DiaryBL.h"
#import "DiaryEditViewController.h"

@interface DiaryViewController : UIViewController

- (void)diary;

//保存数据列表
@property (nonatomic,strong) NSMutableArray* listData;

@property (nonatomic,strong) DiaryBL* bl;

@end

