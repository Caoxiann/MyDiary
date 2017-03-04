//
//  VCProjectWrite.m
//  MyDiary02
//
//  Created by 向尉 on 2017/1/20.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "VCProjectWrite.h"
#import "TableViewCellDataSource.h"
#import <CoreLocation/CoreLocation.h>

static NSCalendarUnit NSCalendarUnitYMDHM=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute;

@interface VCProjectWrite ()<UIAlertViewDelegate,CLLocationManagerDelegate>

@property(nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation VCProjectWrite

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.textView setFrame:CGRectMake(5, 20, self.view.frame.size.width-10, self.view.frame.size.height/2)];
    [self.textView setDelegate:self];
    [self.view addSubview:self.textView];
    //[projWrite.textView becomeFirstResponder];
    [self.textView setFont:[UIFont systemFontOfSize:16]];
    self.textView.layer.borderColor=[[UIColor colorWithRed:105/255.0 green:215/255.0 blue:221/255.0 alpha:1.0] CGColor];
    [self.textView.layer setBorderWidth:1];
    [self.textView.layer setMasksToBounds:YES];
    [self.textView.layer setCornerRadius:10];
    self.timePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(5, 40+self.view.frame.size.height/2, self.view.frame.size.width-10, self.view.frame.size.height/2-200)];
    [self.view addSubview:self.timePicker];
    UILabel *tipLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 10+self.view.frame.size.height/2, 80, 40)];
    //[tipLab setFont:[UIFont systemFontOfSize:15]];
    [tipLab setText:@"执行时间"];
    [self.view addSubview:tipLab];
    if ([self.textView.text isEqualToString:@"写下你的计划吧"])
    {
        [self doWithoutText];
    }
    else
    {
        [self doWithText];
    }
}
//
-(void)viewDidAppear:(BOOL)animated
{
}
//
-(void)doWithoutText
{
    [self setTitle:@" 新建项目"];
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(pressBackBtnWithoutText)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    //set toolBarItems
    UIBarButtonItem *trashBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(pressTrashWithoutText)];
    UIBarButtonItem *centreBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *addBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pressAdd)];
    UIBarButtonItem *itemActionBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pressAction)];
    NSArray *toolBarItems=[NSArray arrayWithObjects:trashBtn, centreBtn, addBtn, centreBtn, itemActionBtn,nil];
    [self setToolbarItems:toolBarItems];
}
//
-(void)doWithText
{
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(pressBackBtnWithText)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    //set toolBarItems
    UIBarButtonItem *trashBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(pressTrashWithText)];
    UIBarButtonItem *centreBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *addBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pressAdd)];
    UIBarButtonItem *itemActionBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pressAction)];
    NSArray *toolBarItems=[NSArray arrayWithObjects:trashBtn, centreBtn, addBtn, centreBtn, itemActionBtn,nil];
    [self setToolbarItems:toolBarItems];
}
//
-(void)pressBackBtnWithoutText
{
    if ([self.textView.text isEqualToString:@""] || [self.textView.text isEqualToString:@"写下你的计划吧"])
    {
        return;
    }
    else
    {
        if (_locationManager == nil)
        {
            _locationManager = [[CLLocationManager alloc] init];
            // 设置定位精度
            [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
            _locationManager.delegate = self;
            
            if([CLLocationManager locationServicesEnabled])
            {
                // 开始时时定位
                [self.locationManager startUpdatingLocation];
                
            }
        }
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components=[calendar components:NSCalendarUnitYMDHM fromDate:self.timePicker.date];
        NSString *str=[userDefault objectForKey:@"location"];
        if (str==nil)
        {
            str=@"";
        }
        TableViewCellDataSource *data=[[TableViewCellDataSource alloc]initWithText:self.textView.text Year:components.year Month:components.month Day:components.day Hour:components.hour Minute:components.minute Place:str];
        [userDefault removeObjectForKey:@"location"];
        NSLog(@"%@",self.timePicker.date);
        [self.delegate addProject:data];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//
-(void)pressBackBtnWithText
{
    if ([self.textView.text isEqualToString:@""])
    {
        [self pressTrashWithText];
    }
    else
    {
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components=[calendar components:NSCalendarUnitYMDHM fromDate:self.timePicker.date];
        TableViewCellDataSource *data=[[TableViewCellDataSource alloc]initWithText:self.textView.text Year:components.year Month:components.month Day:components.day Hour:components.hour Minute:components.minute Place:@""];
        [self.delegate changeProject:data];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}
//
-(void)pressFinishBtn
{
    [self.textView resignFirstResponder];
}
//
-(void)pressTrashWithoutText
{
    UIAlertView *deleteAlert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"确定是否删除项目" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [deleteAlert setTag:101];
    [deleteAlert show];
}
//
-(void)pressTrashWithText
{
    UIAlertView *deleteAlert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"确定是否删除项目" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [deleteAlert setTag:102];
    [deleteAlert show];
}
//
-(void)pressAdd
{

}
//
-(void)pressAction
{

}

#pragma mark - UITextView delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(pressFinishBtn)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    if ([textView.text isEqualToString:@"写下你的计划吧"])
    {
        [textView setText:@""];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.navigationItem setRightBarButtonItem:nil];
}
#pragma  mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==101 && buttonIndex==1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(alertView.tag==102 && buttonIndex==1)
    {
        [self.delegate deleteProject];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - CLLocation Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [_locationManager stopUpdatingLocation];
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:
     ^(NSArray< CLPlacemark *> * placemarks, NSError * error)
    {
         if (error != nil)
         {
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"网络错误,无法定位" message:@"请再次尝试" preferredStyle:UIAlertControllerStyleAlert];
             [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDestructive handler:
                               ^(UIAlertAction*action){
                                   //
                               }]];
             [self presentViewController:alert animated:YES completion:nil];
         }
         
         if (placemarks.count > 0)
         {
             CLPlacemark *pm = placemarks[0];
             NSString *locationStr=[[NSString alloc]init];
             if(pm.country!=nil)
             {
                 locationStr=[[NSString alloc]initWithString:[NSString stringWithFormat:@" %@",pm.country]];
                 if(pm.administrativeArea!=nil)
                 {
                     locationStr=[locationStr stringByAppendingString:[NSString stringWithFormat:@" %@",pm.administrativeArea]];
                     if(pm.locality!=nil)
                     {
                         locationStr=[locationStr stringByAppendingString:[NSString stringWithFormat:@" %@",pm.locality]];
                     }
                 }
             }
             NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
             [userDefault setObject:locationStr forKey:@"location"];
             NSLog(@"locationStr:%@",locationStr);
             
         }
         else
         {
             //错误
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
