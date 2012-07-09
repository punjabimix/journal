//
//  LifeViewController.h
//  JournalDatabase
//
//  Created by Karthik Jagadeesh on 7/7/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "User.h"
#import "Media.h"
#import "Photo.h"
#import "Photo+PhotoCategory.h"
#import "CheckIn.h"
#import "Note.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface LifeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 
{
    UITableView *tableView;
}

@property (nonatomic, strong) UIManagedDocument *lifeDatabase;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) NSMutableDictionary *entries;
@property (nonatomic, strong) UITableView *tableView;

@end
