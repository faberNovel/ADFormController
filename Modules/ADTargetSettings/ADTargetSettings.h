//
//  ADTargetSettings.h
//  FormDemo
//
//  Created by Patrick Nollet on 19/01/2015.
//
//

#import <ADDynamicLogLevel/ADDynamicLogLevel.h>

@interface ADTargetSettings : NSObject
@property (nonatomic, strong, readonly) NSString * hockeyAppId;
@property (nonatomic, readonly) BOOL useWatchdog;
@property (nonatomic, readonly) BOOL useFileLogger;
@property (nonatomic, readonly) NSString * applidium_blue1;
@property (nonatomic, readonly) NSString * applidium_blue2;
@property (nonatomic, readonly) NSString * applidium_blue3;
@property (nonatomic, readonly) NSString * applidium_blue4;

@property (nonatomic, readonly) DDLogLevel logLevel; // as an exception, this property is readonly, because we want the setter's argument to have another type
// Add every property listed in the target settings info plist files
+ (instancetype)sharedSettings;
@end
