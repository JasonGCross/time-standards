//
//  SwimmerPhotoViewController.h
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwimmerPhotoViewController : UIViewController <UINavigationControllerDelegate, 
UIImagePickerControllerDelegate> {
	NSManagedObject	* swimmer;
	UIImageView		* imageView;
    UIButton		* takePictureButton;
    UIButton		* selectFromCameraRollButton;
	UIImagePickerController * imagePicker;
}

@property (nonatomic, retain) NSManagedObject * swimmer;
@property (nonatomic, retain) IBOutlet UIButton * takePictureButton;
@property (nonatomic, retain) IBOutlet UIButton * selectFromCameraRollButton;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIImagePickerController * imagePicker;

- (IBAction) takeNewPicture;
- (IBAction) getCameraRollPicture;
- (IBAction) selectExistingPicture;
- (void) imagePickerController:(UIImagePickerController *)picker 
 didFinishPickingMediaWithInfo:(NSDictionary *)editingInfo;
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker;

@end
