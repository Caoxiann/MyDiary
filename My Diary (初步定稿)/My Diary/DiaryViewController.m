//
//  DiaryViewController.m
//  My Diary
//
//  Created by 徐贤达 on 2017/1/15.
//  Copyright © 2017年 徐贤达. All rights reserved.
//

#import "DiaryViewController.h"
#import "NotePage.h"
#import "SqlService.h"

@interface DiaryViewController ()

@end

@implementation DiaryViewController

@synthesize noteListArray;

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        _noteListTableView=[[UITableView alloc]init];
        [_noteListTableView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,deviceHeight*78/100)];
        _noteListTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        //Table背景
        UIImage *backImage=[UIImage imageNamed:@"yourname.jpg"];
        _noteListTableView.layer.contents=(id)backImage.CGImage;
        _noteListTableView.layer.backgroundColor=[UIColor clearColor].CGColor;
        //Table协议
        _noteListTableView.delegate = self;
        _noteListTableView.dataSource = self;
        [_noteListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//初始化TableView
    _size=CGSizeMake(deviceWidth-80,MAXFLOAT);
    [self.view addSubview:_noteListTableView];
    [self updateTheNote];
}

//更新数据
-(void)updateTheNote
{
    NSLog(@"updateTheNote");
    _textArray=nil;
    _textArray=[[NSMutableArray alloc]init];
    noteListArray = [[SqlService sqlInstance] queryDBtable];
    if ([noteListArray count]!=0)
    {
        for (int i=0;i<=[noteListArray count]-1;i++)
        {
            NotePage *page=noteListArray[i];
            NSString *string=page.content;
            [_textArray insertObject:string atIndex:i];
        }
    }
    [_noteListTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [noteListArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_textArray count]!=0)
    {
        NSString * textArray = [_textArray objectAtIndex:indexPath.row];
        CGSize labelSize = {0, 0};
        labelSize = [textArray sizeWithFont:[UIFont systemFontOfSize:15]
                     
                         constrainedToSize:_size
                             lineBreakMode:UILineBreakModeCharacterWrap];
        self.noteListTableView.delegate=self;
        self.noteListTableView.dataSource=self;
        return labelSize.height+120;
    }
    else
    {
        return 50;
    }
}

//自定义cell风格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetifier = @"cell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
    }
    
    NotePage *notePage = noteListArray[[noteListArray count]-indexPath.row-1];
    
//    NSString *colorname =@"0x69D7DD";
//    long colorLong = strtoul([colorname cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
//    int R = (colorLong & 0xFF0000 )>>16;
//    int G = (colorLong & 0x00FF00 )>>8;
//    int B =  colorLong & 0x0000FF;
//    UIColor *themecolor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    
    UIColor *themecolor = [UIColor colorWithRed:107/255.0 green:183/255.0 blue:219/255.0 alpha:1];
    
    NSString * textArray = [_textArray objectAtIndex:indexPath.row];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0]};
    CGSize textSize1 = [textArray boundingRectWithSize:_size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    
    CGSize labelSize = {0, 0};
    labelSize = [textArray sizeWithFont:[UIFont systemFontOfSize:15]
                 
                      constrainedToSize:_size
                          lineBreakMode:UILineBreakModeWordWrap];

    //大的UIView对象
    _cellView=[[UIView alloc]init];
    _cellView.frame=CGRectMake(20, 10, deviceWidth-40,textSize1.height+100);
    _cellView.layer.cornerRadius=10;
    _cellView.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:_cellView];
    
    //中的UIView对象
    _cellTopView=[[UIView alloc]init];
    _cellTopView.frame=CGRectMake(0, 0, deviceWidth-40, 80);
    _cellTopView.backgroundColor=themecolor;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_cellTopView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){10, 10}].CGPath;
    _cellTopView.layer.mask = maskLayer;
    [_cellView addSubview:_cellTopView];

    //显示标题
    _titleLabel=[[UILabel alloc]init];
    _titleLabel.frame=CGRectMake(100, 39,deviceWidth-160, 15);
    _titleLabel.text=notePage.titile;
    _titleLabel.font=[UIFont systemFontOfSize:20];
    _cellTitle=[[NSString alloc]init];
    _titleLabel.numberOfLines=0;
    _titleLabel.tag=indexPath.row;
    _titleLabel.textColor=[UIColor whiteColor];
    [_cellTopView addSubview:_titleLabel];
    
    //显示正文
    _contentLabel=[[UILabel alloc]init];
    _contentLabel.frame=CGRectMake(20, 90, _size.width, labelSize.height);
    _contentLabel.text=notePage.content;
    _contentLabel.numberOfLines=0;
    _contentLabel.lineBreakMode=UILineBreakModeCharacterWrap;
    _contentLabel.font=[UIFont systemFontOfSize:15];
    _contentLabel.textColor=[UIColor blackColor];
    _contentLabel.textAlignment=NSTextAlignmentLeft;
    [_cellView addSubview:_contentLabel];
    
    //设置分割线
    UILabel *cut=[[UILabel alloc]init];
    cut.backgroundColor=[UIColor whiteColor];
    cut.frame=CGRectMake(83,0, 3, 80);
    [_cellTopView addSubview:cut];
    
    //显示小时
    _time=[[NSString alloc]init];
    _time=notePage.time;
    _date=[[_time substringWithRange:NSMakeRange(8, 2)]intValue];
    _hour=[[_time substringWithRange:NSMakeRange(11, 2)]intValue];
    _minute=[[_time substringWithRange:NSMakeRange(14,2)]intValue];
    _year=[[_time substringWithRange:NSMakeRange(0,4)]intValue];
    _month=[[_time substringWithRange:NSMakeRange(5,2)]intValue];
    
    _hourLabel=[[UILabel alloc]init];
    _hourLabel.frame=CGRectMake(100, 13, 200, 10);
    _hourLabel.textAlignment=NSTextAlignmentLeft;
    if(_minute>=0&&_minute<=9)
    {
        _hourLabel.text=[NSString stringWithFormat:@"%0d:0%d",_hour,_minute];
    }
    else
    {
        _hourLabel.text=[NSString stringWithFormat:@"%0d:%d",_hour,_minute];
    }
    _hourLabel.textColor=[UIColor whiteColor];
    _hourLabel.font=[UIFont systemFontOfSize:13];
    [_cellTopView addSubview:_hourLabel];
    
    //显示日期
    _dateLabel=[[UILabel alloc]init];
    _dateLabel.frame=CGRectMake(0,12, 80 , 80);
    _dateLabel.text=[NSString stringWithFormat:@"%d",_date];
    _dateLabel.textAlignment=NSTextAlignmentCenter;
    _dateLabel.font=[UIFont systemFontOfSize:35];
    _dateLabel.textColor=[UIColor whiteColor];
    _dateLabel.backgroundColor=[UIColor clearColor];
    _dateLabel.layer.masksToBounds = YES;
    [_cellTopView addSubview:_dateLabel];
    
    //显示年月
    _yearLabel=[[UILabel alloc]init];
    _yearLabel.frame=CGRectMake(0,-20, 80,80);
    _yearLabel.text=[NSString stringWithFormat:@"%d.%d",_year,_month];
    _yearLabel.textAlignment=NSTextAlignmentCenter;
    _yearLabel.textColor=[UIColor whiteColor];
    _yearLabel.font=[UIFont systemFontOfSize:13];
    [_cellTopView addSubview:_yearLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
