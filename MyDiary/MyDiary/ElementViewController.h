//
//  ElementViewController.h
//  MyDiary
//
//  Created by tinoryj on 2017/1/31.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "NoteBL.h"
#import "NoteEditViewController.h"

@interface ElementViewController : UIViewController

- (void)note;

//保存数据列表
@property (nonatomic,strong) NSMutableArray* listData;

@property (nonatomic,strong) NoteBL* bl;

@end
