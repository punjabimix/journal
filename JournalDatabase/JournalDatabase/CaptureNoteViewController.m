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

- (void) setLifeDatabase:(UIManagedDocument *)lifeDatabase
{
    _lifeDatabase = lifeDatabase;
}

- (IBAction)captureNote:(id)sender {
    NSString * content = self.note.text;
    
    NSDictionary *noteInfo = [NSDictionary dictionaryWithObjectsAndKeys:content, @"NOTE_INFO_CONTENT", self.user, @"NOTE_INFO_USER", nil];
    
    [Note noteWithInfo:noteInfo inManagedObjectContext:self.lifeDatabase.managedObjectContext];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Back to Life Options"]) {
        [segue.destinationViewController setLifeDatabase:self.lifeDatabase];
        [segue.destinationViewController setUser:self.user];
    }
}
@end
