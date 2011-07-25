//
//  SwimmerPhotoViewController.m
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SwimmerPhotoViewController.h"

@implementation SwimmerPhotoViewController

@synthesize swimmer;
@synthesize takePictureButton;
@synthesize selectFromCameraRollButton;
@synthesize imageView;
@synthesize imagePicker;


- (void) displaySwimmerPhoto {
	if(self.swimmer == nil) {
		return;
	}
	
	NSManagedObject * photo = [swimmer valueForKey:@"swimmerPhoto"];
	if (photo == nil) {
		return;
	}
	
	UIImage * photoImage = [photo valueForKey:@"photoImage"];
	if (photoImage == nil) {
		return;
	}
	
	self.imageView.image = photoImage;
	[self.imageView sizeToFit]; 
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if(![UIImagePickerController isSourceTypeAvailable:
		 UIImagePickerControllerSourceTypeCamera]) {
		takePictureButton.hidden = YES;
		selectFromCameraRollButton.hidden = YES;
	}
	
	[self displaySwimmerPhoto];
}

/*
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}
*/
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark mark - 
#pragma mark image picking actions

- (void) takeNewPicture {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		self.imagePicker.allowsEditing = YES;
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:self.imagePicker animated:YES];
	}
	else {
        UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Error accessing camera"
							  message:@"Device does not support a camera"
							  delegate:nil
							  cancelButtonTitle:@"Drat!"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
}

- (void) getCameraRollPicture {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		self.imagePicker.allowsEditing = YES;
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		[self presentModalViewController:self.imagePicker animated:YES];
	}
	else {
        UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Error accessing camera roll"
							  message:@"Device does not support a camera roll"
							  delegate:nil
							  cancelButtonTitle:@"Drat!"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
}

- (void) selectExistingPicture {
	if ([UIImagePickerController isSourceTypeAvailable:
		 UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:self.imagePicker animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Error accessing photo library"
							  message:@"Device does not support a photo library"
							  delegate:nil
							  cancelButtonTitle:@"Drat!"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
}



#pragma mark -
#pragma mark ImagePicker Controller delegate

- (void) imagePickerController:(UIImagePickerController *)picker 
		 didFinishPickingMediaWithInfo:(NSDictionary *)editingInfo {
	UIImage * theImage;
	theImage = [editingInfo objectForKey:UIImagePickerControllerEditedImage];
	
	// try to see if the image was edited first. the camera roll will
	// always return nil for edited images
	if(theImage == nil) {
		theImage = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
	}
	if (theImage != nil) {
		// resize the image to 132 x 132 px
		CGSize size = theImage.size;
		CGFloat ratio = 0;
		if (size.width > size.height) {
			ratio = 66.0 / size.width;
		}
		else {
			ratio = 66.0 / size.height;
		}
		CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
		
		UIGraphicsBeginImageContext(rect.size);
		[theImage drawInRect:rect];
		theImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
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
		NSError *error = nil;
		if (![context save:&error]) {
			// Handle the error.
			NSLog(@"error saving managed object context: %@  %@", error, [error userInfo]);
		}

		// Update the user interface appropriately.
		self.imageView.image = theImage;
		[self.imageView sizeToFit];
	}
	[self.imagePicker dismissModalViewControllerAnimated:YES];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self.imagePicker dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.imageView = nil;
	self.takePictureButton = nil;
	self.selectFromCameraRollButton = nil;
	self.imagePicker = nil;
}


- (void)dealloc {
	[imageView release];
	[takePictureButton release];
	[selectFromCameraRollButton release];
	[imagePicker release];
    [super dealloc];
}


@end
