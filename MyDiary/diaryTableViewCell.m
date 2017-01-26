//
//  diaryTableViewCell.m
//  MyDiary
//
//  Created by Wujianyun on 22/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "diaryTableViewCell.h"

@implementation diaryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self drawView];
    [self setBackgroundColor:[UIColor clearColor]];
    // Initialization code
}
- (void)drawView{
    //设置圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_view2.bounds byRoundingCorners:UIRectCornerTopLeft| UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _view2.bounds;
    maskLayer.path = maskPath.CGPath;
    _view2.layer.mask = maskLayer;
    

    _view1.layer.cornerRadius=10;
    _view1.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editButton:(UIButton *)sender {
}
-(void)setDiary:(Diary *)diary{
    _titleLabel.text=diary.title;
    _dayLabel.text=diary.day;
    _contentLabel.text=diary.content;
}
@end
