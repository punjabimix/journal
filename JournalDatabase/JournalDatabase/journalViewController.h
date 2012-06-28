//
//  journalViewController.h
//  JournalDatabase
//
//  Created by karthik jagadeesh on 6/25/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "User.h"

@interface journalViewController : UIViewController 

@property (strong, nonatomic) IBOutlet UITextField *loginEmail;

@property (strong, nonatomic) IBOutlet UITextField *loginPassword;

@property (strong, nonatomic) UIManagedDocument *loginDatabase;

@property (strong, nonatomic) User *user;

@end
