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
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CheckIn"];
    request.predicate = [NSPredicate predicateWithFormat:@"datewithtime = %@", [checkInInfo objectForKey:@"CHECKIN_INFO_DATEWITHTIME"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"datewithtime" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) {
        //error
    } else if ([matches count] == 0) {
        checkin = [NSEntityDescription insertNewObjectForEntityForName:@"CheckIn" inManagedObjectContext:context];
        checkin.date = [checkInInfo objectForKey:@"CHECKIN_INFO_DATE"];
        checkin.location = [checkInInfo objectForKey:@"CHECKIN_INFO_LOCATION"];
        NSLog(@"This is the place: %@", [checkInInfo objectForKey:@"CHECKIN_INFO_PLACE"]);
        checkin.place = [checkInInfo objectForKey:@"CHECKIN_INFO_PLACE"];
        checkin.datewithtime = [checkInInfo objectForKey:@"CHECKIN_INFO_DATEWITHTIME"];
        checkin.whoAdded = [checkInInfo objectForKey:@"CHECKIN_INFO_WHOADDED"];
        
        //update user info here
    } else {
        checkin = [matches lastObject];
    } 
    return checkin;
    
}
@end
