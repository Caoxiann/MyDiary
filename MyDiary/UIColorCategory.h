//
//  UIColorCategory.h
//  MyDiary
//
//  Created by Wujianyun on 08/02/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColorCategory)
+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha;
@end
