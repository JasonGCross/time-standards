//
//  SwimmerPhotoViewController.m
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SwimmerPhotoViewController.h"
#import "SwimmingTimeStandardsAppDelegate.h"



@interface SwimmerPhotoViewController(STSSwimmerPhotoViewControllerPrivate)
UIImage* resizedImage(UIImage *inImage, CGRect thumbRect);
- (void) displaySwimmerPhoto;
@end



@implementation SwimmerPhotoViewController

@synthesize takePictureButton;
@synthesize selectFromCameraRollButton;
@synthesize imageView;
@synthesize imagePicker;


#pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (SwimmingTimeStandardsAppDelegate *)[[UIApplication sharedApplication] 
													   delegate];
    swimmer = [appDelegate currentSwimmer];
	if(![UIImagePickerController isSourceTypeAvailable:
		 UIImagePickerControllerSourceTypeCamera]) {
		takePictureButton.hidden = YES;
		selectFromCameraRollButton.hidden = YES;
	}
	self.imagePicker.allowsEditing = YES;
	[self displaySwimmerPhoto];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - private methods

- (void) displaySwimmerPhoto {
	if(swimmer == nil) {
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
}

//	==============================================================
//	resizedImage
//	==============================================================
// Return a scaled down copy of the image.  

UIImage* resizedImage(UIImage *inImage, CGRect thumbRect)
{
	CGImageRef			imageRef = [inImage CGImage];
	CGImageAlphaInfo	alphaInfo = CGImageGetAlphaInfo(imageRef);
	
	// There's a wierdness with kCGImageAlphaNone and CGBitmapContextCreate
	// see Supported Pixel Formats in the Quartz 2D Programming Guide
	// Creating a Bitmap Graphics Context section
	// only RGB 8 bit images with alpha of kCGImageAlphaNoneSkipFirst, kCGImageAlphaNoneSkipLast, kCGImageAlphaPremultipliedFirst,
	// and kCGImageAlphaPremultipliedLast, with a few other oddball image kinds are supported
	// The images on input here are likely to be png or jpeg files
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
	
	// Build a bitmap context that's the size of the thumbRect
	CGContextRef bitmap = CGBitmapContextCreate(
												NULL,
												thumbRect.size.width,		// width
												thumbRect.size.height,		// height
												CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8
												4 * thumbRect.size.width,	// rowbytes
												CGImageGetColorSpace(imageRef),
												alphaInfo
												);
	
	// Draw into the context, this scales the image
	CGContextDrawImage(bitmap, thumbRect, imageRef);
	
	// Get an image from the context and a UIImage
	CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
	UIImage*	result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);	// ok if NULL
	CGImageRelease(ref);
	
	return result;
}

#pragma mark mark - image picking actions

- (void) takeNewPicture {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:self.imagePicker animated:YES];
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
    }
}

- (void) getCameraRollPicture {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		[self presentModalViewController:self.imagePicker animated:YES];
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
    }
}

- (void) selectExistingPicture {
	if ([UIImagePickerController isSourceTypeAvailable:
		 UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:self.imagePicker animated:YES];
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
    
    // let anyone interested know the photo has changed
    NSNotification * notification = [NSNotification notificationWithName:STSSwimmerPhotoChangedKey
                                                                  object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
	
	// Update the user interface appropriately.
	self.imageView.image = theImage;
}

- (IBAction) deletePictureButton {
	UIImage * image = [UIImage imageNamed:STSImageThumnailName];
	[self replaceSwimmerPhotoWith: image];
}

#pragma mark - ImagePicker Controller delegate

- (void) imagePickerController:(UIImagePickerController *)picker 
		 didFinishPickingMediaWithInfo:(NSDictionary *)editingInfo {
	UIImage * theImage = nil;
	theImage = editingInfo[UIImagePickerControllerEditedImage];
	
	// try to see if the image was edited first. the camera roll will
	// always return nil for edited images
	if(theImage == nil) {
		theImage = editingInfo[UIImagePickerControllerOriginalImage];
	}
	if (theImage != nil) {		
		CGRect rect = CGRectMake(0.0, 0.0, 300.0, 300.0);
		theImage = resizedImage(theImage, rect);
        
        // important! when the image picker finishes picking media, the app may have received
        // memory warnings and therefore the swimmer ManagedObject will contain an invalid reference 
        // (all the Core data classes have been set to nil by the app delegate).
        // therefore, need to use the remembered swimmer name and get a fresh reference to the
        // swimmer who will own this photo
        // when we return from picking an image, 
        swimmer = [appDelegate currentSwimmer];
		[self replaceSwimmerPhotoWith: theImage];
	}
	[picker dismissModalViewControllerAnimated:YES];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self.imagePicker dismissModalViewControllerAnimated:YES];
}

#pragma mark - memory management

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



@end
