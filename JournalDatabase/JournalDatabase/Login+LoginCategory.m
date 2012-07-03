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
    request.predicate = [NSPredicate predicateWithFormat:@"email = %@", [loginInfo objectForKey:@"LOGIN_INFO_EMAIL"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"email" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        //error
    } else if ([matches count] == 0) {
        login = [NSEntityDescription insertNewObjectForEntityForName:@"Login" inManagedObjectContext:context];
        
        login.email = (NSString *)[loginInfo objectForKey:@"LOGIN_INFO_EMAIL"];
        login.password = [loginInfo objectForKey:@"LOGIN_INFO_PASSWORD"];
         
        //********* must take user info */
        //login.user = [User userWithInfo:[loginInfo objectForKey:LOGIN_USER_INFO] inManagedObjectContext:context];
        //*********
        
        
        //update user info here
    } else {
        login = [matches lastObject];
    }
    return login;
    
}

+ (BOOL) doesEmailExit:(NSString *)email inManangedObjectContext:(NSManagedObjectContext *)context
{
    BOOL ret = NO;
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Login"];
    request.predicate = [NSPredicate predicateWithFormat:@"email = %@", email];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"email" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) {
        //error
    } else if([matches count] >= 1) {
        return YES;
    } else if ([matches count] == 0) {
        return NO;
    }
    return ret;
}

@end
