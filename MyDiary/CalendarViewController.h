//
//  CalendarViewController.h
//  MyDiary
//
//  Created by Wujianyun on 16/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Element.h"

@protocol ElementPageDelegateInCVC <NSObject>

@required -(void)turnToElementPage:(Element *)element;

@end
@class MonthModel;
//控制器
@interface CalendarViewController : UIViewController
@property (strong, nonatomic) UIViewController <ElementPageDelegateInCVC > *delegate;
@property (nonatomic,assign) CGFloat viewHeight;
@end

//CollectionViewHeader
@interface CalendarHeaderView : UICollectionReusableView
@end

//UICollectionViewCell
@interface CalendarCell : UICollectionViewCell
@property (weak, nonatomic) UILabel *dayLabel;

@property (strong, nonatomic) MonthModel *monthModel;
@end

//存储模型
@interface MonthModel : NSObject
@property (assign, nonatomic) NSInteger dayValue;
@property (strong, nonatomic) NSDate *dateValue;
@property (assign, nonatomic) BOOL isToday;
@property (assign, nonatomic) BOOL isSelectedDay;
@end


@interface UIColor (UIColor)
+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha;
@end
