//
//  ADTargetSettings.m
//  FormDemo
//
//  Created by Patrick Nollet on 19/01/2015.
//
//

#import "ADTargetSettings.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface ADTargetSettings ()
- (instancetype)_initWithDictionary:(NSDictionary *)dictionary;
- (void)_extractSettingsFromDictionary:(NSDictionary *)dictionary;
@end

@implementation ADTargetSettings

static ADTargetSettings * sSettings;

+ (instancetype)sharedSettings {
    if (sSettings == nil) {
        NSString * path = [NSBundle.mainBundle pathForResource:@"Info" ofType:@"plist"];
        NSDictionary * dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        sSettings = [[self alloc] _initWithDictionary:dictionary];
    }
    return sSettings;
}

- (void)setLogLevel:(NSNumber *)logLevel {
    NSArray * logLevels = @[@(DDLogLevelOff),
                            @(DDLogLevelError),
                            @(DDLogLevelWarning),
                            @(DDLogLevelInfo),
                            @(DDLogLevelDebug),
                            @(DDLogLevelVerbose),
                            @(DDLogLevelAll)
                            ];
    if (logLevel >= 0 && logLevel.integerValue < logLevels.count) {
        _logLevel = [logLevels[logLevel.integerValue] intValue];
    } else {
        _logLevel = DDLogLevelAll;
        NSLog(@"Unknown value %@ for log Level! Value range: [0..6]", logLevel);
    }

}

#pragma mark - Private

- (instancetype)_initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        [self _extractSettingsFromDictionary:dictionary];
    }
    return self;
}

- (void)_extractSettingsFromDictionary:(NSDictionary *)dictionary {
    for (NSString * key in dictionary.allKeys) {
        NSString * capitalizedKey = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] capitalizedString]];
        // ignore empty strings
        if ([self respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"set%@:", capitalizedKey])]
            && (![dictionary[key] isKindOfClass:NSString.class] || ([dictionary[key] isKindOfClass:NSString.class] && [dictionary[key] length] > 0))) {
            id value = dictionary[key];
            [self setValue:value forKey:key];
        } else if ([dictionary[key] isKindOfClass:NSDictionary.class]) {
            [self _extractSettingsFromDictionary:dictionary[key]];
        } else {
            DDLogVerbose(@"Did not set value: %@ for key: %@", dictionary[key], key);
        }
    }
}


@end
