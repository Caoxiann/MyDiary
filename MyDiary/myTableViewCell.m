//
//  myTableViewCell.m
//  MyDiary
//
//  Created by Wujianyun on 17/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "myTableViewCell.h"
@implementation myTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    // Initialization code
}
- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in self.subviews){
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            CGRect cRect = subView.frame;
            if(_element.isSelected){
                cRect.origin.y=_detailView.frame.origin.y;
                cRect.size.height=_detailView.frame.size.height;
            }else{
                cRect.origin.y=_view1.frame.origin.y;
                cRect.size.height=_view1.frame.size.height;
            }
            subView.frame = cRect;
            subView.backgroundColor=[UIColor clearColor];
            UIButton *confirmView=(UIButton *)[subView.subviews firstObject];
            [confirmView setBackgroundColor:[UIColor clearColor]];
            for(UIView *sub in confirmView.subviews){
                [sub removeFromSuperview];
                }
            UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"trashCan"]];
            cRect=imageView.frame;
            cRect.origin.x=confirmView.bounds.size.width/2-cRect.size.width/2;
            cRect.origin.y=confirmView.bounds.size.height/2-cRect.size.height/2;
            [imageView setFrame:cRect];
            [confirmView addSubview:imageView];
        }
    }
}

- (void)drawInitialView{
    //设置圆角
    /*UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_view2.bounds byRoundingCorners:UIRectCornerTopLeft| UIRectCornerBottomLeft cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _view2.bounds;
    maskLayer.path = maskPath.CGPath;
    _view2.layer.mask = maskLayer;
    */
    [_view1 setFrame:CGRectMake(Iphone6ScaleWidth(20), Iphone6ScaleHeight(10), Iphone6ScaleWidth(333), Iphone6ScaleHeight(80))];
    _view1.layer.cornerRadius=10;
    _view1.layer.masksToBounds = YES;
    _detailView.alpha=0;
}
-(void)drawDetailView{
    _detailView.layer.cornerRadius=10;
    _detailView.layer.masksToBounds=YES;
    _view1.alpha=0;
    _detailView.alpha=1;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(Element *)setMyElement:(Element *)element{
    _element=element;
    self.dayLabel.text=element.day;
    self.timeLabel.text=element.time;
    self.contentLabel.text=element.content;
    self.titleLabel.text=element.title;
    self.dayLabel2.text=element.day;
    self.timeLabel2.text=element.time;
    self.titleLabel2.text=element.title;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    UIFont *font=[UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    [_contentLabel setFont:font];
    CGRect tmpRect = [_contentLabel.text boundingRectWithSize:CGSizeMake(Iphone6ScaleWidth(273), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    [_detailView setFrame:CGRectMake(Iphone6ScaleWidth(20),Iphone6ScaleHeight(10), Iphone6ScaleWidth(333), Iphone6ScaleWidth(96)+tmpRect.size.height)];
    [_headView setFrame:CGRectMake(0, 0, _headView.superview.frame.size.width, Iphone6ScaleHeight(80))];
    [_contentLabel setFrame:CGRectMake(Iphone6ScaleWidth(33), Iphone6ScaleHeight(88), Iphone6ScaleWidth(273),tmpRect.size.height)];
    element.cellHeight= [[NSString alloc]initWithFormat:@"%f",_detailView.frame.size.height+Iphone6ScaleHeight(20)];
    return element;
}

@end

