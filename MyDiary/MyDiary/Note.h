//
//  Note.h
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property(nonatomic, strong) NSDate* date;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* content;
@property(nonatomic, strong) NSString* location;

-(id)initWithDate:(NSDate*)date title:(NSString*)title content:(NSString*)content location:(NSString*)location;

@end
