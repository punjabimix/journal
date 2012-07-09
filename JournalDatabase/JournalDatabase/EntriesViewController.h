//
//  EntriesViewController.h
//  JournalDatabase
//
//  Created by karthik jagadeesh on 7/8/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Media.h"
#import "CheckIn.h"
#import "Note.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface EntriesViewController : UIViewController 
@property (nonatomic, strong) UIManagedDocument *lifeDatabase;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSMutableArray *scrollViewEntries;
@property (nonatomic, strong) NSNumber *selectedEntryNumber;
@end
