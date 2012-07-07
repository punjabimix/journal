//
//  PrintMyLocationViewController.m
//  JournalDatabase
//
//  Created by karthik jagadeesh on 7/2/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import "PrintMyLocationViewController.h"

@implementation PrintMyLocationViewController
@synthesize myLocationManager = _myLocationManager;
@synthesize myGeocoder = _myGeocoder;
@synthesize user = _user;
@synthesize lifeDatabase = _lifeDatabase;

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

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{ /* We received the new location */
    NSLog(@"Latitude = %f", newLocation.coordinate.latitude);
    NSLog(@"Longitude = %f", newLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /* Failed to receive user's location */
}

#pragma mark - View lifecycle

- (void) setLifeDatabase:(UIManagedDocument *)lifeDatabase
{
    _lifeDatabase = lifeDatabase;
}

- (void) setUser:(User *) user
{
    _user = user;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([CLLocationManager locationServicesEnabled]) {
        self.myLocationManager = [[CLLocationManager alloc] init];
        self.myLocationManager.delegate = self;
        self.myLocationManager.purpose = @"To provide functionality based on user's current location.";
        [self.myLocationManager startUpdatingLocation]; 
    } else {
        /* Location services are not enabled. Take appropriate action: for instance, prompt the user to enable the location services */
        NSLog(@"Location services are not enabled");
        
    }
}

- (IBAction)saveLocation:(id)sender {
    CLLocation *location = self.myLocationManager.location;
    self.myGeocoder = [[CLGeocoder alloc] init];
    
    NSDate *todaysDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString * justDate = [dateFormatter stringFromDate:todaysDate];
    NSDate * date = [dateFormatter dateFromString:justDate];
    
    NSMutableDictionary *checkInInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys: self.user, @"CHECKIN_INFO_USER", date, @"CHECKIN_INFO_DATE", todaysDate, @"CHECKIN_INFO_DATEWITHTIME", nil];
    [self.myGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"List of places: %@", placemarks);
            NSLog(@"Country: %@", placemark.country);
            [checkInInfo setValue:placemark.country forKey:@"CHECKIN_INFO_PLACE"];
            NSLog(@"Postal Code: %@", placemark.postalCode);
            [checkInInfo setValue:placemark.postalCode forKey:@"CHECKIN_INFO_LOCATION"];
            NSLog(@"Locality: %@", placemark.locality);
        } else if (error==nil && [placemarks count] == 0) {
            NSLog(@"No results found");
        } else if (error != nil) {
            NSLog(@"error occurred");
        }
    }];
    // This is currently adding nil
    // we will need to create a view for user to pick location and add to db based on that
    CheckIn *checkin = [CheckIn checkInWithInfo:checkInInfo inManagedObjectContext:self.lifeDatabase.managedObjectContext];
    NSLog(@"Here is the check-in: %@", checkin);
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
    [self.myLocationManager stopUpdatingLocation]; 
    self.myLocationManager = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
