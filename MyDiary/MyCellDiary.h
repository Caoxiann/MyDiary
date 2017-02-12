//
//  MyCellDiary.h
//  MyDiary
//
//  Created by Jimmy Fan on 2017/2/8.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCellDiary : UITableViewCell {
    UILabel* _title;
    UILabel* _day;
    UILabel* _month;
    UILabel* _week;
    UILabel* _content;
    UIView* _view03;
    UILabel* _sublocality;
    UILabel* _city;
}

- (void)setMonth:(NSString*)month Day:(NSString*)day Week:(NSString*)week Title:(NSString*)title Content:(NSString*)content SubLocality:(NSString*)sublocality City:(NSString*)city;

@end
