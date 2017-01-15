//
//  sqlService.h
//  DemoOfNotes
//
//  Created by Wujianyun on 18/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Diary.h"

@interface SqlService : NSObject
+(SqlService *)sqlInstance;

-(void)insertItemDBtable:(Item *)item;
-(void)insertDiaryDBtable:(Diary *)diary;

-(void)updateItemDBtable:(Item *)item;
-(void)updateDiaryDBtable:(Diary *)diary;

-(BOOL)deleteItem:(Item *) item;
-(BOOL)deleteDiary:(Diary *)diary;

-(NSArray *)queryItemDBtable;
-(NSArray *)queryDiaryDBtable;
@end
