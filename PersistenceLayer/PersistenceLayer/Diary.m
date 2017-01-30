//
//  Diary.m
//  PersistenceLayer
//
//  Created by tinoryj on 2017/1/30.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "Diary.h"

@implementation Diary

-(id)initWithDate:(NSDate*)date title:(NSString*)title content:(NSString*)content {
    
    self = [super init];
    
    if (self) {
        self.date = date;
        self.title = title;
        self.content = content;
    }
    
    return self;
}

@end
