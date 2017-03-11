//
//  TableViewCellForProject.m
//  MyDiary02
//
//  Created by 向尉 on 2017/2/1.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "TableViewCellForProject.h"

@implementation TableViewCellForProject

/*-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        
        UIView *deleteView=[[UIView alloc]initWithFrame:CGRectMake(self.frame.origin.x+self.frame.size.width, 0, 30, 40)];
        [self.contentView addSubview:deleteView];
        UIButton *deleteBtn=
        
        [deleteView addSubview:deleteBtn];
        
    }
    return self;
}*/
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//
-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subView in self.subviews)
    {
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
        {
            subView.backgroundColor=[UIColor clearColor];
            UIButton *confirmView=(UIButton *)[subView.subviews firstObject];
            [confirmView setBackgroundColor:[UIColor clearColor]];
            [confirmView setImage:[UIImage imageNamed:@"trashcan.png"] forState:UIControlStateNormal];
            confirmView.imageEdgeInsets=UIEdgeInsetsMake(self.frame.size.height-50, 10, 0, 0);
//            for(UIView *sub in confirmView.subviews)
//            {
////                [sub removeFromSuperview];
//            }
//            UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timg.jpeg"]];
//            [imageView setFrame:CGRectMake(30, self.frame.size.height-40, 30, 40)];
//            [confirmView addSubview:imageView];
        }
    }
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

@end
