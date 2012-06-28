//
//  HomePageTableViewController.h
//  JournalDatabase
//
//  Created by karthik jagadeesh on 6/27/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "User.h"
#import "Photo.h"

@interface HomePageTableViewController : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *photoDatabase;
@property (nonatomic, strong) User *user;

@end
