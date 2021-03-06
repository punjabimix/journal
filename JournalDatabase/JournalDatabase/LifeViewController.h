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
#import "Media+MediaCategory.h"
#import "Photo.h"
#import "Photo+PhotoCategory.h"
#import "CheckIn.h"
#import "Note.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <MobileCoreServices/MobileCoreServices.h>



@interface LifeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate> 
{
    UITableView *tableView;
}

@property (nonatomic, strong) UIManagedDocument *lifeDatabase;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) NSMutableDictionary *entries;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *scrollViewEntries;
@property (nonatomic, strong) NSNumber *selectedEntryNumber;

@end
