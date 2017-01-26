//
//  Element.h
//  MyDiary
//
//  Created by Wujianyun on 15/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Element : NSObject
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *day;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *month;
@property (nonatomic,strong)NSString *year;
@property (nonatomic,strong)NSMutableDictionary* date;
@property (nonatomic,assign)NSInteger elementID;

+(void)creatElementWithContent:(NSString *)content andTime:(NSString *)time andDate:(NSString *)date;
+(void)updateElementWithContent:(NSString *)content andTime:(NSString *)time andDate:(NSString *)date currentElement:(Element *)element;
+(void)deleteElement:(Element *)element;
-(void)setDates;
@end
