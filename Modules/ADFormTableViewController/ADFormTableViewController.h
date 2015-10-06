//
//  CTFormTableViewController.h
//  ChicTypes
//
//  Created by Pierre Felgines on 27/04/2015.
//
//

#import "ADTableViewController.h"

@class ADFormTextFieldTableViewCell;

@interface ADFormTableViewController : ADTableViewController <UITextFieldDelegate>

/*
 * Provides number of cells in the form
 */
- (NSInteger)numberOfFormCells;

/*
 * Method use to customize each cell. All setup is done in one place
 */
- (void)configureCell:(ADFormTextFieldTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;

/*
 * Action when form is validated
 */
- (void)formAction:(id)sender;

/*
 * Called when value changes for textfield at indexPath (i.e. editing)
 */
- (void)valueChangedForTextField:(UITextField *)textField atIndexPath:(NSIndexPath *)indexPath;

/*
 * Retrieve text value in textfield at row
 */
- (NSString *)stringValueForRow:(NSInteger)row;

@end


@interface ADFormTableViewController (Picker)

/*
 * Number of components in picker for indexPath
 */
- (NSInteger)numberOfComponentsForIndexPath:(NSIndexPath *)indexPath;

/*
 * Array of strings representing component at indexPath
 */
- (NSArray *)optionsForComponent:(NSInteger)component indexPath:(NSIndexPath *)indexPath;

/*
 * Associate a string to an index for each component
 */
- (NSString *)stringFromSelectedIndexes:(NSArray *)indexes indexPath:(NSIndexPath *)indexPath;

/*
 * Associate an index to a string for each component
 */
- (NSArray *)selectedIndexesFromString:(NSString *)string indexPath:(NSIndexPath *)indexPath;

@end