//
//  NotePageController.h
//  My Diary
//
//  Created by 徐贤达 on 2017/2/2.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotePage.h"
#import "NotePageUpdateDelegate.h"
#import "BXMainPage.h"


#define deviceWidth [UIScreen mainScreen].bounds.size.width
#define deviceHeight [UIScreen mainScreen].bounds.size.height


@interface NotePageController : UIViewController

@property (nonatomic,strong)NotePage *currentPage;

@property (nonatomic,weak) id<NotePageUpdateDelegate>  noteDelegate;

@property (nonatomic,weak) id<backFirst> backFirst;

- (IBAction)pressBack:(id)sender;

- (IBAction)rightButtonAction:(id)sender;

@end
