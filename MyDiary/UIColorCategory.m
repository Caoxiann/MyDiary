//
//  UIColorCategory.m
//  MyDiary
//
//  Created by Wujianyun on 08/02/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//
#import "UIColorCategory.h"
@implementation UIColor (UIColorCategory)
+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((hexValue >> 16) & 0x000000FF)/255.0f
                           green:((hexValue >> 8) & 0x000000FF)/255.0f
                            blue:((hexValue) & 0x000000FF)/255.0
                           alpha:alpha];
}
@end
