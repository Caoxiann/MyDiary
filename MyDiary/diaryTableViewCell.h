//
//  diaryTableViewCell.h
//  MyDiary
//
//  Created by Wujianyun on 22/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary.h"
#define LL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define Iphone6ScaleWidth(x) ((x) * LL_SCREEN_WIDTH /375.0f)
#define Iphone6ScaleHeight(x) ((x) * LL_SCREEN_HEIGHT/667.0f)
@interface diaryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (nonatomic,assign)NSInteger height;
- (IBAction)editButton:(UIButton *)sender;
-(void)setDiary:(Diary *)diary;

@end
