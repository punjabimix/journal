//
//  CheckIn+CheckInCategory.m
//  JournalDatabase
//
//  Created by Karthik Jagadeesh on 7/5/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import "CheckIn+CheckInCategory.h"

@implementation CheckIn (CheckInCategory)


+ (CheckIn *)checkInWithInfo:(NSDictionary *)checkInInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    CheckIn *checkin = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"date = %@", [checkInInfo objectForKey:@"CHECKIN_INFO_DATEWITHTIME"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"datewithtime" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        //error
    } else if ([matches count] == 0) {
        checkin = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        checkin.date = [checkInInfo objectForKey:@"CHECKIN_INFO_DATE"];
        checkin.location = [checkInInfo objectForKey:@"CHECKIN_INFO_LOCATION"];
        checkin.datewithtime = [checkInInfo objectForKey:@"CHECKIN_INFO_DATEWITHTIME"];
        checkin.whoAdded = [checkInInfo objectForKey:@"CHECKIN_INFO_WHOADDED"];
        
        
        //********* must take user info */
        //photo.whoAdded = [User userWithInfo:[photoInfo objectForKey:PHOTO_USER_INFO] inManagedObjectContext:context];
        //*********
        
        
        //update user info here
    } else {
        checkin = [matches lastObject];
    } 
    return checkin;
    
}
@end
