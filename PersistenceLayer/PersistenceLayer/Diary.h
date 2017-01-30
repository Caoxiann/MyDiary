//
//  Diary.h
//  PersistenceLayer
//
//  Created by tinoryj on 2017/1/30.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#ifndef Diary_h
#define Diary_h

#import <Foundation/Foundation.h>

@interface Diary : NSObject

@property(nonatomic, strong) NSDate* date;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* content;

-(id)initWithDate:(NSDate*)date title:(NSString*)title content:(NSString*)content;

@end


#endif /* Diary_h */
