//
//  ViewController.m
//  MyDiary
//
//  Created by Wujianyun on 16/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "ViewController.h"
#pragma mark - UIColorCategory
@interface UIColor (UIColor)
+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha;
@end
@implementation UIColor (UIColor)
+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((hexValue >> 16) & 0x000000FF)/255.0f
                           green:((hexValue >> 8) & 0x000000FF)/255.0f
                            blue:((hexValue) & 0x000000FF)/255.0
                           alpha:alpha];
}
@end

@interface ViewController ()
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewControllers];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addChildViewControllers{
    ElementViewController* elementVC=[[ElementViewController alloc]init];
    CalenderViewController* calenderVC=[[CalenderViewController alloc]initWithBackgroundColor:[UIColor colorWithHexValue:0XFF788B alpha:1]];
    DiaryViewController* diaryVC=[[DiaryViewController alloc]initWithBackgroundColor:[UIColor colorWithHexValue:0X69D7DD alpha:1]];
    [elementVC.view setFrame:CGRectMake(0, 110, 375, 510)];
    [calenderVC.view setFrame:CGRectMake(0, 110, 375, 510)];
    [diaryVC.view setFrame:CGRectMake(0, 110, 375, 510)];
    [self addChildViewController:elementVC];
    [self addChildViewController:calenderVC];
    [self addChildViewController:diaryVC];
    _childControllersArray=[[NSMutableArray alloc]initWithObjects:elementVC,calenderVC,diaryVC, nil];
    _currentVC=elementVC;
    [self.view addSubview:elementVC.view];
}

#pragma mark - segment
- (IBAction)segment:(UISegmentedControl *)sender {
    //pageSwitch
    if(_currentPage==sender.selectedSegmentIndex){
        return ;
    }
    switch (sender.selectedSegmentIndex) {
        case 0:
            _topLabel.text=@"ELEMENTS";
            break;
        case 1:
            _topLabel.text=@"CALENDAR";
            break;
        case 2:
            _topLabel.text=@"DIARY";
            break;
        default:
            NSLog(@"segment error");
            break;
    }
    _currentPage=sender.selectedSegmentIndex;
    [self replaceController:_currentVC newController:_childControllersArray[_currentPage]];
}
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    
    //[self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            
            [newController didMoveToParentViewController:self];
            //[oldController willMoveToParentViewController:nil];
            //[oldController removeFromParentViewController];
            _currentVC = newController;
            
        }else{
            
            self.currentVC = oldController;
            
        }
    }];
}
                                                                       
#pragma mark - Buttons
- (IBAction)setButton:(UIButton *)sender {
}

- (IBAction)addButton:(UIButton *)sender {
}

- (IBAction)photoButton:(UIButton *)sender {
}

@end

