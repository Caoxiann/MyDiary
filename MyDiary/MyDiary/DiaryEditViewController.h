//
//  DiaryEditViewController.h
//  MyDiary
//
//  Created by tinoryj on 2017/2/8.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary.h"
#import "DiaryBL.h"

@protocol DiaryPageUpdateDelegate <NSObject>

-(void)updateTheDiaryList;

@end

@interface DiaryEditViewController : UIViewController

@property (nonatomic,strong)Diary *currentPage;

@property (nonatomic,strong)NSString *date;

@property (nonatomic,strong)UIColor *themeColor;

@property (nonatomic,weak)id<DiaryPageUpdateDelegate>  diaryDelegate;

//@property (nonatomic,weak)id<DiaryPageUpdateDelegate>  diaryDelegate;

@end
