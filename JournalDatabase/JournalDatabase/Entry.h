//
//  Entry.h
//  JournalDatabase
//
//  Created by karthik jagadeesh on 7/4/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entry : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * datewithtime;

@end
