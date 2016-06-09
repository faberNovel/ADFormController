//
//  ADFormPickerDataSource.m
//  FormDemo
//
//  Created by Pierre Felgines on 15/10/2015.
//
//

#import "ADSimpleFormPickerDataSource.h"

@interface ADSimpleFormPickerDataSource () {
    NSArray<NSString *> * _options;
}

@end

@implementation ADSimpleFormPickerDataSource

- (instancetype)initWithOptions:(NSArray<NSString *> *)options {
    if (self = [super init]) {
        _options = options;
    }
    return self;
}

#pragma mark - ADFormPickerDataSource

- (NSInteger)numberOfComponents {
    return 1;
}

- (NSArray *)optionsForComponent:(NSInteger)component {
    return _options;
}

- (NSString *)stringFromSelectedIndexes:(NSArray *)indexes {
    NSInteger index = [[indexes lastObject] integerValue];
    return _options[index];
}

- (NSArray *)selectedIndexesFromString:(NSString *)string {
    NSInteger index = [_options indexOfObject:string];
    return @[ @(index) ];
}

@end
