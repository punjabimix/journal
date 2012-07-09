//
//  EntriesViewController.m
//  JournalDatabase
//
//  Created by karthik jagadeesh on 7/8/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import "EntriesViewController.h"

@implementation EntriesViewController

@synthesize lifeDatabase = _lifeDatabase;
@synthesize scrollViewEntries = _scrollViewEntries;
@synthesize user = _user;
@synthesize selectedEntryNumber = _selectedEntryNumber;

- (void)setLifeDatabase:(UIManagedDocument *)lifeDatabase
{
    if(_lifeDatabase != lifeDatabase) {
        _lifeDatabase = lifeDatabase;
    }
}

-(void) setUser:(User *)user
{
   _user = user;
}

-(void) setSelectedEntryNumber:(NSNumber *)selectedEntryNumber
{
    _selectedEntryNumber = selectedEntryNumber;
}

-(void) setScrollViewEntries:(NSMutableArray *)scrollViewEntries
{
    _scrollViewEntries = scrollViewEntries;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.lifeDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Photo Database"];
        self.lifeDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}
/*
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
*/

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    //CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    //CGFloat statusNav = statusBarHeight;
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    scrollView.contentSize = CGSizeMake(rect.size.width*[self.scrollViewEntries count], rect.size.height);
    //topScrollView.backgroundColor = [UIColor orangeColor];
    
    for (int i=0; i < [self.scrollViewEntries count]; i++) {
        UIView *entryView = [[UIView alloc] initWithFrame:CGRectMake(i*rect.size.width, 0, rect.size.width, rect.size.height)];
        
        UIView *entryTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height*0.6)];
        UIView *entryBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height*0.6, rect.size.width, rect.size.height*0.4)];
        
        NSObject *entryObj = [self.scrollViewEntries objectAtIndex:i]; 
        if ([entryObj isKindOfClass:[Media class]]) {
            Media *mediaObj = (Media *)entryObj;
            NSString *type = mediaObj.type;
            
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
                UIImageView* topImageView = [[UIImageView alloc] initWithImage:currentImg];
                topImageView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height*0.6);
                //topImageView.contentMode = UIViewContentModeScaleAspectFit;
                [entryTopView addSubview:topImageView];
                
                /*************add 40% text*/
                
                
            } else if([type isEqualToString:@"photo"]) {
                
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                UIImage *currentImg = [UIImage imageWithData:imageData];
                UIImageView* topImageView = [[UIImageView alloc] initWithImage:currentImg];
                topImageView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height*0.6);
                //topImageView.contentMode = UIViewContentModeScaleAspectFit;
                [entryTopView addSubview:topImageView];
                /*************add 40% text*/
                
            }
            
          //  NSLog(@"File URL: %@", mediaObj.source);
        } else if ([entryObj isKindOfClass:[Note class]]) {
            Note *noteObj = (Note *)entryObj;
            // UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake((ITEM_WIDTH+2)*i, 0, ITEM_WIDTH, SCROLL_VIEW_HEIGHT)];
            //headerLabel.text = noteObj.content;
            //b//uttonForItem.titleLabel.text = noteObj.content;
            
           // [buttonForItem setTitle:noteObj.content forState:UIControlStateNormal];
            UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height*0.4)];
            bottomLabel.text = noteObj.content;
            [bottomLabel setTextColor:[UIColor blackColor]];
            [bottomLabel setTextAlignment:UITextAlignmentCenter];
            [entryBottomView addSubview:bottomLabel];
            
            NSLog(@"Note description: %@", noteObj.content);
        } else if ([entryObj isKindOfClass:[CheckIn class]]) {
            CheckIn *checkInObj = (CheckIn *)entryObj;
            NSString *checkedIn = @"Checked in at ";
            [checkedIn stringByAppendingString:checkInObj.place];
            //buttonForItem.titleLabel.text =  checkedIn;
           // [buttonForItem setTitle:checkedIn forState:UIControlStateNormal];
            UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height*0.4)];
            bottomLabel.text = checkedIn;
            [bottomLabel setTextColor:[UIColor blackColor]];
            [bottomLabel setTextAlignment:UITextAlignmentCenter];
            [entryBottomView addSubview:bottomLabel];
            NSLog(@"CheckInLocation: %@", checkInObj.location);
        }
        [entryView addSubview:entryTopView];
        [entryView addSubview:entryBottomView];
        
        [scrollView addSubview:entryView];
    }
    scrollView.pagingEnabled = YES;
    [scrollView setContentOffset:CGPointMake([self.selectedEntryNumber floatValue]*rect.size.width, 0) animated:NO];
    [self.view addSubview:scrollView];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
