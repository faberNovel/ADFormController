//
//  CTFormTableViewController.h
//  ChicTypes
//
//  Created by Pierre Felgines on 27/04/2015.
//
//

#import "ADTableViewController.h"

@class CTFormTextFieldTableViewCell;

@interface CTFormTableViewController : ADTableViewController <UITextFieldDelegate>

- (NSInteger)numberOfFormCells;
- (void)configureCell:(CTFormTextFieldTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (void)formAction:(id)sender;
- (void)valueChangedForTextField:(UITextField *)textField atIndexPath:(NSIndexPath *)indexPath;
- (NSString *)stringValueForRow:(NSInteger)row;

- (NSInteger)numberOfComponentsForIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)optionsForComponent:(NSInteger)component indexPath:(NSIndexPath *)indexPath;
- (NSString *)stringFromSelectedIndexes:(NSArray *)indexes indexPath:(NSIndexPath *)indexPath;
- (NSArray *)selectedIndexesFromString:(NSString *)string indexPath:(NSIndexPath *)indexPath;

@end
