//
//  PDTSimpleCalendarViewController.m
//  PDTSimpleCalendar
//
//  Created by Jerome Miglino on 10/7/13.
//  Copyright (c) 2013 Producteev. All rights reserved.
//

#import "PDTSimpleCalendarViewController.h"

#import "PDTSimpleCalendarViewFlowLayout.h"
#import "PDTSimpleCalendarViewCell.h"
#import "PDTSimpleCalendarViewHeader.h"
#import "TableViewCellForProject.h"
#import "TableViewCellDataSource.h"
#import "VCDiary.h"
#import "FMDatabase.h"


const CGFloat PDTSimpleCalendarOverlaySize = 14.0f;

static NSString *const PDTSimpleCalendarViewCellIdentifier = @"com.producteev.collection.cell.identifier";
static NSString *const PDTSimpleCalendarViewHeaderIdentifier = @"com.producteev.collection.header.identifier";
static const NSCalendarUnit kCalendarUnitYMD = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;

@interface PDTSimpleCalendarViewController () <PDTSimpleCalendarViewCellDelegate>

@property (nonatomic, strong) UILabel *overlayView;
@property (nonatomic, strong) NSDateFormatter *headerDateFormatter; //Will be used to format date in header view and on scroll.

@property (nonatomic, strong) PDTSimpleCalendarViewWeekdayHeader *weekdayHeader;

// First and last date of the months based on the public properties first & lastDate
@property (nonatomic) NSDate *firstDateMonth;
@property (nonatomic) NSDate *lastDateMonth;

//Number of days per week
@property (nonatomic, assign) NSUInteger daysPerWeek;

@end


@implementation PDTSimpleCalendarViewController

//Explicitly @synthesize the var (it will create the iVar for us automatically as we redefine both getter and setter)
@synthesize firstDate = _firstDate;
@synthesize lastDate = _lastDate;
@synthesize calendar = _calendar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //Force the creation of the view with the pre-defined Flow Layout.
    //Still possible to define a custom Flow Layout, if needed by using initWithCollectionViewLayout:
    self = [super initWithCollectionViewLayout:[[PDTSimpleCalendarViewFlowLayout alloc] init]];
    if (self) {
        // Custom initialization
        [self simpleCalendarCommonInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    //Force the creation of the view with the pre-defined Flow Layout.
    //Still possible to define a custom Flow Layout, if needed by using initWithCollectionViewLayout:
    self = [super initWithCollectionViewLayout:[[PDTSimpleCalendarViewFlowLayout alloc] init]];
    if (self) {
        // Custom initialization
        [self simpleCalendarCommonInit];
    }
    
    return self;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self simpleCalendarCommonInit];
    }

    return self;
}

- (void)simpleCalendarCommonInit
{
    self.overlayView = [[UILabel alloc] init];
    self.backgroundColor = [UIColor whiteColor];
    self.overlayTextColor = [UIColor blackColor];
    self.daysPerWeek = 7;
    self.weekdayHeaderEnabled = NO;
    self.weekdayTextType = PDTSimpleCalendarViewWeekdayTextTypeShort;
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.selectedDate) {
        [self.collectionViewLayout invalidateLayout];
    }
}

#pragma mark - Accessors

- (NSDateFormatter *)headerDateFormatter;
{
    if (!_headerDateFormatter) {
        _headerDateFormatter = [[NSDateFormatter alloc] init];
        _headerDateFormatter.calendar = self.calendar;
        _headerDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy LLLL" options:0 locale:self.calendar.locale];
    }
    return _headerDateFormatter;
}

- (NSCalendar *)calendar
{
    if (!_calendar) {
        [self setCalendar:[NSCalendar currentCalendar]];
    }
    return _calendar;
}

-(void)setCalendar:(NSCalendar*)calendar
{
    _calendar = calendar;
    self.headerDateFormatter.calendar = calendar;
    self.daysPerWeek = [_calendar maximumRangeOfUnit:NSCalendarUnitWeekday].length;
}

- (NSDate *)firstDate
{
    if (!_firstDate) {
        NSDateComponents *components = [self.calendar components:kCalendarUnitYMD
                                                        fromDate:[NSDate date]];
        components.day = 1;
        _firstDate = [self.calendar dateFromComponents:components];
    }

    return _firstDate;
}

- (void)setFirstDate:(NSDate *)firstDate
{
    _firstDate = [self clampDate:firstDate toComponents:kCalendarUnitYMD];
}

- (NSDate *)firstDateMonth
{
    if (_firstDateMonth) { return _firstDateMonth; }

    NSDateComponents *components = [self.calendar components:kCalendarUnitYMD
                                                    fromDate:self.firstDate];
    components.day = 1;

    _firstDateMonth = [self.calendar dateFromComponents:components];

    return _firstDateMonth;
}

- (NSDate *)lastDate
{
    if (!_lastDate) {
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        offsetComponents.year = 1;
        offsetComponents.day = -1;
        [self setLastDate:[self.calendar dateByAddingComponents:offsetComponents toDate:self.firstDateMonth options:0]];
    }

    return _lastDate;
}

- (void)setLastDate:(NSDate *)lastDate
{
    _lastDate = [self clampDate:lastDate toComponents:kCalendarUnitYMD];
}

- (NSDate *)lastDateMonth
{
    if (_lastDateMonth) { return _lastDateMonth; }

    NSDateComponents *components = [self.calendar components:kCalendarUnitYMD
                                                    fromDate:self.lastDate];
    components.month++;
    components.day = 0;

    _lastDateMonth = [self.calendar dateFromComponents:components];

    return _lastDateMonth;
}

- (void)setSelectedDate:(NSDate *)newSelectedDate
{
    //if newSelectedDate is nil, unselect the current selected cell
    if (!newSelectedDate) {
        [[self cellForItemAtDate:_selectedDate] setSelected:NO];
        _selectedDate = newSelectedDate;

        return;
    }

    //Test if selectedDate between first & last date
    NSDate *startOfDay = [self clampDate:newSelectedDate toComponents:kCalendarUnitYMD];
    if (([startOfDay compare:self.firstDateMonth] == NSOrderedAscending) || ([startOfDay compare:self.lastDateMonth] == NSOrderedDescending)) {
        //the newSelectedDate is not between first & last date of the calendar, do nothing.
        return;
    }


    [[self cellForItemAtDate:_selectedDate] setSelected:NO];
    [[self cellForItemAtDate:startOfDay] setSelected:YES];

    _selectedDate = startOfDay;

    NSIndexPath *indexPath = [self indexPathForCellAtDate:_selectedDate];
    [self.collectionView reloadItemsAtIndexPaths:@[ indexPath ]];

    //Notify the delegate
    if ([self.delegate respondsToSelector:@selector(simpleCalendarViewController:didSelectDate:)]) {
        [self.delegate simpleCalendarViewController:self didSelectDate:self.selectedDate];
    }
}

#pragma mark - Scroll to a specific date

- (void)scrollToSelectedDate:(BOOL)animated
{
    if (_selectedDate) {
        [self scrollToDate:_selectedDate animated:animated];
    }
}

- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated
{
    @try {
        NSIndexPath *selectedDateIndexPath = [self indexPathForCellAtDate:date];

        if (![[self.collectionView indexPathsForVisibleItems] containsObject:selectedDateIndexPath]) {
            //First, tried to use [self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:selectedDateIndexPath]; but it causes the header to be redraw multiple times (X each time you use scrollToDate:)
            //TODO: Investigate & eventually file a radar.

            NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:selectedDateIndexPath.section];
            UICollectionViewLayoutAttributes *sectionLayoutAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:sectionIndexPath];
            CGPoint origin = sectionLayoutAttributes.frame.origin;
            origin.x = 0;
            origin.y -= (PDTSimpleCalendarFlowLayoutHeaderHeight + PDTSimpleCalendarFlowLayoutInsetTop + self.collectionView.contentInset.top);
            [self.collectionView setContentOffset:origin animated:animated];
        }
    }
    @catch (NSException *exception) {
        //Exception occured (it should not according to the documentation, but in reality...) let's scroll to the IndexPath then
        NSInteger section = [self sectionForDate:date];
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        [self.collectionView scrollToItemAtIndexPath:sectionIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:animated];
    }
}

- (void)setOverlayTextColor:(UIColor *)overlayTextColor
{
    _overlayTextColor = overlayTextColor;
    if (self.overlayView) {
        [self.overlayView setTextColor:self.overlayTextColor];
    }
}

#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //set background image.
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    [imgView setImage:[UIImage imageNamed:@"cloud.jpg"]];
    [self.view addSubview:imgView];
    //Configure the Collection View
    [self.collectionView registerClass:[PDTSimpleCalendarViewCell class] forCellWithReuseIdentifier:PDTSimpleCalendarViewCellIdentifier];
    [self.collectionView registerClass:[PDTSimpleCalendarViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PDTSimpleCalendarViewHeaderIdentifier];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setBackgroundColor:self.backgroundColor];
    [self.collectionView setFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height/2)];
    [self.view addSubview:self.collectionView];

    //Configure the Overlay View
    [self.overlayView setBackgroundColor:[self.backgroundColor colorWithAlphaComponent:0.90]];
    [self.overlayView setFont:[UIFont boldSystemFontOfSize:PDTSimpleCalendarOverlaySize]];
    [self.overlayView setTextColor:self.overlayTextColor];
    //[self.overlayView setAlpha:0.0];
    [self.overlayView setTextAlignment:NSTextAlignmentCenter];
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    NSArray *sortedIndexPaths = [indexPaths sortedArrayUsingSelector:@selector(compare:)];
    NSIndexPath *firstIndexPath = [sortedIndexPaths firstObject];
    self.overlayView.text = [self.headerDateFormatter stringFromDate:[self firstOfMonthForSection:firstIndexPath.section]];
    [self.view addSubview:self.overlayView];
    [self.overlayView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Configure the Weekday Header
    self.weekdayHeader = [[PDTSimpleCalendarViewWeekdayHeader alloc] initWithCalendar:self.calendar weekdayTextType:self.weekdayTextType];
    
    [self.view addSubview:self.weekdayHeader];
    [self.weekdayHeader setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSInteger weekdayHeaderHeight = self.weekdayHeaderEnabled ? PDTSimpleCalendarWeekdayHeaderHeight : 0;

    NSDictionary *viewsDictionary = @{@"overlayView": self.overlayView, @"weekdayHeader": self.weekdayHeader};
    NSDictionary *metricsDictionary = @{@"overlayViewHeight": @(PDTSimpleCalendarFlowLayoutHeaderHeight), @"weekdayHeaderHeight": @(weekdayHeaderHeight)};

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[overlayView]|" options:NSLayoutFormatAlignAllTop metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[weekdayHeader]|" options:NSLayoutFormatAlignAllTop metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[weekdayHeader(weekdayHeaderHeight)][overlayView(overlayViewHeight)]" options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(weekdayHeaderHeight, 0, 0, 0)];
    //
    self.projects=[[NSMutableArray alloc]init];
    [self loadProjects];
    //set navigationBar
    UIColor *designedColor=[UIColor colorWithRed:105/255.0 green:215/255.0 blue:221/255.0 alpha:1.0];
    UIView *view=[[UIView alloc]initWithFrame:self.navigationController.navigationBar.frame];
    [self.navigationItem setTitleView:view];
    self.seg=[[UISegmentedControl alloc]initWithFrame:CGRectMake(40, 1, view.frame.size.width-80, 20)];
    [self.seg insertSegmentWithTitle:@"项目" atIndex:0 animated:NO];
    [self.seg insertSegmentWithTitle:@"日历" atIndex:1 animated:NO];
    [self.seg insertSegmentWithTitle:@"日记" atIndex:2 animated:NO];
    [self.seg setSelectedSegmentIndex:1];
    [self.seg addTarget:self action:@selector(chooseSeg:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:self.seg];
    self.labView=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width/2-60, 20, 120, 30)];
    [self.labView setText:@"CALENDAR"];
    [self.labView setTextColor:designedColor];
    [self.labView setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:self.labView];
    
    
    //set toolBarItems
    [self.navigationController.toolbar setBarTintColor:designedColor];
    [self.navigationController.toolbar setTintColor:[UIColor whiteColor]];
    
    //set firstToolBarItem
    UIButton *btnInToolBtn01=[UIButton buttonWithType:UIButtonTypeSystem];
    [btnInToolBtn01 setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    [btnInToolBtn01 setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateHighlighted];
    [btnInToolBtn01 setFrame:CGRectMake(0, 0, 18, 18)];
    self.toolBtn01=[[UIBarButtonItem alloc]initWithCustomView:btnInToolBtn01];
    
    //set secondToolBarItem
    //self.toolBtn02=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(pressToolBtn02)];
    UIButton *btnInToolBtn02=[UIButton buttonWithType:UIButtonTypeSystem];
    [btnInToolBtn02 setImage:[UIImage imageNamed:@"characters@2x.png"] forState:UIControlStateNormal];
    //[btnInToolBtn01 setImage:[UIImage imageNamed:@"character@2x.png"] forState:UIControlStateHighlighted];
    [btnInToolBtn02 setFrame:CGRectMake(0, 0, 22, 22)];
    [btnInToolBtn02 addTarget:self action:@selector(pressToolBtn02) forControlEvents:UIControlEventTouchUpInside];
    self.toolBtn02=[[UIBarButtonItem alloc]initWithCustomView:btnInToolBtn02];
    
    //set thirdToolBarItem
    UIButton *btnInToolBtn03=[UIButton buttonWithType:UIButtonTypeSystem];
    [btnInToolBtn03 setImage:[UIImage imageNamed:@"camera@2x.png"] forState:UIControlStateNormal];
    [btnInToolBtn03 setImage:[UIImage imageNamed:@"camera@2x.png"] forState:UIControlStateHighlighted];
    [btnInToolBtn03 setFrame:CGRectMake(0, 0, 25, 20)];
    self.toolBtn03=[[UIBarButtonItem alloc]initWithCustomView:btnInToolBtn03];
    
    //set fixedToolBarItem between toolBarItems
    self.fixedBtn01=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [self.fixedBtn01 setWidth:20];
    
    //set fixedToolBarItem in the centre
    self.fixedBtn02=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [self.fixedBtn02 setWidth:self.view.frame.size.width-235];
    
    //set fourthToolBarItem
    UIButton *btnInToolBtn04=[UIButton buttonWithType:UIButtonTypeSystem];
    [btnInToolBtn04 setImage:[UIImage imageNamed:@"item.png"] forState:UIControlStateNormal];
    [btnInToolBtn04 setImage:[UIImage imageNamed:@"item.png"] forState:UIControlStateHighlighted];
    [btnInToolBtn04 setFrame:CGRectMake(0, 0, 20, 20)];
    self.toolBtn04=[[UIBarButtonItem alloc]initWithCustomView:btnInToolBtn04];
    
    //set fifthToolBarItem
    NSString *str=[NSString stringWithFormat:@"%ld项目",self.projects.count];
    UILabel *labInToolBtn05=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    [labInToolBtn05 setText:str];
    [labInToolBtn05 setTextColor:[UIColor whiteColor]];
    self.toolBtn05=[[UIBarButtonItem alloc]initWithCustomView:labInToolBtn05];
    
    //add toolBarItems
    NSArray *toolBtns=[NSArray arrayWithObjects:_toolBtn01, _fixedBtn01,_toolBtn02, _fixedBtn01, _toolBtn03, _fixedBtn02, _toolBtn04, _toolBtn05, nil];
    [self setToolbarItems:toolBtns];
    //set tableView
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(30, self.collectionView.frame.origin.y+self.collectionView.frame.size.height-20, self.view.frame.size.width-60, self.view.frame.size.height-self.collectionView.frame.origin.y-self.collectionView.frame.size.height-75) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCellForProject" bundle:nil] forCellReuseIdentifier:@"CellForProject"];
}
//
-(void)pressToolBtn02
{
}
//
-(void)chooseSeg:(UISegmentedControl *) segmentedControl
{
    if (self.seg.selectedSegmentIndex ==0)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else if (self.seg.selectedSegmentIndex ==2)
    {
        NSArray *viewControllers=[self.navigationController viewControllers];
        if ([[viewControllers objectAtIndex:viewControllers.count-2] isKindOfClass:[VCDiary class]])
        {
            [self.navigationController popViewControllerAnimated:NO];
        }
        else
        {
            VCDiary *diary=[[VCDiary alloc]init];
            [self.navigationController pushViewController:diary animated:NO];
            [self.seg setSelectedSegmentIndex:1];
        }
    }
}
//
-(NSString *)switchWeekdays:(NSInteger) weekday
{
    switch (weekday) {
        case 1:
            return @"星期一";
            break;
        case 2:
            return @"星期二";
            break;
        case 3:
            return @"星期三";
            break;
        case 4:
            return @"星期四";
            break;
        case 5:
            return @"星期五";
            break;
        case 6:
            return @"星期六";
            break;
        case 7:
            return @"星期日";
            break;
        default:
            break;
    }
    return @"";
}
//
-(void)loadProjects
{
    NSString *dataBasePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/MyDiary02"];
    self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
    if (self.dataBase != nil)
    {
        [self.dataBase open];
        NSDate *currentTime=[NSDate date];
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components=[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentTime];
        NSString *tableName=[NSString stringWithFormat:@"projectsInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
        NSString *strCreateTable=[NSString stringWithFormat:@"create table if not exists %@(year integer,month integer,day integer,hour integer,minute integer,project varchar(500),place varchar(50),weekday integer);",tableName];
        BOOL isExecuted=[self.dataBase executeUpdate:strCreateTable];
        if (isExecuted)
        {
            NSLog(@"Excuted");
            NSString *strQuery=[NSString stringWithFormat:@"select * from %@;",tableName];
            FMResultSet *resultForProjects=[self.dataBase executeQuery:strQuery];
            while ([resultForProjects next])
            {
                TableViewCellDataSource *data=[[TableViewCellDataSource alloc]initWithText:[resultForProjects stringForColumn:@"project"] Year:[resultForProjects intForColumn:@"year"] Month:[resultForProjects intForColumn:@"month"] Day:[resultForProjects intForColumn:@"day"] Hour:[resultForProjects intForColumn:@"hour"] Minute:[resultForProjects intForColumn:@"minute"] Place:[resultForProjects stringForColumn:@"place"] Weekday:[resultForProjects intForColumn:@"weekday"]];
                [self.projects addObject:data];
            }
            [self.dataBase close];
        }
    }
    else
    {
        NSLog(@"database falied");
    }
}
//
#pragma mark-tableview data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.projects.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellForProject *cell=[tableView dequeueReusableCellWithIdentifier:@"CellForProject"];
    if (cell==nil)
    {
        cell=[[NSBundle mainBundle]loadNibNamed:@"TableViewCellForProject" owner:nil options:nil].firstObject;
    }
    NSDate *currentTime=[NSDate date];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components=[calendar components:NSCalendarUnitDay fromDate:currentTime];
    cell.labDate.text=[NSString stringWithFormat:@"%ld",[components day]];
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:cell.labDate.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer =[[CAShapeLayer alloc]init];
    maskLayer.frame=cell.labDate.bounds;
    maskLayer.path=maskPath.CGPath;
    cell.labDate.layer.mask=maskLayer;
    TableViewCellDataSource *data=[self.projects objectAtIndex:indexPath.row+indexPath.section];
    [cell.labContent setText:data.text];
    cell.hour=data.hour;
    cell.minute=data.minute;
    cell.labTime.text=[NSString stringWithFormat:@"%ld年%ld月%ld日 %02ld:%02ld执行",data.year,data.month,data.day,data.hour,data.minute];
    [cell.labPlace setText:data.place];
    cell.labWeekday.text=[self switchWeekdays:data.weekday];
    [cell.layer setMasksToBounds:YES];
    [cell.layer setCornerRadius:10];
    return cell;
}
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
}
//
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"     ";
}
//
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dataBasePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/MyDiary02"];
    self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
    if (self.dataBase != nil)
    {
        [self.dataBase open];
        TableViewCellDataSource *data=[self.projects objectAtIndex:indexPath.row+indexPath.section];
        NSDate *currentTime=[NSDate date];
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components=[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentTime];
        NSString *tableName=[NSString stringWithFormat:@"projectsInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
        NSString *strDelete=[NSString stringWithFormat:@"delete from %@ where project='%@' and Year= %ld and month=%ld and day=%ld and hour=%ld and minute=%ld and place='%@';",tableName,data.text,data.year,data.month,data.day,data.hour,data.minute,data.place];
        BOOL isDelete=[self.dataBase executeUpdate:strDelete];
        NSLog(@"%d",isDelete);
        [self.dataBase close];
    }
    
    [self.projects removeObjectAtIndex:indexPath.row+indexPath.section];
    [self.tableView reloadData];
    UILabel *label=[self.toolBtn05 customView];
    label.text=[NSString stringWithFormat:@"%ld日记",self.projects.count];
}
//
#pragma mark - Rotation Handling

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView.collectionViewLayout invalidateLayout];
}


#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //Each Section is a Month
    return [self.calendar components:NSCalendarUnitMonth fromDate:self.firstDateMonth toDate:self.lastDateMonth options:0].month + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDate *firstOfMonth = [self firstOfMonthForSection:section];
    NSCalendarUnit weekCalendarUnit = [self weekCalendarUnitDependingOniOSVersion];
    NSRange rangeOfWeeks = [self.calendar rangeOfUnit:weekCalendarUnit inUnit:NSCalendarUnitMonth forDate:firstOfMonth];

    //We need the number of calendar weeks for the full months (it will maybe include previous month and next months cells)
    return (rangeOfWeeks.length * self.daysPerWeek);
}
/**
 * https://github.com/jivesoftware/PDTSimpleCalendar/issues/69
 * On iOS7, using NSCalendarUnitWeekOfMonth (or WeekOfYear) in rangeOfUnit:inUnit is returning NSNotFound, NSNotFound
 * Fun stuff, definition of NSNotFound is enum {NSNotFound = NSIntegerMax};
 * So on iOS7, we're trying to allocate NSIntegerMax * 7 cells per Section
 *
 * //TODO: Remove when removing iOS7 Support
 *
 *  @return the proper NSCalendarUnit to use in rangeOfUnit:inUnit
 */
- (NSCalendarUnit)weekCalendarUnitDependingOniOSVersion {
    //isDateInToday is a new (awesome) method available on iOS8 only.
    if ([self.calendar respondsToSelector:@selector(isDateInToday:)]) {
        return NSCalendarUnitWeekOfMonth;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return NSWeekCalendarUnit;
#pragma clang diagnostic pop
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PDTSimpleCalendarViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:PDTSimpleCalendarViewCellIdentifier
                                                                                     forIndexPath:indexPath];

    cell.delegate = self;
    
    NSDate *firstOfMonth = [self firstOfMonthForSection:indexPath.section];
    NSDate *cellDate = [self dateForCellAtIndexPath:indexPath];

    NSDateComponents *cellDateComponents = [self.calendar components:kCalendarUnitYMD fromDate:cellDate];
    NSDateComponents *firstOfMonthsComponents = [self.calendar components:kCalendarUnitYMD fromDate:firstOfMonth];

    BOOL isToday = NO;
    BOOL isSelected = NO;
    BOOL isCustomDate = NO;

    if (cellDateComponents.month == firstOfMonthsComponents.month) {
        isSelected = ([self isSelectedDate:cellDate] && (indexPath.section == [self sectionForDate:cellDate]));
        isToday = [self isTodayDate:cellDate];
        [cell setDate:cellDate calendar:self.calendar];

        //Ask the delegate if this date should have specific colors.
        if ([self.delegate respondsToSelector:@selector(simpleCalendarViewController:shouldUseCustomColorsForDate:)]) {
            isCustomDate = [self.delegate simpleCalendarViewController:self shouldUseCustomColorsForDate:cellDate];
        }


    } else {
        [cell setDate:nil calendar:nil];
    }

    if (isToday) {
        [cell setIsToday:isToday];
    }

    if (isSelected) {
        [cell setSelected:isSelected];
    }

    //If the current Date is not enabled, or if the delegate explicitely specify custom colors
    if (![self isEnabledDate:cellDate] || isCustomDate) {
        [cell refreshCellColors];
    }

    //We rasterize the cell for performances purposes.
    //The circle background is made using roundedCorner which is a super expensive operation, specially with a lot of items on the screen to display (like we do)
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *firstOfMonth = [self firstOfMonthForSection:indexPath.section];
    NSDate *cellDate = [self dateForCellAtIndexPath:indexPath];

    //We don't want to select Dates that are "disabled"
    if (![self isEnabledDate:cellDate]) {
        return NO;
    }

    NSDateComponents *cellDateComponents = [self.calendar components:NSCalendarUnitDay|NSCalendarUnitMonth fromDate:cellDate];
    NSDateComponents *firstOfMonthsComponents = [self.calendar components:NSCalendarUnitMonth fromDate:firstOfMonth];

    return (cellDateComponents.month == firstOfMonthsComponents.month);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedDate = [self dateForCellAtIndexPath:indexPath];
    NSString *dataBasePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/MyDiary02"];
    self.dataBase=[FMDatabase databaseWithPath:dataBasePath];
    if (self.dataBase)
    {
        [self.dataBase open];
        [self.projects removeAllObjects];
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components=[calendar components:kCalendarUnitYMD fromDate:self.selectedDate];
        NSString *tableName=[NSString stringWithFormat:@"projectsInYear%ldMonth%ldDay%ld",components.year,components.month,components.day];
        NSString *strQuery=[NSString stringWithFormat:@"select * from %@;",tableName];
        BOOL isThereTable=[self.dataBase executeStatements:strQuery];
        if (isThereTable)
        {
            FMResultSet *resultForProjects=[self.dataBase executeQuery:strQuery];
            while ([resultForProjects next])
            {
                TableViewCellDataSource *data=[[TableViewCellDataSource alloc]initWithText:[resultForProjects stringForColumn:@"project"] Year:[resultForProjects intForColumn:@"year"] Month:[resultForProjects intForColumn:@"month"] Day:[resultForProjects intForColumn:@"day"] Hour:[resultForProjects intForColumn:@"hour"] Minute:[resultForProjects intForColumn:@"minute"] Place:[resultForProjects stringForColumn:@"place"] Weekday:[resultForProjects intForColumn:@"weekday"]];
                [self.projects addObject:data];
            }
            [self.tableView reloadData];
        }
        else
        {
            [self.tableView reloadData];
        }
        [self.dataBase close];
    }
    UILabel *label=[self.toolBtn05 customView];
    label.text=[NSString stringWithFormat:@"%ld日记",self.projects.count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        PDTSimpleCalendarViewHeader *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PDTSimpleCalendarViewHeaderIdentifier forIndexPath:indexPath];

        headerView.titleLabel.text = [self.headerDateFormatter stringFromDate:[self firstOfMonthForSection:indexPath.section]].uppercaseString;

        headerView.layer.shouldRasterize = YES;
        headerView.layer.rasterizationScale = [UIScreen mainScreen].scale;

        return headerView;
    }

    return nil;
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = floorf(CGRectGetWidth(self.collectionView.bounds) / self.daysPerWeek);

    return CGSizeMake(itemWidth, itemWidth);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //We only display the overlay view if there is a vertical velocity
    if (fabs(velocity.y) > 0.0f) {
        if (self.overlayView.alpha < 1.0) {
            [UIView animateWithDuration:0.25 animations:^{
                [self.overlayView setAlpha:1.0];
            }];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSTimeInterval delay = (decelerate) ? 1.5 : 0.0;
    //[self performSelector:@selector(hideOverlayView) withObject:nil afterDelay:delay];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //Update Content of the Overlay View
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    //indexPaths is not sorted
    NSArray *sortedIndexPaths = [indexPaths sortedArrayUsingSelector:@selector(compare:)];
    NSIndexPath *firstIndexPath = [sortedIndexPaths firstObject];

    self.overlayView.text = [self.headerDateFormatter stringFromDate:[self firstOfMonthForSection:firstIndexPath.section]];
}

//- (void)hideOverlayView
//{
    //[UIView animateWithDuration:0.25 animations:^{
        //[self.overlayView setAlpha:0.0];
    //}];
//}

#pragma mark -
#pragma mark - Calendar calculations

- (NSDate *)clampDate:(NSDate *)date toComponents:(NSUInteger)unitFlags
{
    NSDateComponents *components = [self.calendar components:unitFlags fromDate:date];
    return [self.calendar dateFromComponents:components];
}

- (BOOL)isTodayDate:(NSDate *)date
{
    return [self clampAndCompareDate:date withReferenceDate:[NSDate date]];
}

- (BOOL)isSelectedDate:(NSDate *)date
{
    if (!self.selectedDate) {
        return NO;
    }
    return [self clampAndCompareDate:date withReferenceDate:self.selectedDate];
}

- (BOOL)isEnabledDate:(NSDate *)date
{
    NSDate *clampedDate = [self clampDate:date toComponents:kCalendarUnitYMD];
    if (([clampedDate compare:self.firstDate] == NSOrderedAscending) || ([clampedDate compare:self.lastDate] == NSOrderedDescending)) {
        return NO;
    }

    if ([self.delegate respondsToSelector:@selector(simpleCalendarViewController:isEnabledDate:)]) {
        return [self.delegate simpleCalendarViewController:self isEnabledDate:date];
    }

    return YES;
}

- (BOOL)clampAndCompareDate:(NSDate *)date withReferenceDate:(NSDate *)referenceDate
{
    NSDate *refDate = [self clampDate:referenceDate toComponents:kCalendarUnitYMD];
    NSDate *clampedDate = [self clampDate:date toComponents:kCalendarUnitYMD];

    return [refDate isEqualToDate:clampedDate];
}

#pragma mark - Collection View / Calendar Methods

- (NSDate *)firstOfMonthForSection:(NSInteger)section
{
    NSDateComponents *offset = [NSDateComponents new];
    offset.month = section;

    return [self.calendar dateByAddingComponents:offset toDate:self.firstDateMonth options:0];
}

- (NSInteger)sectionForDate:(NSDate *)date
{
    return [self.calendar components:NSCalendarUnitMonth fromDate:self.firstDateMonth toDate:date options:0].month;
}


- (NSDate *)dateForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *firstOfMonth = [self firstOfMonthForSection:indexPath.section];

    NSUInteger weekday = [[self.calendar components: NSCalendarUnitWeekday fromDate: firstOfMonth] weekday];
    NSInteger startOffset = weekday - self.calendar.firstWeekday;
    startOffset += startOffset >= 0 ? 0 : self.daysPerWeek;

    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = indexPath.item - startOffset;

    return [self.calendar dateByAddingComponents:dateComponents toDate:firstOfMonth options:0];
}


static const NSInteger kFirstDay = 1;
- (NSIndexPath *)indexPathForCellAtDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    NSInteger section = [self sectionForDate:date];
    NSDate *firstOfMonth = [self firstOfMonthForSection:section];

    NSInteger weekday = [[self.calendar components: NSCalendarUnitWeekday fromDate: firstOfMonth] weekday];
    NSInteger startOffset = weekday - self.calendar.firstWeekday;
    startOffset += startOffset >= 0 ? 0 : self.daysPerWeek;

    NSInteger day = [[self.calendar components:kCalendarUnitYMD fromDate:date] day];

    NSInteger item = (day - kFirstDay + startOffset);

    return [NSIndexPath indexPathForItem:item inSection:section];
}

- (PDTSimpleCalendarViewCell *)cellForItemAtDate:(NSDate *)date
{
    return (PDTSimpleCalendarViewCell *)[self.collectionView cellForItemAtIndexPath:[self indexPathForCellAtDate:date]];
}

#pragma mark - PDTSimpleCalendarViewCellDelegate

- (BOOL)simpleCalendarViewCell:(PDTSimpleCalendarViewCell *)cell shouldUseCustomColorsForDate:(NSDate *)date
{
    //If the date is not enabled (aka outside the first/lastDate) return YES
    if (![self isEnabledDate:date]) {
        return YES;
    }

    //Otherwise we ask the delegate
    if ([self.delegate respondsToSelector:@selector(simpleCalendarViewController:shouldUseCustomColorsForDate:)]) {
        return [self.delegate simpleCalendarViewController:self shouldUseCustomColorsForDate:date];
    }

    return NO;
}

- (UIColor *)simpleCalendarViewCell:(PDTSimpleCalendarViewCell *)cell circleColorForDate:(NSDate *)date
{
    if (![self isEnabledDate:date]) {
        return cell.circleDefaultColor;
    }

    if ([self.delegate respondsToSelector:@selector(simpleCalendarViewController:circleColorForDate:)]) {
        return [self.delegate simpleCalendarViewController:self circleColorForDate:date];
    }

    return nil;
}

- (UIColor *)simpleCalendarViewCell:(PDTSimpleCalendarViewCell *)cell textColorForDate:(NSDate *)date
{
    if (![self isEnabledDate:date]) {
        return cell.textDisabledColor;
    }

    if ([self.delegate respondsToSelector:@selector(simpleCalendarViewController:textColorForDate:)]) {
        return [self.delegate simpleCalendarViewController:self textColorForDate:date];
    }

    return nil;
}

@end
