//
//  PickerValues.h
//  pList Persistence
//
//  Created by JASON CROSS on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PickerValues : NSObject {
	NSString * pickerDistance;
	NSString * pickerStrokeName;
	NSString * pickerCourse;
}

@property (nonatomic, retain) NSString * pickerDistance;
@property (nonatomic, retain) NSString * pickerStrokeName;
@property (nonatomic, retain) NSString * pickerCourse;

@end
