//
//  ViewController.m
//  MyDiary
//
//  Created by Wujianyun on 16/01/2017.
//  Copyright © 2017 yaoyaoi. All rights reserved.
//

#import "ViewController.h"
#import "ElementPage.h"

@interface ViewController ()<ElementPageDelegate,ElementPageDelegateInCVC,DiaryPageDelegate>
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

-(void)addChildViewControllers {
    ElementViewController* elementVC=[[ElementViewController alloc]init];
    elementVC.delegate=self;
    CalendarViewController* calenderVC=[[CalendarViewController alloc]init];
    calenderVC.delegate=self;
    DiaryViewController* diaryVC=[[DiaryViewController alloc]init];
    diaryVC.delegate=self;
    CGFloat height=self.view.bounds.size.height-_topView.frame.size.height-_buttonView.frame.size.height+2;
    [elementVC setTableViewHeight:height];
    [calenderVC setViewHeight:height];
    [diaryVC setTableViewHeight:height];
    [elementVC.view setFrame:CGRectMake(0,_topView.frame.size.height+1, self.view.bounds.size.width, self.view.bounds.size.height-_topView.frame.size.height-_buttonView.frame.size.height+1)];
    [calenderVC.view setFrame:CGRectMake(0,_topView.frame.size.height+1, self.view.bounds.size.width, self.view.bounds.size.height-_topView.frame.size.height-_buttonView.frame.size.height+1)];
    [diaryVC.view setFrame:CGRectMake(0,_topView.frame.size.height+1, self.view.bounds.size.width, self.view.bounds.size.height-_topView.frame.size.height-_buttonView.frame.size.height+1)];
     //NSLog(@"%f",height);
    [self addChildViewController:elementVC];
    [self addChildViewController:calenderVC];
    [self addChildViewController:diaryVC];
    _childControllersArray=[[NSMutableArray alloc]initWithObjects:elementVC,calenderVC,diaryVC, nil];
    _currentVC=elementVC;
    _currentPage=0;
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
    CATransition* amin=[CATransition animation];
    [amin setDuration:1];
    [amin setType:@"cube"];
    [amin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [amin setSubtype:kCATransitionFromRight];
    [self.navigationController.view.layer addAnimation:amin forKey:nil];
    if(_currentPage==2){
        Diary * diary=[[Diary alloc]init];
        DiaryPage *diaryPage=[[DiaryPage alloc]init];
        [diaryPage setDiary:diary];
        diaryPage.isNew=YES;
        [self.navigationController pushViewController:diaryPage animated:amin];
       
    }else {
        Element *element=[[Element alloc]init];
        ElementPage * elementPage=[[ElementPage alloc]init];
        [elementPage setElement:element];
        elementPage.isNew=YES;
        [self.navigationController pushViewController:elementPage animated:amin];
    }
        

}

- (IBAction)photoButton:(UIButton *)sender {
}
#pragma mark - ElementPageDelegate
-(void)turnToElementPage:(Element *)element {
    CATransition* amin=[CATransition animation];
    [amin setDuration:1];
    [amin setType:@"cube"];
    [amin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [amin setSubtype:kCATransitionFromRight];
    [self.navigationController.view.layer addAnimation:amin forKey:nil];
    ElementPage *elementPage=[[ElementPage alloc]init];
    [elementPage setIsNew:NO];
    [elementPage setElement:element];
    [self.navigationController pushViewController:elementPage animated:amin];
}
#pragma mark - DiaryPageDelegate
-(void)turnToDiaryPage:(Diary *)diary {
    CATransition* amin=[CATransition animation];
    [amin setDuration:1];
    [amin setType:@"cube"];
    [amin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [amin setSubtype:kCATransitionFromRight];
    [self.navigationController.view.layer addAnimation:amin forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
    DiaryPage *diaryPage=[[DiaryPage alloc]init];
    [diaryPage setIsNew:NO];
    [diaryPage setDiary:diary];
    [self.navigationController pushViewController:diaryPage animated:amin];
}
@end


