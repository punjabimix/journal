//
//  SignUpViewController.m
//  JournalDatabase
//
//  Created by karthik jagadeesh on 6/29/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import "SignUpViewController.h"

@implementation SignUpViewController
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize email = _email;
@synthesize confirmEmail = _confirmEmail;
@synthesize password = _password;
@synthesize confirmPassword = _confirmPassword;
@synthesize dob = _dob;
@synthesize gender = _gender;
@synthesize lifeDatabase = _lifeDatabase;
@synthesize fetchedLoginResultsController = _fetchedLoginResultsController;
@synthesize user = _user;

/*
- (void)viewDidUnload {
    [self setFirstName:nil];
    [self setLastName:nil];
    [self setEmail:nil];
    [self setPassword:nil];
    [self setConfirmEmail:nil];
    [self setConfirmPassword:nil];
    [self setDob:nil];
    [self setGender:nil];
    [super viewDidUnload];
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void) hideKeyboard {
    [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
    [self.email resignFirstResponder];
    [self.confirmEmail resignFirstResponder];
    [self.password resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
    [self.dob resignFirstResponder];
    [self.gender resignFirstResponder];
}


-(void)setupLoginFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Login"];
    request.predicate = [NSPredicate predicateWithFormat:@"email = %@", self.email];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"email" ascending:NO]];
    self.fetchedLoginResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.lifeDatabase.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)useDocument
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.lifeDatabase.fileURL path]]) {
        [self.lifeDatabase saveToURL:self.lifeDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupLoginFetchedResultsController];
            //[self fetchFlickerDataIntoDocument:self.photoDatabase];
        }];
    } else if (self.lifeDatabase.documentState == UIDocumentStateClosed) {
        [self.lifeDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupLoginFetchedResultsController];
        }];
    } else if (self.lifeDatabase.documentState == UIDocumentStateNormal) {
        [self setupLoginFetchedResultsController];
    }
}

- (void)setLifeDatabase:(UIManagedDocument *)lifeDatabase
{
       NSLog(@"I'm in setlifeDatabase- SIgnUpView");
    if(_lifeDatabase != lifeDatabase) {
        _lifeDatabase = lifeDatabase;
        [self useDocument];
    }
}

- (IBAction)newSignUp:(id)sender 
{
     //********************** must check that email is unique
    
    BOOL emailExit = [Login doesEmailExit:self.email.text inManangedObjectContext:self.lifeDatabase.managedObjectContext];
    
    if(emailExit == YES) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Email already in use"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        //alert
        NSLog(@"User already exists.");
    } else {
        
        NSDictionary *loginInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.email.text, @"LOGIN_INFO_EMAIL", self.password.text, @"LOGIN_INFO_PASSWORD", nil];
        Login *login = [Login loginWithInfo:loginInfo inManagedObjectContext:self.lifeDatabase.managedObjectContext];
        
        //****************calculate age
        //figure out how to get a date fro DOB, string won't work
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.firstName.text, @"USER_INFO_FIRSTNAME", self.lastName.text, @"USER_INFO_LASTNAME", self.gender.text, @"USER_INFO_GENDER", login, @"USER_INFO_LOGIN", nil];
        User *user = [User userWithInfo:userInfo inManagedObjectContext:self.lifeDatabase.managedObjectContext];
        login.user = user;
        
    if([LifeString stringIsEmpty:self.firstName.text]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Enter First Name!"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        //******************* make field red or alert
        
    }
    else if(![self.email.text isEqualToString:self.confirmEmail.text] || ([LifeString stringIsEmpty:self.email.text]) || ([LifeString stringIsEmpty:self.confirmEmail.text])) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Emails do not match!"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        //throw error , make red
    } else if (![self.password.text isEqualToString:self.confirmPassword.text] || ([LifeString stringIsEmpty:self.password.text]) || ([LifeString stringIsEmpty:self.confirmPassword.text])) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Passwords do not match!"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        //throw error, make red
    } else {
        NSDictionary *loginInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.email.text, @"LOGIN_INFO_EMAIL", self.password.text, @"LOGIN_INFO_PASSWORD", nil];
        Login *login = [Login loginWithInfo:loginInfo inManagedObjectContext:self.lifeDatabase.managedObjectContext];
        
        //****************calculate age
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.firstName.text, @"USER_INFO_FIRSTNAME", self.lastName.text, @"USER_INFO_LASTNAME", self.dob.text, @"USER_INFO_DOB", self.gender.text, @"USER_INFO_GENDER", login, @"USER_INFO_LOGIN", nil];
        self.user = [User userWithInfo:userInfo inManagedObjectContext:self.lifeDatabase.managedObjectContext];
        login.user = self.user;
        [self performSegueWithIdentifier:@"Show Journal" sender:self];
       }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"I'm in the Segue");
    if([segue.identifier isEqualToString:@"Show Homepage"]) {
        [segue.destinationViewController setUser:self.user];
        [segue.destinationViewController setLifeDatabase:self.lifeDatabase];
    }
    
}


- (void)viewDidLoad
{
    [self.firstName setDelegate:self];
    [self textFieldShouldReturn:self.firstName];
    [self.lastName setDelegate:self];
    [self textFieldShouldReturn:self.lastName];
    [self.email setDelegate:self];
    [self textFieldShouldReturn:self.email];
    [self.confirmEmail setDelegate:self];
    [self textFieldShouldReturn:self.confirmEmail];
    [self.password setDelegate:self];
    [self textFieldShouldReturn:self.password];
    [self.confirmPassword setDelegate:self];
    [self textFieldShouldReturn:self.confirmPassword];
    [self.dob setDelegate:self];
    [self textFieldShouldReturn:self.dob];
    [self.gender setDelegate:self];
    [self textFieldShouldReturn:self.gender];
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

@end
