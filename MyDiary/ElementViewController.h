//
//  ElementViewController.h
//  MyDiary
//
//  Created by Wujianyun on 18/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Element.h"

@protocol ElementPageDelegate <NSObject>

@required - (void)turnToElementPage:(Element *)element;
@required - (void)updateNumOfItems:(NSString *)num;
@end

@interface ElementViewController : UIViewController
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray <__kindof NSMutableArray *> * cellHeights;
@property (nonatomic,strong) NSMutableArray <__kindof NSMutableArray *> * elementForMonthArray;
@property (nonatomic,strong) UIViewController<ElementPageDelegate> * delegate;
@property (nonatomic,assign) CGFloat tableViewHeight;
@property (nonatomic,strong) NSMutableArray *monthArr;

@end
