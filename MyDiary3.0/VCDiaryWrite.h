//
//  VCDiaryWrite.h
//  MyDiary02
//
//  Created by 向尉 on 2017/1/20.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCellDataSource.h"

@protocol VCDiaryWriteDelegate <NSObject>

-(void)addDiary:(TableViewCellDataSource *)data;

-(void)changeDiary:(TableViewCellDataSource *)data;

-(void)deleteDiary;

@end


@interface VCDiaryWrite : UIViewController

@property (nonatomic, retain) UITextView *textView;

@property (nonatomic, weak) id<VCDiaryWriteDelegate> delegate;

@property (nonatomic, retain) TableViewCellDataSource *originData;

@end
