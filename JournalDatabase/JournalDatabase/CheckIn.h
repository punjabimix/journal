//
//  CheckIn.h
//  JournalDatabase
//
//  Created by karthik jagadeesh on 7/5/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface CheckIn : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * datewithtime;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) User *whoAdded;

@end
