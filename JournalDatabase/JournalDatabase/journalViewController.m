//
//  journalViewController.m
//  JournalDatabase
//
//  Created by karthik jagadeesh on 6/25/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import "journalViewController.h"
#import "Login+LoginCategory.h"

@implementation journalViewController
@synthesize loginEmail = _loginEmail;
@synthesize loginPassword = _loginPassword;
@synthesize lifeDatabase = _lifeDatabase;
@synthesize user= _user;

- (IBAction)signInPressed:(id)sender

{
    NSLog(@"login %@",self.loginEmail.text);
    NSLog(@"Password: %@",self.loginPassword.text);
    
    // [self performSegueWithIdentifier:@"Show Journal" sender:self];
    /*
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: nil];
    
    NSDictionary *loginInfo = [NSDictionary dictionaryWithObjectsAndKeys: mylogin, @"LOGIN_EMAIL", pass, @"LOGIN_PASSWORD", userInfo, @"USER_INFO", nil];
    
    
    if (!self.loginDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Login Database"];
        self.loginDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    */
    
   // [Login loginWithInfo:loginInfo inManagedObjectContext:context]; 

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    User *user = nil;
    user.id = [[NSNumber alloc] initWithInt:1];
    self.user = user;
    NSLog(@"I'm in the Segue");
    
    if (!self.lifeDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Photo Database"];
        self.lifeDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    
    if([segue.identifier isEqualToString:@"Show Journal"]) {
        [segue.destinationViewController setUser:self.user];
        [segue.destinationViewController setLifeDatabase:self.lifeDatabase];
    }
    else if([segue.identifier isEqualToString:@"Show SignUp"]) {
        [segue.destinationViewController setLifeDatabase:self.lifeDatabase];
        //NoOpp
    }
    
}
@end
