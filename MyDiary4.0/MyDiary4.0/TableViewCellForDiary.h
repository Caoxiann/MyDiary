//
//  TableViewCellForDiary.h
//  MyDiary3.0
//
//  Created by 向尉 on 2017/2/18.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellForDiary : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labDate;
@property (strong, nonatomic) IBOutlet UILabel *labTime;
@property (strong, nonatomic) IBOutlet UILabel *labPlace;
@property (strong, nonatomic) IBOutlet UILabel *labContent;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@end
