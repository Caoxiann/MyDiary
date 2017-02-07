//
//  VCCalendar.h
//  MyDiary
//
//  Created by Jimmy Fan on 2017/1/22.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface VCCalendar : UIViewController {
    UISegmentedControl* _segControl;
    FMDatabase* _mDB;
}

@end
