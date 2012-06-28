//
//  Login+LoginCategory.m
//  JournalDatabase
//
//  Created by karthik jagadeesh on 6/26/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import "Login+LoginCategory.h"
#import "User+UserCategory.h"

@implementation Login (LoginCategory)

+ (Login *)loginWithInfo:(NSDictionary *)loginInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    Login *login = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Login"];
    //request.predicate = [NSPredicate predicateWithFormat:@"email = %@", [loginInfo objectForKey:LOGIN_EMAIL]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"email" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        //error
    } else if ([matches count] == 0) {
        login = [NSEntityDescription insertNewObjectForEntityForName:@"Login" inManagedObjectContext:context];
      //  login.email = [loginInfo objectForKey:LOGIN_EMAIL];
        //login.password = [loginInfo objectForKey:LOGIN_PASSWORD];
        
        //********* must take user info */
        //login.user = [User userWithInfo:[loginInfo objectForKey:LOGIN_USER_INFO] inManagedObjectContext:context];
        //*********
        
        
        //update user info here
    } else {
        login = [matches lastObject];
    }
    return login;
    
}

@end
