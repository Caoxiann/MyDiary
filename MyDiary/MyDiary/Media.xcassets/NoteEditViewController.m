//
//  NoteEditViewController.m
//  MyDiary
//
//  Created by tinoryj on 2017/2/8.
//  Copyright © 2017年 tinoryj. All rights reserved.
//

#import "NoteEditViewController.h"

@interface NoteEditViewController () <UITextViewDelegate>

@end

@implementation NoteEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIColor *blueThemeColor = [UIColor colorWithRed:107/255.0 green:183/255.0 blue:219/255.0 alpha:1];
    //UIColor *redThemeColor = [UIColor colorWithRed:246/255.0 green:120/255.0 blue:138/255.0 alpha:1];
    
    UINavigationBar *editNav = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
    [editNav setBarTintColor:blueThemeColor];
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(onclickSave:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onclickDone:)];
    
    self.navigationController.navigationItem.rightBarButtonItem = cancelButton;
    self.navigationController.navigationItem.leftBarButtonItem = saveButton;
    
    //self.navigationItem.title = @"Edit";
    //self.navigationController.title = @"Edit";
    
    [self.view addSubview:editNav];
    
    [self.txtView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onclickDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onclickSave:(id)sender {
    
    NoteBL *bl = [[NoteBL alloc] init];
    Note *note = [[Note alloc] init];
    note.date = [[NSDate alloc] init];
    note.content = self.txtView.text;
    NSMutableArray *reslist = [bl createNote: note];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadViewNotification" object:reslist userInfo:nil];
    [self.txtView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
