//
//  DateDeal.h
//  MyDiary
//
//  Created by Wujianyun on 07/02/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ViewController) {
    ViewControllerElement=0,
    ViewControllerCalendar=1,
    ViewControllerDiary=2,
};
@interface DateDeal : NSObject
+ (NSMutableArray <__kindof NSMutableArray *> *)dateDealFor:(ViewController)viewController andDate:(NSDate *)date;
@end
