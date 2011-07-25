#import <Foundation/Foundation.h>
#import "HomeScreenValues.h"
#import "Swimmer.h"
#import "PickerValues.h"
#define kFileName @"homeScreenValues.arch"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    HomeScreenValues * homeScreenValues = [[HomeScreenValues alloc] init];
	Swimmer *swimmer = [[Swimmer alloc] init];
	PickerValues * pickerValues = [[PickerValues alloc] init];
	
	homeScreenValues.swimmer = swimmer;
	[swimmer release];
	homeScreenValues.pickerValues = pickerValues;
	[pickerValues release];
	
	homeScreenValues.swimmer.swimmerName = @"Marley";
	homeScreenValues.swimmer.swimmerGender = @"female";
	homeScreenValues.swimmer.swimmerAgeGroup = @"11-12";
	
	homeScreenValues.pickerValues.pickerStrokeName = @"Free";
	homeScreenValues.pickerValues.pickerDistance = @"100";
	homeScreenValues.pickerValues.pickerCourse = @"SCM";
	
	homeScreenValues.standard = @"PNS Times";
	
	NSLog(@"%@", pickerValues);
	
	if([NSKeyedArchiver archiveRootObject:homeScreenValues toFile:kFileName] == NO) {
		NSLog(@"save to file failed");
	}
	else {
		NSLog(@"save to file succeeded");
	}
	
	NSMutableArray * mutableArray = [NSMutableArray arrayWithCapacity:5];
	Swimmer * sw1 = [[Swimmer alloc] init];
	Swimmer * sw2 = [[Swimmer alloc] init];
	Swimmer * sw3 = [[Swimmer alloc] init];
	
	sw1.swimmerName = @"Marley";
	sw1.swimmerGender = @"female";
	sw1.swimmerAgeGroup = @"11-12";
	
	sw2.swimmerName = @"Noah";
	sw2.swimmerGender = @"male";
	sw2.swimmerAgeGroup = @"13-14";
	
	sw3.swimmerName = @"Max";
	sw3.swimmerGender = @"male";
	sw3.swimmerAgeGroup = @"10 & Under";
	
	[mutableArray addObject:sw1];
	[mutableArray addObject:sw2];
	[mutableArray addObject:sw3];
	
	if([NSKeyedArchiver archiveRootObject:mutableArray toFile:@"listOfSwimmers.arch"] == NO) {
		NSLog(@"save to file failed");
	}
	else {
		NSLog(@"save to file succeeded");
	}
	
	HomeScreenValues * hs2 = nil;
	hs2 = [NSKeyedUnarchiver unarchiveObjectWithFile:kFileName];
	NSLog(@"swimmer: %@, standard: %@", hs2.swimmer.swimmerName, hs2.standard);
		   
	
	[homeScreenValues release];
    [pool drain];
    return 0;
}
