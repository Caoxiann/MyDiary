//
//  VCElementEdit.h
//  MyDiary
//
//  Created by Jimmy Fan on 2017/2/7.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@protocol VCElementEditDelegate <NSObject>

- (void)changeID:(NSInteger)ID;

@end

@interface VCElementEdit : UIViewController <UITextViewDelegate> {
    FMDatabase* _mDB;
    UILabel* _lbTitle;
    UILabel* _lbContent;
    UITextField* _title;
    UITextView* _content;
    NSNumber* _id;
    NSInteger maxid;
}

@property (retain, nonatomic) NSNumber* myID;
@property (assign, nonatomic) NSInteger tag;
@property (assign, nonatomic) id<VCElementEditDelegate> delegate;


@end
