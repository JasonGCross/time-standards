//
//  SwimmerPhotoViewController.h
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STSAppDelegate;

@interface STSSwimmerPhotoViewController : UIViewController <UINavigationControllerDelegate, 
UIImagePickerControllerDelegate> 
@property (nonatomic, strong) IBOutlet UIButton * takePictureButton;
@property (nonatomic, strong) IBOutlet UIButton * selectFromCameraRollButton;
@property (nonatomic, strong) IBOutlet UIImageView * imageView;

- (IBAction) takeNewPicture;
- (IBAction) getCameraRollPicture;
- (IBAction) selectExistingPicture;
- (IBAction) deletePictureButton;

@end
