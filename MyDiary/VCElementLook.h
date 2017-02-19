//
//  VCElementLook.h
//  MyDiary
//
//  Created by Jimmy Fan on 2017/2/5.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "VCElementEdit.h"

@interface VCElementLook : UIViewController <UITextViewDelegate,VCElementEditDelegate> {
    FMDatabase* _mDB;
    UITextField* _title;
    UITextView* _content;
    NSNumber* _id;
}

- (void)changeID:(NSInteger)ID;

@property (retain, nonatomic) NSNumber* myID;

@end
