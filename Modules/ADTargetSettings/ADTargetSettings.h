//
//  ADTargetSettings.h
//  FormDemo
//
//  Created by Patrick Nollet on 19/01/2015.
//
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface ADTargetSettings : NSObject
@property (nonatomic, readonly) DDLogLevel logLevel; // as an exception, this property is readonly, because we want the setter's argument to have another type
// Add every property listed in the target settings info plist files
+ (instancetype)sharedSettings;
@end
