//
//  LifeOptionsViewController.h
//  JournalDatabase
//
//  Created by karthik jagadeesh on 6/29/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface LifeOptionsViewController : UIViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) UIManagedDocument *lifeDatabase;

@end
