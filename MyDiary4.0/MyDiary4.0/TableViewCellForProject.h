//
//  TableViewCellForProject.h
//  MyDiary02
//
//  Created by 向尉 on 2017/2/1.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableViewCellForProject : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labContent;
@property (strong, nonatomic) IBOutlet UILabel *labDate;
@property (strong, nonatomic) IBOutlet UILabel *labTime;
@property (strong, nonatomic) IBOutlet UILabel *labPlace;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, weak) id delegate;
@end
