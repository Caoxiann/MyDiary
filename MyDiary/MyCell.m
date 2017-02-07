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
        UIBezierPath* maskPath01 = [UIBezierPath bezierPathWithRoundedRect:_day.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer* maskLayer01 = [[CAShapeLayer alloc] init];
        maskLayer01.frame = _day.bounds;
        maskLayer01.path = maskPath01.CGPath;
        _day.layer.mask = maskLayer01;
        [self.contentView addSubview:_day];
        
        _week = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 60, 15)];
        [self.contentView addSubview:_week];
  
        UIView* _view = [[UIView alloc] initWithFrame:CGRectMake(20, 75, 60, 5)];
        UIBezierPath* maskPath02 = [UIBezierPath bezierPathWithRoundedRect:_view.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer* maskLayer02 = [[CAShapeLayer alloc] init];
        maskLayer02.frame = _view.bounds;
        maskLayer02.path = maskPath02.CGPath;
        _view.layer.mask = maskLayer02;
        _view.backgroundColor = [UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255];
        [self.contentView addSubview:_view];
        
        UIView* _view02 = [[UIView alloc] initWithFrame:CGRectMake(80, 0, [UIScreen mainScreen].bounds.size.width - 100, 80)];
        UIBezierPath* maskPath03 = [UIBezierPath bezierPathWithRoundedRect:_view02.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer* maskLayer03 = [[CAShapeLayer alloc] init];
        maskLayer03.frame = _view02.bounds;
        maskLayer03.path = maskPath03.CGPath;
        _view02.layer.mask = maskLayer03;
        _view02.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_view02];
  
        _title = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, 190, 40)];
        [self.contentView addSubview:_title];
        _minute = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 50, 20)];
        [self.contentView addSubview:_minute];

        
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
    return nil;
}

- (void)setMonth:(NSString *)month Day:(NSString *)day Week:(NSString *)week Title:(NSString *)title Content:(NSString *)content Minute:(NSString *)minute {
    _day.text = day;
    _day.font = [UIFont systemFontOfSize:45];
    _day.textColor = [UIColor whiteColor];
    _day.layer.borderWidth = 0;
    [_day setTextAlignment:NSTextAlignmentCenter];
    _day.backgroundColor = [UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255];
    
    _week.text = [self transformIntoChinese:week];
    _week.font = [UIFont systemFontOfSize:10];
    _week.textColor = [UIColor whiteColor];
    _week.layer.borderWidth = 0;
    [_week setTextAlignment:NSTextAlignmentCenter];
    _week.backgroundColor = [UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255];
    
    _minute.text = minute;
    _minute.font = [UIFont systemFontOfSize:10];
    _minute.textColor = [UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255];
    
    _title.text = title;
    _title.font = [UIFont systemFontOfSize:25];
    _title.textColor = [UIColor colorWithDisplayP3Red:105/255.0 green:215/255.0 blue:221/255.0 alpha:255];

}
/*
- (void)setFrame:(CGRect)frame {
    frame.origin.x += 20;
    frame.size.width -= 40;
    [super setFrame:frame];
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return NO;
    }
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
