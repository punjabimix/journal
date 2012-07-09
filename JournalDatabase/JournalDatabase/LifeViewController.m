//
//  LifeViewController.m
//  JournalDatabase
//
//  Created by Karthik Jagadeesh on 7/7/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import "LifeViewController.h"

#define BUTTON_DIM 45
#define SCROLL_HEIGHT 50

#define CELL_HEIGHT 100
#define HEADER_HEIGHT 20
#define SCROLL_VIEW_HEIGHT 80
#define ITEM_WIDTH 80

@implementation LifeViewController

@synthesize lifeDatabase = _lifeDatabase;
@synthesize user = _user;
@synthesize entries = _entries;
@synthesize dates = _dates;
@synthesize tableView = _tableView;

-(void) setEntries:(NSDictionary *)entries
{
    if (_entries != entries) {
        _entries = entries;
    }
}


-(void)setupFetchedResultsController
{
    // initializing the request for each table
    NSFetchRequest *requestMedia = [[NSFetchRequest alloc] init];
    NSFetchRequest *requestNote = [[NSFetchRequest alloc] init];
    NSFetchRequest *requestCheckin = [[NSFetchRequest alloc] init];
    
    // creating the entity description for each table
    NSEntityDescription *mediaEntity = [NSEntityDescription entityForName:@"Media" inManagedObjectContext:self.lifeDatabase.managedObjectContext];
    NSEntityDescription *noteEntity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.lifeDatabase.managedObjectContext];
    NSEntityDescription *checkInEntity = [NSEntityDescription entityForName:@"CheckIn" inManagedObjectContext:self.lifeDatabase.managedObjectContext];
    
    requestMedia.predicate = [NSPredicate predicateWithFormat:@"whoAdded.id = %@", self.user.id];
    requestNote.predicate = [NSPredicate predicateWithFormat:@"whoAdded.id = %@", self.user.id];
    requestCheckin.predicate = [NSPredicate predicateWithFormat:@"whoAdded.id = %@", self.user.id];
    
    // setting up the entity of request for each table
    requestMedia.entity = mediaEntity; 
    requestNote.entity = noteEntity;
    requestCheckin.entity = checkInEntity;
    
    // all requests should return distinct results
    requestMedia.returnsDistinctResults = YES;
    requestCheckin.returnsDistinctResults = YES;
    requestNote.returnsDistinctResults = YES;
    
    // all request should return an nsdictionaryresulttype
    requestMedia.resultType = NSManagedObjectResultType;
    requestNote.resultType = NSManagedObjectResultType;
    requestCheckin.resultType = NSManagedObjectResultType;
    
    // same sort descriptor will be used for all tables since they are all
    // sorted using the same attribute (datewithtime)
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datewithtime" ascending:YES];
    
    // set sort descriptor for each request
    [requestMedia setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [requestNote setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [requestCheckin setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    
    // execute the request using managed object context
    NSError *error;
    NSArray *medias = [self.lifeDatabase.managedObjectContext executeFetchRequest:requestMedia error:&error];
    
    NSArray *checkins = [self.lifeDatabase.managedObjectContext executeFetchRequest:requestCheckin error:&error];
    
    NSArray *notes = [self.lifeDatabase.managedObjectContext executeFetchRequest:requestNote error:&error];
    
    
    /*
     if ([photos isKindOfClass:[NSArray class]]) {
     NSLog(@"Dates is Array");
     } else if ([photos isKindOfClass:[NSDictionary class]]) {
     NSLog(@"Dates is dic");
     }
     */
    
    self.entries = [[NSMutableDictionary alloc] init];
    NSLog(@"count from media query %i", [medias count]);
    NSLog(@"count from checkin query %i", [checkins count]);
    NSLog(@"count from note query %i", [notes count]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    // Take the 4 separate arrays and merge in one array
    NSMutableSet *set = [NSMutableSet setWithArray:medias];
    [set addObjectsFromArray:notes];
    [set addObjectsFromArray:checkins];
    NSArray *allEntries = [set allObjects];
    
    //NSLog(@"All entries so far: %@", allEntries);
    
    //separate out the entries based on day
    for (int i =0 ; i< [allEntries count]; i++) {
        NSString *dateString = nil;
        NSObject *ith = [allEntries objectAtIndex:i]; 
        if ([ith isKindOfClass:[Media class]]) {
            Photo *obj = (Photo *)ith;
            dateString = [dateFormatter stringFromDate:obj.date];
            // NSLog(@"This is a photo");
        } else if ([ith isKindOfClass:[Note class]]) {
            Note *obj = (Note *)ith;
            dateString = [dateFormatter stringFromDate:obj.date];
            // NSLog(@"This is a note");
        } else if ([ith isKindOfClass:[CheckIn class]]) {
            CheckIn *obj = (CheckIn *)ith;        
            dateString = [dateFormatter stringFromDate:obj.date];
            // NSLog(@"This is a checkin");
        }
        
        // NSLog(@"ith: %@", ith);
        NSMutableArray *arrayOfEntry = [self.entries objectForKey:dateString];
        // NSLog(@"%@", dateString);
        if (!arrayOfEntry) {
            arrayOfEntry = [[NSMutableArray alloc] init];
            [arrayOfEntry addObject:ith];
            [self.entries setObject:arrayOfEntry forKey:dateString];
        } else {
            [arrayOfEntry addObject:ith];
        }
    }
    
    // NSLog(@"%@", self.entries);
    
    self.dates = [self.entries allKeys];    
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray *sorters = [[NSArray alloc] initWithObjects:sorter, nil];
    self.dates = [self.dates sortedArrayUsingDescriptors:sorters];
    
    NSLog(@"Callling reload data");
    
    //[self.tableView reloadData];
    
    //NSLog(@"Dates: %@",self.dates);
    
    // NSDate *o = [self.dates objectAtIndex:0];
    
    // NSLog(@"object should be date %a",[o description]);
    //[request release];
    //[self.tableView reloadData];
    
    
    // NSLog(@"Dates: %@",self.dates);
    /*
     self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.lifeDatabase.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
     
     NSLog(@"fetched result: %@", self.dates);
     */
}

- (void)useDocument
{
    NSLog(@"In LifeViewCOntroller USeDOcument");
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.lifeDatabase.fileURL path]]) {
        NSLog(@"Document is new");
        [self.lifeDatabase saveToURL:self.lifeDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
            //[self fetchFlickerDataIntoDocument:self.lifeDatabase];
        }];
    } else if (self.lifeDatabase.documentState == UIDocumentStateClosed) {
        NSLog(@"Document is closed");
        [self.lifeDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.lifeDatabase.documentState == UIDocumentStateNormal) {
        NSLog(@"Document is open");
        [self setupFetchedResultsController];
    }
}

- (void)setLifeDatabase:(UIManagedDocument *)lifeDatabase
{
    // NSLog(@"i am in the set lifedatabase of Homepage");
    
    if(_lifeDatabase != lifeDatabase) {
        NSLog(@"i am in the set life database if");
        _lifeDatabase = lifeDatabase;
        //[self useDocument];
    }
}

-(void) setUser:(User *)user
{
    // NSLog(@"i am in the set user");
    _user = user;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.lifeDatabase) {
        NSLog(@"Reseting PhotoDase again");
        
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Photo Database"];
        self.lifeDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
        //[self useDocument];
    }
    //
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.entries.allKeys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusNav = statusBarHeight;
    CGRect rect = [[UIScreen mainScreen] bounds];
    NSArray *imageFiles = [NSArray arrayWithObjects:  @"checkin.png", @"note.png", @"camera.jpeg", @"video.jpeg", @"audio.jpeg", nil];
    
    // start creating subviews to show the scroll and table view
    UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, SCROLL_HEIGHT)];
    topScrollView.contentSize = CGSizeMake((BUTTON_DIM+3)*[imageFiles count], SCROLL_HEIGHT);
    topScrollView.backgroundColor = [UIColor orangeColor];
    
    for (int i=0; i < [imageFiles count]; i++) {
        UIButton *lifeOptionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        lifeOptionButton.frame = CGRectMake((i+1)*3+(BUTTON_DIM)*i,2,BUTTON_DIM,BUTTON_DIM);
        NSString *filename = [imageFiles objectAtIndex:i];
        [lifeOptionButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
        [topScrollView addSubview:lifeOptionButton];
    }
    
    [self.view addSubview:topScrollView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,SCROLL_HEIGHT, rect.size.width, rect.size.height-2*SCROLL_HEIGHT-statusNav) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // [self.tableView.numberOfSections];
   // self.tableView
   // self.tableView.rowHeight = CELL_HEIGHT;
    
    [self.view addSubview:self.tableView];
    
    //[self.tableView reloadData];
    
    NSLog(@"This is the mainscreen: %@", [UIScreen mainScreen]);
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, rect.size.height - SCROLL_HEIGHT - statusNav, rect.size.width, SCROLL_HEIGHT)];
    bottomScrollView.contentSize = CGSizeMake(rect.size.width, SCROLL_HEIGHT);
    bottomScrollView.backgroundColor = [UIColor purpleColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(0, 0, 60, 30);
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [bottomScrollView addSubview:backButton];
    
    [self.view addSubview:bottomScrollView];
    [self useDocument];
}

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"In cellforRowatIndexPath");
    
    /*
     static NSString *CellIdentifier = @"Day Cell";
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     
     return cell;*/
    
    /*  
     static NSString *CellIdentifier = @"Day Cell";
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     
     Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
     
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
     cell.textLabel.text = [dateFormatter stringFromDate:photo.date];
     
     NSLog(@"row index: %i",indexPath.row);
     
     NSArray *currencies = [NSArray arrayWithObjects:@"Dollar", @"Euro", @"Pound", @"hello", @"222", @"45gfg", nil];
     NSString *name = (NSString *)[currencies objectAtIndex:indexPath.row];
     NSLog(@"name: %@", name);
     cell.textLabel.text = name;
     
     //NSLog([dateFormatter stringFromDate:photo.date]);
     
     // Configure the cell...
     
     return cell;
     */
    
    
    //[self.tableView reloadData];
    static NSString *CellIdentifier = @"Day Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSLog(@"the is the cell: %@", cell);
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //NSLog(@"IndexPath %@",indexPath);
    // NSLog(@"IndexPath.section %@",indexPath.section);
    // NSInteger *row = indexPath.row;
    //NSLog(@"Indexpath. row %i", row);
    
    
    //NSLog(@"INdexpath length: %@",[indexPath length]);
    // NSUInteger *rowArray = [indexPath indexAtPosition:indexPath.section];
    //NSLog(@"NSrowArray %@",rowArray);
    
    NSLog(@"NSDATES: %@",self.dates);
    
    NSString *date = [self.dates objectAtIndex:indexPath.row];
    //date = (NSDate *)[self.dates objectAtIndex:indexPath.row];
    //if ([dat isKindOfClass:[NSDictionary class]])
    //   date = [(NSDictionary *)d objectForKey:@"date"];
    NSLog(@"date in cell: %@",date);
    
    NSArray *itemsForDate = [self.entries objectForKey:date];
    
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datewithtime"
                                                  ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    itemsForDate = [itemsForDate sortedArrayUsingDescriptors:sortDescriptors];
    
    
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, CELL_HEIGHT)];
    //view.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206/255.0 blue:235.0/255.0 alpha:1.0];
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, HEADER_HEIGHT)];
    //headerView.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206/255.0 blue:235.0/255.0 alpha:1.0];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 1, rect.size.width-2, HEADER_HEIGHT-1)];
    //headerLabel.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206/255.0 blue:235.0/255.0 alpha:1.0];
    [headerLabel setTextColor:[UIColor blackColor]];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    headerLabel.text = date;
    
    [headerView addSubview:headerLabel];
    [view   addSubview:headerView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HEADER_HEIGHT, rect.size.width, SCROLL_VIEW_HEIGHT)];
    scrollView.backgroundColor = [UIColor clearColor];
    //scrollView.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0];
    scrollView.contentSize = CGSizeMake(ITEM_WIDTH*[itemsForDate count],SCROLL_VIEW_HEIGHT);
    for (int i=0; i<[itemsForDate count]; i++)
    {
        //NSURL *url = [NSURL URLWithString:[itemsForDate objectAtIndex:i]];
        //NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        UIView *buttonBackground = [[UIView alloc] initWithFrame:CGRectMake(i*(ITEM_WIDTH+2), 0, ITEM_WIDTH, SCROLL_VIEW_HEIGHT)];
        buttonBackground.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        
        UIButton *buttonForItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buttonForItem.frame = CGRectMake(7.5, 7.5, ITEM_WIDTH-15, SCROLL_VIEW_HEIGHT-15);
        
        NSObject *obj = [itemsForDate objectAtIndex:i]; 
        if ([obj isKindOfClass:[Media class]]) {
            Media *mediaObj = (Media *)obj;
            NSString *type = mediaObj.type;
            NSLog(@"MediaObj Type: %@",type);
            
            NSURL *url = [NSURL fileURLWithPath:mediaObj.source];
            
            // NSLog(@"%@", [type compare:@"video"]);
            if([type isEqualToString:@"video"]) {
                
                AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
                AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                NSError *err = NULL;
                CMTime time = CMTimeMake(1, 10);
                CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
                // NSLog(@"err==%@, imageRef==%@", err, imgRef);
                UIImage *currentImg = [[UIImage alloc] initWithCGImage:imgRef];
                [buttonForItem setBackgroundImage:currentImg forState:UIControlStateNormal];
                [buttonForItem setImage:[UIImage imageNamed:@"play.png"]  forState:UIControlStateNormal];
            } else if([type isEqualToString:@"photo"]) {
                
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                [buttonForItem setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                
            }
            
            NSLog(@"File URL: %@", mediaObj.source);
        } else if ([obj isKindOfClass:[Note class]]) {
            Note *noteObj = (Note *)obj;
            // UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake((ITEM_WIDTH+2)*i, 0, ITEM_WIDTH, SCROLL_VIEW_HEIGHT)];
            //headerLabel.text = noteObj.content;
            //b//uttonForItem.titleLabel.text = noteObj.content;
            
            [buttonForItem setTitle:noteObj.content forState:UIControlStateNormal];
            
            NSLog(@"Note description: %@", noteObj.content);
        } else if ([obj isKindOfClass:[CheckIn class]]) {
            CheckIn *checkInObj = (CheckIn *)obj;
            NSString *checkedIn = @"Checked in at ";
            [checkedIn stringByAppendingString:checkInObj.place];
            //buttonForItem.titleLabel.text =  checkedIn;
            [buttonForItem setTitle:checkedIn forState:UIControlStateNormal];
            
            NSLog(@"CheckInLocation: %@", checkInObj.location);
        }
        
        //buttonForItem.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        [buttonBackground addSubview:buttonForItem];
        // NSData *imageData= (NSData *)[(NSDictionary *)[itemsForDate objectAtIndex:i] objectForKey:@"bitmap"];
        // UIImage *image = [UIImage imageWithData:imageData];
        // UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        // imageView.frame = CGRectMake(ITEM_WIDTH*i, 0, ITEM_WIDTH, SCROLL_VIEW_HEIGHT);
        // imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:buttonBackground];
    }
    [view addSubview:scrollView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.contentView addSubview:view];
    
    
    return cell;
    
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
