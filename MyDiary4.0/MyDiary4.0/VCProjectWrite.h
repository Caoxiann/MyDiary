//
//  VCProjectWrite.h
//  MyDiary02
//
//  Created by 向尉 on 2017/1/20.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewCellDataSource;

@protocol VCProjectWriteDelegate <NSObject>
/* add projcet in VCproject when created a new project*/
-(void)addProject:(TableViewCellDataSource *)data;
/* change the content after selecting a cell*/
-(void)changeProject:(TableViewCellDataSource *)data;
/* delete project*/
-(void)deleteProject;
@end

@interface VCProjectWrite : UIViewController<UITextViewDelegate>

@property (nonatomic,retain) UITextView *textView;

@property (nonatomic,retain) UIDatePicker *timePicker;

@property (nonatomic,weak) id<VCProjectWriteDelegate> delegate;

@end
