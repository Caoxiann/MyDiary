//
//  VCDiaryWrite.h
//  MyDiary02
//
//  Created by 向尉 on 2017/1/20.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewCellDataSource;

@protocol VCDiaryWriteDelegate <NSObject>

-(void)addDiary:(TableViewCellDataSource *)data;

-(void)changeDiary:(TableViewCellDataSource *)data;

-(void)deleteDiary;

@end


@interface VCDiaryWrite : UIViewController<UITextViewDelegate>

@property (nonatomic, retain) UITextView *textView;

@property (nonatomic, weak) id<VCDiaryWriteDelegate> delegate;

@property (nonatomic, retain) TableViewCellDataSource *originData;

@property (nonatomic, retain) TableViewCellDataSource *data;

@end
