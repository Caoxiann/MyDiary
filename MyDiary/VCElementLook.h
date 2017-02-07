//
//  VCElementLook.h
//  MyDiary
//
//  Created by Jimmy Fan on 2017/2/5.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface VCElementLook : UIViewController <UITextViewDelegate> {
    FMDatabase* _mDB;
    UITextField* _title;
    UITextView* _content;
    NSNumber* _id;
}

@property (retain, nonatomic) NSNumber* myID;

@end
