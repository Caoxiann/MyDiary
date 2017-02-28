//
//  TableViewCellDataSource.h
//  MyDiary02
//
//  Created by 向尉 on 2017/2/8.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewCellDataSource : NSObject

@property (nonatomic, retain) NSString *text;

@property (nonatomic, assign) NSInteger hour;

@property (nonatomic, assign) NSInteger day;

@property (nonatomic, assign) NSInteger minute;

@property (nonatomic, assign) NSInteger year;

@property (nonatomic, assign) NSInteger month;

@property (nonatomic, retain) NSString *place;

-(id)initWithText:(NSString *)text Year:(NSInteger)year Month:(NSInteger) month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Place:(NSString *)place;

@end
