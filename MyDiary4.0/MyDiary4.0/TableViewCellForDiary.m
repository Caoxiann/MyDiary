//
//  TableViewCellForDiary.m
//  MyDiary3.0
//
//  Created by 向尉 on 2017/2/18.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "TableViewCellForDiary.h"

@implementation TableViewCellForDiary

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    UIBezierPath *maskPathForLabDate=[UIBezierPath bezierPathWithRoundedRect:self.labDate.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
//    UIBezierPath *maskPathForLabPalce=[UIBezierPath bezierPathWithRoundedRect:self.labPlace.bounds byRoundingCorners:UIRectCornerTopRight  cornerRadii:CGSizeMake(10, 10)];
//    
//    CAShapeLayer *maskLayer =[[CAShapeLayer alloc]init];
//    //
//    maskLayer.frame=self.labDate.bounds;
//    maskLayer.path=maskPathForLabDate.CGPath;
//    self.labDate.layer.mask=maskLayer;
//    //
//    
//    maskLayer.frame=self.labPlace.bounds;
//    maskLayer.path=maskPathForLabPalce.CGPath;
//    self.labPlace.layer.mask=maskLayer;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor *originColor=[self.labDate backgroundColor];
    [super setSelected:selected animated:animated];
    if (selected)
    {
        [self.labDate setBackgroundColor:originColor];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subView in self.subviews)
    {
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
        {
            subView.frame = CGRectMake(self.frame.origin.x+self.frame.size.width, 0, 60, self.frame.size.height);
            subView.backgroundColor=[UIColor clearColor];
            UIButton *confirmView=(UIButton *)[subView.subviews firstObject];
            [confirmView setBackgroundColor:[UIColor clearColor]];
            [confirmView setImage:[UIImage imageNamed:@"timg.jpeg"] forState:UIControlStateNormal];
            confirmView.imageEdgeInsets=UIEdgeInsetsMake(self.frame.size.height-50, 10, 0, 0);
//            for(UIView *sub in confirmView.subviews)
//            {
//                [sub removeFromSuperview];
//            }
//            UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timg.jpeg"]];
//            [imageView setFrame:CGRectMake(30, self.frame.size.height-40, 30, 40)];
//            //cRect=imageView.frame;
//            //cRect.origin.x=confirmView.bounds.size.width/2-cRect.size.width/2;
//            //cRect.origin.y=confirmView.bounds.size.height/2-cRect.size.height/2;
//            //[imageView setFrame:cRect];
//            [confirmView addSubview:imageView];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat totalHeight = 0;
    totalHeight += [self.labContent sizeThatFits:size].height;
    totalHeight += 80; // margins
    if (totalHeight>300) {
        totalHeight=300;
    }
    return CGSizeMake(size.width, totalHeight);
}
@end
