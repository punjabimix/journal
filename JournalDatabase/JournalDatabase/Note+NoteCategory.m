//
//  Note+NoteCategory.m
//  JournalDatabase
//
//  Created by Karthik Jagadeesh on 7/2/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import "Note+NoteCategory.h"

@implementation Note (NoteCategory)

+ (Note *)noteWithInfo:(NSDictionary *)noteInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    Note *note = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    request.predicate = [NSPredicate predicateWithFormat:@"datewithtime = %@", [noteInfo objectForKey:@"NOTE_INFO_DATEWITHTIME"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        //error
    } else if ([matches count] == 0) {
        note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
        note.content = [noteInfo objectForKey:@"NOTE_INFO_CONTENT"];
        note.date = [noteInfo objectForKey:@"NOTE_INFO_DATE"];
        note.datewithtime = [noteInfo objectForKey:@"NOTE_INFO_DATEWITHTIME"];
        note.location = [noteInfo objectForKey:@"NOTE_INFO_LOCATION"];
        
        
        //********* must take user info */
        note.whoAdded = [noteInfo objectForKey: @"NOTE_INFO_USER"];
        //*********
        
        
        //update user info here
    } else {
        note = [matches lastObject];
    } 
    return note;
    
}

@end
