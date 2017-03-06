//
//  VCDiaryWrite.m
//  MyDiary02
//
//  Created by 向尉 on 2017/1/20.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "VCDiaryWrite.h"
#import "TableViewCellDataSource.h"
#import <CoreLocation/CoreLocation.h>

static NSCalendarUnit NSCalendarUnitYMDHM=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute;

@interface VCDiaryWrite ()<CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation VCDiaryWrite

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.textView setFrame:CGRectMake(5, 20, self.view.frame.size.width-10, self.view.frame.size.height-150)];
    [self.textView setDelegate:self];
    [self.view addSubview:self.textView];
    [self.textView becomeFirstResponder];
    [self.textView setFont:[UIFont systemFontOfSize:16]];
    self.textView.layer.borderColor=[[UIColor colorWithRed:105/255.0 green:215/255.0 blue:221/255.0 alpha:1.0] CGColor];
    [self.textView.layer setBorderWidth:1];
    [self.textView.layer setMasksToBounds:YES];
    [self.textView.layer setCornerRadius:10];
    if ([self.textView.text isEqualToString:@"开始记录你的生活吧"])
    {
        [self doWithoutText];
    }
    else
    {
        [self doWithText];
    }
}
//
-(void)viewWillAppear:(BOOL)animated
{
}
//if the textview is "开始记录你的生活吧",new a diary
-(void)doWithoutText
{
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
//if the textView has origin text,do something with the text
-(void)doWithText
{
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(pressBackBtnWithText)];
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
    if ([self.textView.text isEqualToString:@"开始记录你的生活吧"] ||
        [self.textView.text isEqualToString:@""])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSDate *currentTime=[NSDate date];
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components=[calendar components:NSCalendarUnitYMDHM fromDate:currentTime];
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
        TableViewCellDataSource *data=[[TableViewCellDataSource alloc]initWithText:self.textView.text Year:components.year Month:components.month Day:components.day Hour:components.hour Minute:components.minute Place:[userDefault objectForKey:@"location"]];
        [userDefault removeObjectForKey:@"location"];
        [self.delegate addDiary:data];
        //[self.navigationController popViewControllerAnimated:YES];
    }
}
//
-(void)pressBackBtnWithText
{
    if ([self.textView.text isEqualToString:@""])
    {
        [self pressTrashWithText];
        return;
    }
    TableViewCellDataSource *data=[[TableViewCellDataSource alloc]initWithText:self.textView.text Year:self.originData.year Month:self.originData.month Day:self.originData.day Hour:self.originData.hour Minute:self.originData.minute Place:@""];
    [self.delegate changeDiary:data];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pressFinishBtn
{
    [self.textView resignFirstResponder];
}

-(void)pressTrashWithoutText
{
    UIAlertView *deleteAlert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"确定是否删除项目" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [deleteAlert setTag:101];
    [deleteAlert show];
}

-(void)pressTrashWithText
{
    UIAlertView *deleteAlert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"确定是否删除项目" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [deleteAlert setTag:102];
    [deleteAlert show];

}

-(void)pressAdd
{

}

-(void)pressAction
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextView delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(pressFinishBtn)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    if ([self.textView.text isEqualToString:@"开始记录你的生活吧"])
    {
        [self.textView setText:@""];
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
        [self.delegate deleteDiary];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - CLLocation Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [_locationManager stopUpdatingLocation];
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:
     ^(NSArray< CLPlacemark *> * placemarks, NSError * error){
         if (error != nil)
         {
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"网络错误,无法定位" message:@"请再次尝试" preferredStyle:UIAlertControllerStyleAlert];
             [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDestructive handler:
                               ^(UIAlertAction*action){
                                   [self.navigationController popViewControllerAnimated:YES];
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
             [self.navigationController popViewControllerAnimated:YES];
         } else
         {
             //错误
         }
     }];
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
