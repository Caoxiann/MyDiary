//
//  SqlService.h
//  My Diary
//
//  Created by 徐贤达 on 2017/2/2.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotePage.h"

@interface SqlService : NSObject


+(SqlService *)sqlInstance;

-(void)insertDBtable:(NotePage *)notePage;

-(void)updateDBtable:(NotePage *)notePage;

-(BOOL)deleteDBtableList:(NotePage *)notePage;

-(NSArray *)queryDBtable;


@end
