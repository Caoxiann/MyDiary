//
//  MyCell.m
//  MyDiary
//
//  Created by Jimmy Fan on 2017/2/4.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _day = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 60)];
        UIBezierPath* maskPath01 = [UIBezierPath bezierPathWithRoundedRect:_day.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer* maskLayer01 = [[CAShapeLayer alloc] init];
        maskLayer01.frame = _day.bounds;
        maskLayer01.path = maskPath01.CGPath;
        _day.layer.mask = maskLayer01;
        [self.contentView addSubview:_day];
        
        _week = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 60, 30)];
        UIBezierPath* maskPath02 = [UIBezierPath bezierPathWithRoundedRect:_week.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer* maskLayer02 = [[CAShapeLayer alloc] init];
        maskLayer02.frame = _week.bounds;
        maskLayer02.path = maskPath02.CGPath;
        _week.layer.mask = maskLayer02;
        [self.contentView addSubview:_week];
  
        UIView* _view02 = [[UIView alloc] initWithFrame:CGRectMake(80, 0, [UIScreen mainScreen].bounds.size.width - 100, 80)];
        UIBezierPath* maskPath03 = [UIBezierPath bezierPathWithRoundedRect:_view02.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer* maskLayer03 = [[CAShapeLayer alloc] init];
        maskLayer03.frame = _view02.bounds;
        maskLayer03.path = maskPath03.CGPath;
        _view02.layer.mask = maskLayer03;
        _view02.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_view02];
  
        _title = [[UILabel alloc] initWithFrame:CGRectMake(95, 20, 190, 40)];
        [self.contentView addSubview:_title];
        _minute = [[UILabel alloc] initWithFrame:CGRectMake(95, 7, 50, 20)];
        [self.contentView addSubview:_minute];

        _city = [[UILabel alloc] initWithFrame:CGRectMake(95, 53, 190, 20)];
        [self.contentView addSubview:_city];
    }
    return self;
}

- (NSString*)transformIntoChinese:(NSString*)week {
    if ([week isEqualToString:@"Monday"]) return @"星期一";
    if ([week isEqualToString:@"Tuesday"]) return @"星期二";
    if ([week isEqualToString:@"Wednesday"]) return @"星期三";
    if ([week isEqualToString:@"Thursday"]) return @"星期四";
    if ([week isEqualToString:@"Friday"]) return @"星期五";
    if ([week isEqualToString:@"Saturday"]) return @"星期六";
    if ([week isEqualToString:@"Sunday"]) return @"星期日";
    return week;
}

- (void)setMonth:(NSString *)month Day:(NSString *)day Week:(NSString *)week Title:(NSString *)title Content:(NSString *)content Minute:(NSString *)minute SubLocality:(NSString *)sublocality City:(NSString *)city {
    _day.text = day;
    _day.font = [UIFont systemFontOfSize:45];
    _day.textColor = [UIColor whiteColor];
    _day.layer.borderWidth = 0;
    [_day setTextAlignment:NSTextAlignmentCenter];
    _day.backgroundColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
    
    _week.text = [self transformIntoChinese:week];
    _week.font = [UIFont systemFontOfSize:11];
    _week.textColor = [UIColor whiteColor];
    _week.layer.borderWidth = 0;
    [_week setTextAlignment:NSTextAlignmentCenter];
    _week.backgroundColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
    
    _minute.text = minute;
    _minute.font = [UIFont systemFontOfSize:11];
    _minute.textColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
    
    _title.text = title;
    _title.font = [UIFont systemFontOfSize:25];
    _title.textColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
    
    _city.text = [NSString stringWithFormat:@"%@ %@",city,sublocality];
    _city.font = [UIFont systemFontOfSize:12];
    _city.textColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
