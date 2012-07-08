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

@implementation LifeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

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
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusNav = statusBarHeight + navBarHeight;
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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,SCROLL_HEIGHT, rect.size.width, rect.size.height-2*SCROLL_HEIGHT-statusNav) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    
    NSLog(@"This is the mainscreen: %@", [UIScreen mainScreen]);
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, rect.size.height - SCROLL_HEIGHT - statusNav, rect.size.width, SCROLL_HEIGHT)];
    bottomScrollView.contentSize = CGSizeMake(rect.size.width, SCROLL_HEIGHT);
    bottomScrollView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:bottomScrollView];
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
