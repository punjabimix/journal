//
//  SignUpViewController.h
//  JournalDatabase
//
//  Created by karthik jagadeesh on 6/29/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LifeString.h"
#import "User+UserCategory.h"
#import "Login+LoginCategory.h"
#import <CoreData/CoreData.h>
//#import "CoreDataUIViewController.h"

@interface SignUpViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *confirmEmail;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;
@property (strong, nonatomic) IBOutlet UITextField *dob;
@property (strong, nonatomic) IBOutlet UITextField *gender;

@property (nonatomic, strong) UIManagedDocument *lifeDatabase;
@property (nonatomic, strong) User *user;
@property (strong, nonatomic) NSFetchedResultsController *fetchedLoginResultsController;


@end
