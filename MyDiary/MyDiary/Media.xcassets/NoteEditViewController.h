//
//  NoteEditViewController.h
//  MyDiary
//
//  Created by tinoryj on 2017/2/8.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteBL.h"
#import "Note.h"
@interface NoteEditViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *txtView;

- (IBAction)onclickDone:(id)sender;

- (IBAction)onclickSave:(id)sender;

@end
