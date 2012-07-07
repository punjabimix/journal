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

- (IBAction)captureLocation:(id)sender {
    NSLog(@"I am going to capture the location now with user %@", self.user);
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

- (IBAction)recordVideo:(id)sender 
{
    NSLog(@"Inside recordVideo");
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if([mediaTypes containsObject:(NSString *)kUTTypeMovie]){
            NSLog(@"Camera is availble");
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
            picker.allowsEditing = YES;
            [self presentModalViewController:picker animated:YES];
        } else {
            NSLog(@"Camera is not available");
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
    
    NSLog(@"Picker returned successfully.");
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeMovie]){
        NSURL *urlOfVideo = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"Video URL = %@", urlOfVideo);
        
        NSError *dataReadingError = nil;
        NSData *videoData = [NSData dataWithContentsOfURL:urlOfVideo options:NSDataReadingMapped error:&dataReadingError];
        if (videoData != nil){ 
            /* We were able to read the data */ 
            NSLog(@"Successfully loaded the data.");
        } else { 
            /* We failed to read the data. Use the dataReadingError
                  variable to determine what the error is */ 
            NSLog(@"Failed to load the data with error = %@", dataReadingError);
        }
    } else if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage]){
        NSDictionary *metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
        //NSLog(@"Image Metadata = %@", metadata);
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        
        if(image) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [self saveImage:image];
            NSLog(@"Picture Taken");
        }
        
    }
    [self dismissImagePicker];
    /*
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    if(image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self saveImage:image];
        NSLog(@"Picture Taken");
    }
    [self dismissImagePicker];*/
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
        NSLog(@"I am in Segue going to capture note with user: %@", self.user);
        [segue.destinationViewController setUser:self.user];
        [segue.destinationViewController setLifeDatabase:self.lifeDatabase];
    } else if ([segue.identifier isEqualToString:@"Capture Location"]) {
        NSLog(@"I am in Segue going to capture location with user: %@", self.user);
        [segue.destinationViewController setUser:self.user];
        [segue.destinationViewController setLifeDatabase:self.lifeDatabase];
    }
}


@end
