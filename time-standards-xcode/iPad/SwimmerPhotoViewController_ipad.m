//
//  SwimmerPhotoViewController_ipad.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SwimmerPhotoViewController_ipad.h"
#import "SwimmingTimeStandardsAppDelegate.h"

@implementation SwimmerPhotoViewController_ipad

#pragma mark - view lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;

}

#pragma mark mark - image picking actions

- (void) takeNewPicture {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		UIPopoverController * popover = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker];
        [popover presentPopoverFromRect:self.view.bounds
                                 inView:self.view 
               permittedArrowDirections:UIPopoverArrowDirectionAny
                               animated:YES];
	}
	else {
		NSLog(@"Error accessing camera");
        UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Error accessing camera"
							  message:@"Device does not support a camera"
							  delegate:nil
							  cancelButtonTitle:@"Acknowledge!"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
}

- (void) getCameraRollPicture {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        UIPopoverController * popover = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker];
        [popover presentPopoverFromRect:self.view.bounds
                                 inView:self.view 
               permittedArrowDirections:UIPopoverArrowDirectionAny
                               animated:YES];
	}
	else {
		NSLog(@"Error accessing camera roll");
        UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Error accessing camera roll"
							  message:@"Device does not support a camera roll"
							  delegate:nil
							  cancelButtonTitle:@"acknowledge"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
}

- (void) selectExistingPicture {
	if ([UIImagePickerController isSourceTypeAvailable:
		 UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIPopoverController * popover = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker];
        [popover presentPopoverFromRect:self.view.bounds
                                 inView:self.view 
               permittedArrowDirections:UIPopoverArrowDirectionAny
                               animated:YES];
    }
    else {
		NSLog(@"Error accessing photo library");
        UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Error accessing photo library"
							  message:@"Device does not support a photo library"
							  delegate:nil
							  cancelButtonTitle:@"acknowledge"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
}

- (void) replaceSwimmerPhotoWith: (UIImage *) theImage  {
	NSManagedObjectContext * context = [swimmer managedObjectContext];
	
	// if the swimmer already has a photo, delete it
	NSManagedObject * oldPhoto = [swimmer valueForKey:@"swimmerPhoto"];
	if (oldPhoto != nil) {
		[context deleteObject:oldPhoto];
	}
	
	// Create a new photo object and set the image.
	NSManagedObject * photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" 
															inManagedObjectContext:context];
	[photo setValue:theImage forKey:@"photoImage"];
	[swimmer setValue:photo forKey:@"swimmerPhoto"];
	
	// Commit the change.
	[appDelegate saveContext];
	
	// Update the user interface appropriately.
	self.imageView.image = theImage;
}

- (IBAction) deletePictureButton {
	UIImage * image = [UIImage imageNamed:STSImageThumnailName];
	[self replaceSwimmerPhotoWith: image];
}


@end
