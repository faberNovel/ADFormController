//
//  ADFormPickerDataSource.h
//  FormDemo
//
//  Created by Pierre Felgines on 15/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "ADFormPickerDataSource.h"

@interface ADSimpleFormPickerDataSource : NSObject <ADFormPickerDataSource>

- (instancetype)initWithOptions:(NSArray<NSString *> *)options;

@end
