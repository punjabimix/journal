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
    Login * tmpLogin = (Login *)[userInfo objectForKey:@"USER_INFO_LOGIN"];
    NSLog(@"printing login: %@", tmpLogin);
    
    request.predicate = [NSPredicate predicateWithFormat:@"login.email = %@", tmpLogin.email];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        //error
    } else if ([matches count] == 0) {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        user.firstName = [userInfo objectForKey:@"USER_INFO_FIRSTNAME"];
        user.lastName = [userInfo objectForKey:@"USER_INFO_LASTNAME"];
        user.age = [userInfo objectForKey:@"USER_INFO_AGE"];
        user.gender = [userInfo objectForKey:@"USER_INFO_GENDER"];
        user.dob = [userInfo objectForKey:@"USER_INFO_DOB"];
        user.login = [userInfo objectForKey:@"USER_INFO_LOGIN"];
        
        
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
