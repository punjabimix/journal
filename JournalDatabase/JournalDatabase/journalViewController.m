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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void) hideKeyboard {
    [self.loginPassword resignFirstResponder];
    [self.loginEmail resignFirstResponder];
}

-(void)setupFetchedResultsController 
{
    NSDictionary *loginInfo = [NSDictionary dictionaryWithObjectsAndKeys: self.loginEmail.text, @"LOGIN_INFO_EMAIL", self.loginPassword.text, @"LOGIN_INFO_PASSWORD", nil];
    /*
    BOOL userExit = [Login checkUser:loginInfo inManangedObjectContext:self.lifeDatabase.managedObjectContext];
    
    if(userExit == NO) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Wrong email or password!"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    } else {*/
    Login *login = [Login loginWithInfo:loginInfo inManagedObjectContext:self.lifeDatabase.managedObjectContext];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: @"Bob", @"USER_INFO_FIRSTNAME", @"Jones", @"USER_INFO_LASTNAME", [[NSNumber alloc] initWithInt:10], @"USER_INFO_ID", login, @"USER_INFO_LOGIN", nil];
    
    self.user = [User userWithInfo:userInfo inManagedObjectContext:self.lifeDatabase.managedObjectContext];
    
    login.user = self.user;
    
   // NSLog(@"here is the login: %@", login);
    
   // NSLog(@"here is the user: %@", self.user);
    
    [self performSegueWithIdentifier:@"Show Journal" sender:self];
   // }

}

- (void)useDocument
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.lifeDatabase.fileURL path]]) {
        NSLog(@"Creating database file");
        [self.lifeDatabase saveToURL:self.lifeDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
            //[self fetchFlickerDataIntoDocument:self.lifeDatabase];
            
        }];
    } else if (self.lifeDatabase.documentState == UIDocumentStateClosed) {
        NSLog(@"Opeing the database file");
       // NSLog(@"at %@", self.lifeDatabase.fileURL);
        [self.lifeDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
            // pass 
        }];
    } else if (self.lifeDatabase.documentState == UIDocumentStateNormal) {
        NSLog(@"database file is open");
        [self setupFetchedResultsController];
        // pass
    }
}

- (IBAction)signInPressed:(id)sender

{
   // NSLog(@"login %@",self.loginEmail.text);
   // NSLog(@"Password: %@",self.loginPassword.text);

    
    if (!self.lifeDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Photo Database"];
        self.lifeDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    [self useDocument];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   // NSLog(@"Im in the segue from start page");
    if([segue.identifier isEqualToString:@"Show Journal"]) {
        [segue.destinationViewController setUser:self.user];
        [segue.destinationViewController setLifeDatabase:self.lifeDatabase];
    }
    else if([segue.identifier isEqualToString:@"Show SignUp"]) {
        [segue.destinationViewController setLifeDatabase:self.lifeDatabase];
        //NoOpp
    }
    
}

- (void)viewDidLoad
{
    [self.loginEmail setDelegate:self];
    [self textFieldShouldReturn:self.loginEmail];
    [self.loginPassword setDelegate:self];
    [self textFieldShouldReturn:self.loginPassword];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

@end
