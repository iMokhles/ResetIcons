#import <flipswitch/Flipswitch.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// @interface NSUserDefaults (Tweak_Category)
// - (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
// - (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
// @end

// static NSString *nsDomainString = @"com.imokhles.reseticons";
// static NSString *nsNotificationString = @"com.imokhles.reseticons/preferences.changed";

@interface ResetIconsSwitch : NSObject <FSSwitchDataSource>
@end

#ifndef GSEVENT_H
extern void GSSendAppPreferencesChanged(CFStringRef bundleID, CFStringRef key);
#endif

#define kRISpringboard CFSTR("com.apple.springboard")
#define kRIIconStatKey CFSTR("iconState")
#define kRIIconStatKey2 CFSTR("iconState2")

@implementation ResetIconsSwitch

- (NSString *)titleForSwitchIdentifier:(NSString *)switchIdentifier {
	return @"ResetIcons";
}

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier {
	CFPreferencesAppSynchronize(kRISpringboard);
    Boolean RIDone = CFPreferencesGetAppBooleanValue(kRIIconStatKey, kRISpringboard, NULL);
    return RIDone ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier {
	if (newState == FSSwitchStateIndeterminate) {
		return;
	}
	NSString *iconStatePlist = [@"/User/Library/SpringBoard/IconState.plist" stringByExpandingTildeInPath];
    [[NSFileManager defaultManager] removeItemAtPath:iconStatePlist error:nil];
	CFPropertyListRef obj = CFPreferencesCopyAppValue(kRIIconStatKey, kRISpringboard);
	CFPropertyListRef obj2 = CFPreferencesCopyAppValue(kRIIconStatKey2, kRISpringboard);
	if (obj != nil || obj2 != nil) {
		CFPreferencesSetAppValue(kRIIconStatKey, newState ? kCFBooleanTrue : kCFBooleanFalse, kRISpringboard);
        CFPreferencesSetAppValue(kRIIconStatKey2, newState ? kCFBooleanTrue : kCFBooleanFalse, kRISpringboard);
        CFPreferencesAppSynchronize(kRISpringboard);
	}
	GSSendAppPreferencesChanged(kRISpringboard, kRIIconStatKey);
	// switch (newState) {
	// case FSSwitchStateIndeterminate:
	// 	break;
	// case FSSwitchStateOn:
	// 	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"enabled" inDomain:nsDomainString];
	// 	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)nsNotificationString, NULL, NULL, YES);
	// 	break;
	// case FSSwitchStateOff:
	// 	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"enabled" inDomain:nsDomainString];
	// 	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)nsNotificationString, NULL, NULL, YES);
	// 	break;
	// }
	// return;
    // r7 = s13 + 0x4;
    // r4 = [NSFileManager defaultManager];
    // r2 = [@"~/Library/SpringBoard/IconState.plist" stringByExpandingTildeInPath];
    // [r4 removeItemAtPath:r2 error:0x0];
    // r0 = CFPreferencesCopyAppValue(@"iconState", @"com.apple.springboard");
    // r4 = @selector(autorelease);
    // if (([r0 autorelease] != 0x0) || ([CFPreferencesCopyAppValue(@"iconState2", @"com.apple.springboard") autorelease] != 0x0)) {
    //         r4 = @"com.apple.springboard";
    //         CFPreferencesSetAppValue(@"iconState", 0x0, r4);
    //         CFPreferencesSetAppValue(@"iconState2", 0x0, r4);
    //         CFPreferencesAppSynchronize(r4);
    // }
    // GSSendAppPreferencesChanged();
    // Pop();
    // Pop();
    // Pop();
    // r0 = ADClientAddValueForScalarKey();
    // return r0;

}

@end
