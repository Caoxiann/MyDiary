//
//  ElementViewController.h
//  MyDiary
//
//  Created by Wujianyun on 18/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElementViewController : UIViewController
@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong)NSArray * elementListArray;
@property (nonatomic,strong)NSMutableArray <__kindof NSArray *> * elementForMonthArray;

@end
