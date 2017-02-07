//
//  ViewController.h
//  MyDiary02
//
//  Created by 向尉 on 2017/1/20.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

/* a view displayed in the centre of navigationBar*/
@property(nonatomic)UIView *centreView;


/* a segmentedControl in centreView*/
@property(nonatomic,retain)UISegmentedControl *seg;


/* a lable in centreView 
 under the segmentedControl
 */
@property(nonatomic,retain)UILabel *labView;


/* the first button in toolBar*/
@property(nonatomic,retain)UIBarButtonItem *toolBtn01;


/* the second button in toolBar*/
@property(nonatomic,retain)UIBarButtonItem *toolBtn02;


/* the third button in toolBar*/
@property(nonatomic,retain)UIBarButtonItem *toolBtn03;


/* the fourth button in toolBar*/
@property(nonatomic,retain)UIBarButtonItem *toolBtn04;


/* the fifth button in toolBar*/
@property(nonatomic,retain)UIBarButtonItem *toolBtn05;


/* a fixed button between*/
@property(nonatomic,retain)UIBarButtonItem *fixedBtn01;


/* a fixed button in the centre of toolBar*/
@property(nonatomic,retain)UIBarButtonItem *fixedBtn02;

@end
