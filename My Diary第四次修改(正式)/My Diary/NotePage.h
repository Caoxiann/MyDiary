//
//  NotePage.h
//  My Diary
//
//  Created by 徐贤达 on 2017/2/2.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotePage : NSObject

@property (nonatomic,strong)NSString *titile;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,assign)NSInteger noteID;

@end
