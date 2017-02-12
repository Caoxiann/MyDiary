//
//  MyCell.h
//  MyDiary
//
//  Created by Jimmy Fan on 2017/2/4.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell {
    UILabel* _title;
    UILabel* _day;
    UILabel* _month;
    UILabel* _week;
    UILabel* _content;
    UILabel* _minute;
    UILabel* _sublocality;
    UILabel* _city;
}

- (void)setMonth:(NSString*)month Day:(NSString*)day Week:(NSString*)week Title:(NSString*)title Content:(NSString*)content Minute:(NSString*)minute SubLocality:(NSString*)sublocality City:(NSString*)city;

@end
