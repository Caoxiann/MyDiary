//
//  Item.h
//  MyDiary
//
//  Created by Wujianyun on 15/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *date;
@property (nonatomic,assign)NSInteger itemID;

+(void)creatItemWithContent:(NSString *)content andTime:(NSString *)time andDate:(NSString *)date;
+(void)updateItemWithContent:(NSString *)content andTime:(NSString *)time andDate:(NSString *)date currentItem:(Item *)item;
+(void)deleteItem:(Item *)item;
@end
