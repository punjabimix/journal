//
//  PrintMyLocationViewController.h
//  JournalDatabase
//
//  Created by karthik jagadeesh on 7/2/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PrintMyLocationViewController : UIViewController <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *myLocationManager;
@property (nonatomic, strong) CLGeocoder *myGeocoder;

@end
