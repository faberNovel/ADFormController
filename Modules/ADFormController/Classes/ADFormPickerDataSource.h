//
//  ADFormPickerDataSource.h
//  FormDemo
//
//  Created by Pierre Felgines on 15/10/2015.
//
//

#import <Foundation/Foundation.h>

@protocol ADFormPickerDataSource <NSObject>
- (NSInteger)numberOfComponents;
- (nonnull NSArray *)optionsForComponent:(NSInteger)component;
- (nonnull NSString *)stringFromSelectedIndexes:(nonnull NSArray *)indexes;
- (nonnull NSArray *)selectedIndexesFromString:(nonnull NSString *)string;
@end
