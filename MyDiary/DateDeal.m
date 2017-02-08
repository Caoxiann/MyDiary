//
//  DateDeal.m
//  MyDiary
//
//  Created by Wujianyun on 07/02/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "DateDeal.h"
#import "Element.h"
#import "Diary.h"
#import "SqlService.h"
@implementation DateDeal
+ (NSMutableArray <__kindof NSMutableArray *> *)dateDealFor:(ViewController)viewController andDate:(NSDate *)date {
    NSMutableArray <__kindof NSMutableArray *> *resultArr=[[NSMutableArray alloc]init];
    NSLog(@"%ld",(long)viewController);
    if(ViewControllerElement==viewController) {
        //ElementViewController
        NSArray *array=[[SqlService sqlInstance] queryElementDBtable];
        if(array.count) {
            for(int i=1;i<13;i++) {
                NSMutableArray *arr=[[NSMutableArray alloc]init];
                [resultArr addObject:arr];
            }
            for(Element * ele in array){
                for(int i=1;i<13;i++){
                    NSString * monthStr=[NSString stringWithFormat:@"%02d",i];
                    if([ele.month isEqualToString:monthStr]) {
                        //NSLog(@"%@",monthStr);
                        [resultArr[i-1] addObject:ele];
                        break;
                    }
                }
            }
        }
    }else if(ViewControllerCalendar==viewController) {
        //CalendarViewController
        NSArray *array=[[SqlService sqlInstance] queryElementDBtable:date];
        if(array.count) {
            NSMutableArray *arr=[[NSMutableArray alloc]init];
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyyMMdd"];
            NSString *selectedDateStr=[formatter stringFromDate:date];
            for(Element *ele in array) {
                NSString *dateStr=[[ele.year stringByAppendingString:ele.month]stringByAppendingString:ele.day];
                if([selectedDateStr isEqualToString:dateStr]) {
                    [arr addObject:ele];
                }
            }
            [resultArr addObject:arr];
            return resultArr;
        }
    }else {
        //DiaryViewController
        NSArray *array=[[SqlService sqlInstance] queryDiaryDBtable];
        if(array.count) {
            for(int i=1;i<13;i++) {
                NSMutableArray *arr=[[NSMutableArray alloc]init];
                [resultArr addObject:arr];
            }
            for(Element * ele in array){
                for(int i=1;i<13;i++){
                    NSString * monthStr=[NSString stringWithFormat:@"%02d",i];
                    if([ele.month isEqualToString:monthStr]) {
                        NSLog(@"%@",monthStr);
                        [resultArr[i-1] addObject:ele];
                        break;
                    }
                }
            }
        }
    }
    
    return resultArr;
}

@end


