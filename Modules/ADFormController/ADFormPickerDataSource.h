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
- (NSArray *)optionsForComponent:(NSInteger)component;
- (NSString *)stringFromSelectedIndexes:(NSArray *)indexes;
- (NSArray *)selectedIndexesFromString:(NSString *)string;
@end
