//
//  Note.m
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "Note.h"

@implementation Note

- (id)initWithDate:(NSDate*)date title:(NSString *)title content:(NSString *)content location:(NSString *)location{
    
    self = [super init];
    
    if (self) {
        self.date = date;
        self.title = title;
        self.content = content;
        self.location = location;
        
    }
    return self;
}

@end
