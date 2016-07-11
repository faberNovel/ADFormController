//
//  FDExpirationDateFormPickerDataSource.m
//  FormDemo
//
//  Created by Pierre Felgines on 15/10/2015.
//
//

#import "FDExpirationDateFormPickerDataSource.h"

typedef NS_ENUM(NSUInteger, FDExpirationDateComponent) {
    FDExpirationDateComponentMonth,
    FDExpirationDateComponentYear,
    FDExpirationDateComponentCount,
};

@implementation FDExpirationDateFormPickerDataSource

#pragma mark - ADFormPickerDataSource

- (NSInteger)numberOfComponents {
    return FDExpirationDateComponentCount;
}

- (NSArray<NSString *> *)componentOptions:(NSInteger)component {
    switch (component) {
        case FDExpirationDateComponentMonth: {
            return [self _months];
        } break;
        case FDExpirationDateComponentYear: {
            return [self _years];
        } break;
    }
    return nil;
}

- (NSString *)stringFromSelectedIndexes:(NSArray *)indexes {
    NSInteger monthIndex = [indexes[FDExpirationDateComponentMonth] integerValue];
    NSInteger yearIndex = [indexes[FDExpirationDateComponentYear] integerValue];
    NSString * monthString = [NSString stringWithFormat:@"%02ld", (long)(monthIndex + 1)];
    NSString * yearString = [[self _years][yearIndex] substringFromIndex:2];
    return [NSString stringWithFormat:@"%@/%@", monthString, yearString];
}

- (NSArray *)selectedIndexesFromString:(NSString *)string {
    NSString * monthString = [string substringToIndex:2];
    NSInteger month = [monthString integerValue];
    NSInteger monthIndex = month - 1;
    NSString * yearString = [string substringFromIndex:3];
    __block NSInteger yearIndex = 0;
    [[self _years] enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        if ([obj hasSuffix:yearString]) {
            yearIndex = idx;
            *stop = YES;
        }
    }];
    return @[@(monthIndex), @(yearIndex)];
}

#pragma mark - Private

- (NSArray *)_months {
    static NSDateFormatter * sMonthSymbolDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sMonthSymbolDateFormatter = [[NSDateFormatter alloc] init];
    });
    return [sMonthSymbolDateFormatter monthSymbols];
}

- (NSArray *)_years {
    static NSArray * sYears = nil;
    static dispatch_once_t yearsOnceToken;
    dispatch_once(&yearsOnceToken, ^{
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy";

        NSString * startYearString = [dateFormatter stringFromDate:[NSDate date]];
        int startYear = (int)[startYearString integerValue];
        NSMutableArray * years = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            int year = startYear + i;
            NSString * yearString = [NSString stringWithFormat:@"%i", year];
            [years addObject:yearString];
        }

        sYears = [years copy];
    });
    return sYears;
}

@end
