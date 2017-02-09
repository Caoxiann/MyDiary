//
//  VCDiaryAdd.h
//  MyDiary
//
//  Created by Jimmy Fan on 2017/2/8.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface VCDiaryAdd : UIViewController <UITextViewDelegate> {
    FMDatabase* _mDB;
    UILabel* _lbTitle;
    UILabel* _lbContent;
    UITextField* _tfTitle;
    UITextView* _tvContent;
}

@end
