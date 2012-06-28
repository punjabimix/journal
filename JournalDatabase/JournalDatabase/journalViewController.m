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
@synthesize loginDatabase = _loginDatabase;
@synthesize user= _user;


/*
-(void)setupFetchedResultsController
{
    
}

- (void)useDocument
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.loginDatabase.fileURL path]]) {
        [self.loginDatabase saveToURL:self.loginDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
            [self fetchFlickerDataIntoDocument:self.photoDatabase];
        }];
    } else if (self.loginDatabase.documentState == UIDocumentStateClosed) {
        [self.loginDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.loginDatabase.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController];
    }
}

- (void)setLoginDatabase:(UIManagedDocument *)loginDatabase
{
    if(_loginDatabase != loginDatabase) {
        _loginDatabase = loginDatabase;
        [self useDocument];
    }
}

*/

- (IBAction)signInPressed:(id)sender

{
    NSString *mylogin = self.loginEmail.text;
    NSString *pass = self.loginPassword.text;

    
    
    
    //[self.loginEmail text]
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
    User *user = nil;//[[User alloc] init];
    user.id = [[NSNumber alloc] initWithInt:1];
    self.user = user;
    NSLog(@"I'm in the Segue");
    if([segue.identifier isEqualToString:@"Show Journal"]) {
        [segue.destinationViewController setUser:self.user];
    }
    
}

/*
- (IBAction)signInPressed
{
    //NSLog(@"login %@",_loginEmail);
    //NSLog(@"Password: %@",_loginPassword);
}
 */
@end
