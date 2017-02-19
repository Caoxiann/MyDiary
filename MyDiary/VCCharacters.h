//
//  VCCharacters.h
//  MyDiary
//
//  Created by Jimmy Fan on 2017/1/24.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface VCCharacters : UIViewController <UITextViewDelegate> {
    FMDatabase* _mDB;
    UILabel* _lbTitle;
    UILabel* _lbContent;
    UILabel* _lbLocation;
    UITextField* _tfTitle;
    UITextView* _tvContent;
    UITextField* _tfCity;
    UITextField* _tfSublocality;
    NSString* strSubLocality;
    NSString* strCity;
}

@end
