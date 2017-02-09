//
//  MyCellDiary.m
//  MyDiary
//
//  Created by Jimmy Fan on 2017/2/8.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import "MyCellDiary.h"

@implementation MyCellDiary

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
        
        _week = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 60, 15)];
        [self.contentView addSubview:_week];
        
        UIView* _view = [[UIView alloc] initWithFrame:CGRectMake(20, 75, 60, 5)];
        _view.backgroundColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
        [self.contentView addSubview:_view];
        
        UIView* _view02 = [[UIView alloc] initWithFrame:CGRectMake(80, 0, [UIScreen mainScreen].bounds.size.width - 100, 80)];
        UIBezierPath* maskPath03 = [UIBezierPath bezierPathWithRoundedRect:_view02.bounds byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer* maskLayer03 = [[CAShapeLayer alloc] init];
        maskLayer03.frame = _view02.bounds;
        maskLayer03.path = maskPath03.CGPath;
        _view02.layer.mask = maskLayer03;
        _view02.backgroundColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
        [self.contentView addSubview:_view02];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, 190, 40)];
        [self.contentView addSubview:_title];
        
        _view03 = [[UIView alloc] init];
        _view03.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_view03];
        
        _content = [[UILabel alloc] initWithFrame:CGRectMake(30, 90, [UIScreen mainScreen].bounds.size.width - 60, 0)];
        _content.numberOfLines = 0;
        _content.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:_content];
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

- (void)setMonth:(NSString *)month Day:(NSString *)day Week:(NSString *)week Title:(NSString *)title Content:(NSString *)content {
    _day.text = day;
    _day.font = [UIFont systemFontOfSize:45];
    _day.textColor = [UIColor whiteColor];
    _day.layer.borderWidth = 0;
    [_day setTextAlignment:NSTextAlignmentCenter];
    _day.backgroundColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
    
    _week.text = [self transformIntoChinese:week];
    _week.font = [UIFont systemFontOfSize:10];
    _week.textColor = [UIColor whiteColor];
    _week.layer.borderWidth = 0;
    [_week setTextAlignment:NSTextAlignmentCenter];
    _week.backgroundColor = [UIColor colorWithDisplayP3Red:123/255.0 green:181/255.0 blue:217/255.0 alpha:255];
    
    _title.text = title;
    _title.font = [UIFont systemFontOfSize:30];
    _title.textColor = [UIColor whiteColor];
    
    _content.text = content;
    _content.font = [UIFont systemFontOfSize:18];
    CGRect contentRect = [content boundingRectWithSize:_content.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_content.font, NSFontAttributeName, nil] context:nil];
    _content.frame = CGRectMake(30, 90, [UIScreen mainScreen].bounds.size.width - 60, contentRect.size.height);
    
    _view03.frame = CGRectMake(20, 80, [UIScreen mainScreen].bounds.size.width - 40, _content.frame.size.height + 20);
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:_view03.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _view03.bounds;
    maskLayer.path = maskPath.CGPath;
    _view03.layer.mask = maskLayer;

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
