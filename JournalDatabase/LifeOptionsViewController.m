//
//  LifeOptionsViewController.m
//  JournalDatabase
//
//  Created by karthik jagadeesh on 6/29/12.
//  Copyright (c) 2012 uc berkeley. All rights reserved.
//

#import "LifeOptionsViewController.h"

@interface LifeOptionsViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

@implementation LifeOptionsViewController

@synthesize user = _user;
@synthesize lifeDatabase = _lifeDatabase;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) setUser:(User *)user
{
    _user = user;
    
}

-(void) setLifeDatabase:(UIManagedDocument *)lifeDatabase
{
    _lifeDatabase = lifeDatabase;
}

- (IBAction)capturePhoto:(id)sender 
{
    
    
    NSLog(@"Inside capturePhoto");
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
     
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if([mediaTypes containsObject:(NSString *)kUTTypeImage]){
            NSLog(@"Camera is availble");
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
            picker.allowsEditing = YES;
            [self presentModalViewController:picker animated:YES];
        }
    }
}

-(void)dismissImagePicker
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)saveImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:strDate];
     NSDictionary *photoInfo = [NSDictionary dictionaryWithObjectsAndKeys: imageData, @"PHOTO_INFO_BITMAP", dateFromString, @"PHOTO_INFO_DATE", @"1stphoto", @"PHOTO_INFO_CAPTION", [NSDate date], @"PHOTO_INFO_DATEWITHTIME", self.user,@"PHOTO_INFO_WHOADDED", nil];
 
    Photo *p = [Photo photoWithInfo:photoInfo inManagedObjectContext:self.lifeDatabase.managedObjectContext];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if(image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self saveImage:image];
        NSLog(@"Picture Taken");
    }
    [self dismissImagePicker];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissImagePicker];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"I'm in the Segue");
    if([segue.identifier isEqualToString:@"Show Homepage"]) {
        [segue.destinationViewController setUser:self.user];
        [segue.destinationViewController setLifeDatabase:self.lifeDatabase];
    } else if([segue.identifier isEqualToString:@"Capture Note"]) {
        [segue.destinationViewController setUser:self.user];
        [segue.destinationViewController setLifeDatabase:self.lifeDatabase];
    }
}


@end
