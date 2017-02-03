//
//  NotePageSearvice.h
//  My Diary
//
//  Created by 徐贤达 on 2017/2/2.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotePage.h"

@interface NotePageSearvice : NSObject

+(void)creatNotepage:(NSString *)content title:(NSString*)titile;

+(void)updateNotePage:(NSString *)content title:(NSString*)titile currentNotePage:(NotePage *)notePage;

+(void)deleteNotePage:(NSString *)content title:(NSString*)titile currentNotePage:(NotePage *)notePage;


@end
