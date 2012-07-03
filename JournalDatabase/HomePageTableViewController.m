//
//  HomePageTableViewController.m
//  JournalDatabase
//
//  Created by karthik jagadeesh on 6/27/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import "HomePageTableViewController.h"


@implementation HomePageTableViewController

@synthesize lifeDatabase = _lifeDatabase;
@synthesize user = _user;

-(void)fetchFlickerDataIntoDocument:(UIManagedDocument *)document
{
    NSDate *now = [NSDate date];
    NSString *myString = @"Test string.";
    const char *utfString = [myString UTF8String];
    NSData *myData = [NSData dataWithBytes: utfString length: strlen(utfString)];
    
    NSDictionary *photoInfo = [NSDictionary dictionaryWithObjectsAndKeys: myData, @"PHOTO_INFO_BITMAP", now, @"PHOTO_INFO_DATE", @"1stphoto", @"PHOTO_INFO_CAPTION", nil];
    NSDictionary *photoInfo2 = [NSDictionary dictionaryWithObjectsAndKeys: myData, @"PHOTO_INFO_BITMAP", [NSDate dateWithTimeIntervalSince1970:20], @"PHOTO_INFO_DATE", @"2ndphoto", @"PHOTO_INFO_CAPTION", nil];
    NSDictionary *photoInfo3 = [NSDictionary dictionaryWithObjectsAndKeys: myData, @"PHOTO_INFO_BITMAP", [NSDate dateWithTimeIntervalSince1970:200], @"PHOTO_INFO_DATE", @"3rdphoto", @"PHOTO_INFO_CAPTION", nil];
    NSDictionary *photoInfo4 = [NSDictionary dictionaryWithObjectsAndKeys: myData, @"PHOTO_INFO_BITMAP", [NSDate dateWithTimeIntervalSince1970:625], @"PHOTO_INFO_DATE", @"4thphoto", @"PHOTO_INFO_CAPTION", nil];
    [Photo photoWithInfo:photoInfo inManagedObjectContext:document.managedObjectContext];
    [Photo photoWithInfo:photoInfo2 inManagedObjectContext:document.managedObjectContext];
    [Photo photoWithInfo:photoInfo3 inManagedObjectContext:document.managedObjectContext];
    [Photo photoWithInfo:photoInfo4 inManagedObjectContext:document.managedObjectContext];
    
    
}

-(void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"whoAdded.id = %@", self.user.id];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.lifeDatabase.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)useDocument
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.lifeDatabase.fileURL path]]) {
        [self.lifeDatabase saveToURL:self.lifeDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
           // [self fetchFlickerDataIntoDocument:self.lifeDatabase];
            
        }];
    } else if (self.lifeDatabase.documentState == UIDocumentStateClosed) {
        [self.lifeDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.lifeDatabase.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController];
    }
}

- (void)setLifeDatabase:(UIManagedDocument *)lifeDatabase
{
    if(_lifeDatabase != lifeDatabase) {
        _lifeDatabase = lifeDatabase;
        [self useDocument];
    }
}

-(void) setUser:(User *)user
{
    NSLog(@"i am in the set user");
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
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Day Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    cell.textLabel.text = [dateFormatter stringFromDate:photo.date];
    
    //NSLog([dateFormatter stringFromDate:photo.date]);
    
    // Configure the cell...
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSDate *date = photo.date;
    if ([segue.destinationViewController respondsToSelector:@selector(setDate:)]) {
        [segue.destinationViewController setUser:self.user];
        [segue.destinationViewController setLifeDatabase:self.lifeDatabase];
        [segue.destinationViewController setDate:date];
    }
}

@end