//
//  CaptureNoteViewController.m
//  JournalDatabase
//
//  Created by Karthik Jagadeesh on 7/2/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import "CaptureNoteViewController.h"

@implementation CaptureNoteViewController
@synthesize note = _note;
@synthesize user = _user;
@synthesize lifeDatabase = _lifeDatabase;


- (void)setUser:(User *)user 
{
    _user = user;
}

- (IBAction)captureNote:(id)sender {
    NSString * content = self.note.text;
    NSDate * todaysDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString * justDate = [dateFormatter stringFromDate:todaysDate];
    NSDate * date = [dateFormatter dateFromString:justDate];
    
  //  NSLog(@"The user %@", self.user);
  //  NSLog(@"The short version of date: %@", justDate);
    NSDictionary *noteInfo = [NSDictionary dictionaryWithObjectsAndKeys:content, @"NOTE_INFO_CONTENT", todaysDate, @"NOTE_INFO_DATEWITHTIME", date, @"NOTE_INFO_DATE", self.user, @"NOTE_INFO_USER", nil];
    
   // NSLog(@"This note dict: %@", noteInfo);
    
    Note *note = [Note noteWithInfo:noteInfo inManagedObjectContext:self.lifeDatabase.managedObjectContext];
    
  //  NSLog(@"Here is note: %@", note);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setLifeDatabase:(UIManagedDocument *)lifeDatabase
{
    _lifeDatabase = lifeDatabase;
}


/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Back to Life Options"]) {
        [segue.destinationViewController setLifeDatabase:self.lifeDatabase];
        [segue.destinationViewController setUser:self.user];
    }
}*/
- (void)viewDidUnload {
    [self setNote:nil];
    [self setNote:nil];
    [super viewDidUnload];
}
@end
