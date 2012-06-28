//
//  User+UserCategory.m
//  JournalDatabase
//
//  Created by karthik jagadeesh on 6/25/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import "User+UserCategory.h"

@implementation User (UserCategory)

+ (User *)userWithInfo:(NSDictionary *)userInfo inManagedObjectContext:(NSManagedObjectContext *)context 
{
    User *user = nil; 
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    //request.predicate = [NSPredicate predicateWithFormat:@"id = %@", [userInfo objectForKey:USER_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        //error
    } else if ([matches count] == 0) {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
      //  user.firstName = [userInfo objectForKey:USER_FIRST_NAME];
        //user.lastName = [userInfo objectForKey:USER_LAST_NAME];
       // user.age = [userInfo objectForKey:USER_AGE];
       // user.gender = [userInfo objectForKey:USER_GENDER];
       // user.dob = [userInfo objectForKey:USER_DOB];
        
        
        /** need to generate ID for that to happen we need email*/
       // user.id = [userInfo objectForKey:USER_ID];
        
         /*****/
         /*
        user.login = [userInfo objectForKey:USER_LOGIN];
        user.status = [userInfo objectForKey:USER_STATUS];
        user.checkin = [userInfo objectForKey:USER_CHECKIN];
        user.photo = [userInfo objectForKey:USER_PHOTO];
        user.note = [userInfo objectForKey:USER_NOTE];
        user.audio = [userInfo objectForKey:USER_AUDIO];
         */
        
        //update user info here
    } else {
        user = [matches lastObject];
    }
    return user;
}

@end
