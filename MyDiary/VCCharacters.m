//
//  VCCharacters.m
//  MyDiary
//
//  Created by Jimmy Fan on 2017/1/24.
//  Copyright © 2017年 Jimmy Fan. All rights reserved.
//

#import "VCCharacters.h"
#import "VCList.h"
#import "VCCamera.h"

@interface VCCharacters ()

@end

@implementation VCCharacters

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blueColor];
 
    UIImage* _image = [UIImage imageNamed:@"list.png"];
    UIGraphicsBeginImageContext(CGSizeMake(16, 15.5));
    [_image drawInRect:CGRectMake(0, 0, 16, 15.5)];
    UIImage* _newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIBarButtonItem* btn01 = [[UIBarButtonItem alloc] initWithImage:_newImage style:UIBarButtonItemStylePlain target:self action:@selector(pressList)];
    
    _image = [UIImage imageNamed:@"characters.png"];
    UIGraphicsBeginImageContext(CGSizeMake(18, 18));
    [_image drawInRect:CGRectMake(0, 0, 18, 18)];
    _newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIBarButtonItem* btn02 = [[UIBarButtonItem alloc] initWithImage:_newImage style:UIBarButtonItemStylePlain target:self action:@selector(pressCharacters)];
    
    _image = [UIImage imageNamed:@"camera.png"];
    UIGraphicsBeginImageContext(CGSizeMake(20, 16));
    [_image drawInRect:CGRectMake(0, 0, 20, 16)];
    _newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIBarButtonItem* btn03 = [[UIBarButtonItem alloc] initWithImage:_newImage style:UIBarButtonItemStylePlain target:self action:@selector(pressCamera)];
    
    _image = [UIImage imageNamed:@"item.png"];
    UIGraphicsBeginImageContext(CGSizeMake(22, 20));
    [_image drawInRect:CGRectMake(0, 0, 22, 20)];
    _newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIBarButtonItem* btn04 = [[UIBarButtonItem alloc] initWithImage:_newImage style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    UIBarButtonItem* btnF01 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    btnF01.width = 10;
    UIBarButtonItem* btnF02 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    btnF02.width = 120;
    
    NSArray* arrayBtns = [NSArray arrayWithObjects:btn01,btnF01,btn02,btnF01,btn03,btnF02,btn04, nil];
    self.toolbarItems = arrayBtns;

}


- (void)pressList {
    VCList* vcList = [[VCList alloc] init];
    [self.navigationController pushViewController:vcList animated:YES];
}

- (void)pressCharacters {

}

- (void)pressCamera {
    VCCamera* vcCamera = [[VCCamera alloc] init];
    [self.navigationController pushViewController:vcCamera animated:YES];
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
