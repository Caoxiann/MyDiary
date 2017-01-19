//
//  sqlService.h
//  DemoOfNotes
//
//  Created by Wujianyun on 18/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Element.h"
#import "Diary.h"

@interface SqlService : NSObject
+(SqlService *)sqlInstance;

-(void)insertElementDBtable:(Element *)element;
-(void)insertDiaryDBtable:(Diary *)diary;

-(void)updateElementDBtable:(Element *)element;
-(void)updateDiaryDBtable:(Diary *)diary;

-(BOOL)deleteElement:(Element *) element;
-(BOOL)deleteDiary:(Diary *)diary;

-(NSArray *)queryElementDBtable;
-(NSArray *)queryDiaryDBtable;
@end
