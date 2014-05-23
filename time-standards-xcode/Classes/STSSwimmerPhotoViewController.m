//
//  SwimmerPhotoViewController.m
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "STSSwimmerPhotoViewController.h"
#import "STSSwimmerDataAccess.h"



@interface STSSwimmerPhotoViewController()
@property (nonatomic, strong) NSManagedObject	* swimmer;

// private method, declare prototype (signature) here
UIImage* resizedImage(UIImage *inImage, CGRect thumbRect);
@end





@implementation STSSwimmerPhotoViewController

#pragma mark - view lifecycle

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.swimmer = [[STSSwimmerDataAccess sharedDataAccess] currentSwimmer];
	if(![UIImagePickerController isSourceTypeAvailable:
		 UIImagePickerControllerSourceTypeCamera]) {
		_takePictureButton.hidden = YES;
		_selectFromCameraRollButton.hidden = YES;
	}
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
	if(_swimmer == nil) {
		return;
	}
	
	NSManagedObject * photo = [_swimmer valueForKey:@"swimmerPhoto"];
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

- (IBAction) takeNewPicture {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
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

- (IBAction) getCameraRollPicture {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
		[self showImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
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

- (IBAction) selectExistingPicture {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self showImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
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

- (IBAction) replaceSwimmerPhotoWith: (UIImage *) theImage  {
	NSManagedObjectContext * context = [_swimmer managedObjectContext];
	
	// if the swimmer already has a photo, delete it
	NSManagedObject * oldPhoto = [_swimmer valueForKey:@"swimmerPhoto"];
	if (oldPhoto != nil) {
		[context deleteObject:oldPhoto];
	}
	
	// Create a new photo object and set the image.
	NSManagedObject * photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" 
															inManagedObjectContext:context];
	[photo setValue:theImage forKey:@"photoImage"];
	[_swimmer setValue:photo forKey:@"swimmerPhoto"];
	
	// Commit the change.
    [[STSSwimmerDataAccess sharedDataAccess] saveContext];
    
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
		CGRect rect = CGRectMake(0.0, 0.0, 264.0, 264.0);
		theImage = resizedImage(theImage, rect);
        
        // important! when the image picker finishes picking media, the app may have received
        // memory warnings and therefore the swimmer ManagedObject will contain an invalid reference 
        // (all the Core data classes have been set to nil by the app delegate).
        // therefore, need to use the remembered swimmer name and get a fresh reference to the
        // swimmer who will own this photo
        // when we return from picking an image, 
        self.swimmer = [[STSSwimmerDataAccess sharedDataAccess] currentSwimmer];
		[self replaceSwimmerPhotoWith: theImage];
	}
    [picker dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissViewControllerAnimated:YES completion:^{
        //
    }];
}


#pragma mark - Segues.

/**
 for unknown reason, using a segue inside the storyboard to show the image
 picker controller just shows a black screen. Instead, manually perform a modal transition.
 */
- (void) showImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType) imagePickerSourceType {
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    [imagePickerController setAllowsEditing:YES];
    [imagePickerController setSourceType:imagePickerSourceType];
    [imagePickerController setDelegate:self];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}



@end
