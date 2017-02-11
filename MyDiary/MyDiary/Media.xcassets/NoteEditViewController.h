//
//  NoteEditViewController.h
//  MyDiary
//
//  Created by tinoryj on 2017/2/8.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NoteBL.h"
#import "Note.h"

@protocol NotePageUpdateDelegate <NSObject>

- (void)updateTheNoteList;

@end

@interface NoteEditViewController : UIViewController

@property (nonatomic,strong) Note *currentPage;

@property (nonatomic,weak) id<NotePageUpdateDelegate>  noteDelegate;

@end
