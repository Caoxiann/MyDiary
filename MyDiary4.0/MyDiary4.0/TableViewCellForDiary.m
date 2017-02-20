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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
