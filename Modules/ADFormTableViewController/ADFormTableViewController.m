//
//  CTFormTableViewController.m
//  ChicTypes
//
//  Created by Pierre Felgines on 27/04/2015.
//
//

#import "ADFormTableViewController.h"
#import "ADFormTextFieldTableViewCell.h"
#import "UIView+Responder.h"

typedef NS_ENUM(NSUInteger, CTAccessoryViewDirection) {
    CTAccessoryViewDirectionPrevious,
    CTAccessoryViewDirectionNext
};

@interface ADFormTableViewController () <CTFormTextFieldTableViewCellDelegate> {
    NSMutableDictionary * _cells;
    UIView * _textFieldAccessoryView;
    UIBarButtonItem * _nextBarButtonItem;
    UIBarButtonItem * _previousBarButtonItem;
}
- (ADFormTextFieldTableViewCell *)_formCellForIndexPath:(NSIndexPath *)indexPath;
- (ADFormTextFieldTableViewCell *)_cellForTextField:(UITextField *)textField;
- (NSIndexPath *)_indexPathForTextField:(UITextField *)textField;
- (void)_textFieldValueChanged:(UITextField *)textField;
@end

@implementation ADFormTableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _cells = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    if ([self.class tableViewStyle] == UITableViewStylePlain) {
        self.tableView.tableFooterView = [UIView new];
    }
}

#pragma mark - Methods

- (void)configureCell:(ADFormTextFieldTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    cell.textField.textColor = [UIColor blackColor];
    cell.textField.tintColor = [UIColor blackColor];
    cell.textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    cell.leftLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];

    cell.textField.returnKeyType = (indexPath.row == [self numberOfFormCells] - 1) ? UIReturnKeyGo : UIReturnKeyNext;
    [cell.textField addTarget:self action:@selector(_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    cell.textField.inputAccessoryView = [self _textFieldAccessoryView];
    cell.textField.delegate = self;
    cell.delegate = self;
}

- (NSInteger)numberOfFormCells {
    return 0;
}

- (void)formAction:(id)sender {
    [self.tableView endEditing:YES];
}

- (NSString *)stringValueForIndexPath:(NSIndexPath *)indexPath {
    ADFormTextFieldTableViewCell * cell = (ADFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell.textField.text;
    }
    return nil;
}

- (NSDate *)dateValueForIndexPath:(NSIndexPath *)indexPath {
    ADFormTextFieldTableViewCell * cell = (ADFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell && cell.cellType == ADFormTextCellTypeDate) {
        return [[ADFormTextFieldTableViewCell dateFormatter] dateFromString:cell.textField.text];
    }
    return nil;
}

- (void)valueChangedForTextField:(UITextField *)textField atIndexPath:(NSIndexPath *)indexPath {
    // to override
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfFormCells];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADFormTextFieldTableViewCell * cell = [self _formCellForIndexPath:indexPath];
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSIndexPath * indexPath = [self _indexPathForTextField:textField];
    if ([self _canMoveToDirection:CTAccessoryViewDirectionNext fromIndexPath:indexPath]) {
        [self _moveToDirection:CTAccessoryViewDirectionNext fromIndexPath:indexPath];
        return NO;
    }
    [self formAction:nil];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self _updateInputAccessoryView];
    ADFormTextFieldTableViewCell * cell = [self _cellForTextField:textField];
    [cell startEditing];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    ADFormTextFieldTableViewCell * cell = [self _cellForTextField:textField];
    return [cell shouldChangeCharactersInRange:range replacementString:string];
}

#pragma mark - CTFormTextFieldTableViewCellDelegate

- (NSInteger)numberOfComponentsForCell:(ADFormTextFieldTableViewCell *)cell {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    return [self numberOfComponentsForIndexPath:indexPath];
}

- (NSArray *)optionsForComponent:(NSInteger)component cell:(ADFormTextFieldTableViewCell *)cell {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    return [self optionsForComponent:component indexPath:indexPath];
}

- (NSString *)stringFromSelectedIndexes:(NSArray *)indexes cell:(ADFormTextFieldTableViewCell *)cell {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    return [self stringFromSelectedIndexes:indexes indexPath:indexPath];
}

- (NSArray *)selectedIndexesFromString:(NSString *)string cell:(ADFormTextFieldTableViewCell *)cell {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    return [self selectedIndexesFromString:string indexPath:indexPath];
}

#pragma mark - Private

- (ADFormTextFieldTableViewCell *)_formCellForIndexPath:(NSIndexPath *)indexPath {
    if (!_cells[@(indexPath.row)]) {
        _cells[@(indexPath.row)] = [[ADFormTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    return _cells[@(indexPath.row)];
}

- (ADFormTextFieldTableViewCell *)_cellForTextField:(UITextField *)textField {
    UIView * view = textField;
    while (view != nil) {
        if ([view isKindOfClass:ADFormTextFieldTableViewCell.class]) {
            return (ADFormTextFieldTableViewCell *)view;
        }
        view = view.superview;
    }
    return nil;
}

- (ADFormTextFieldTableViewCell *)_cellFromFirstResponder {
    UIView * firstResponderView = [self.tableView ad_findFirstResponder];
    if ([firstResponderView isKindOfClass:UITextField.class]) {
        return [self _cellForTextField:(UITextField *)firstResponderView];
    }
    return nil;
}

- (NSIndexPath *)_indexPathForTextField:(UITextField *)textField {
    ADFormTextFieldTableViewCell * cell = [self _cellForTextField:textField];
    return [self.tableView indexPathForCell:cell];
}

- (NSIndexPath *)_indexPathForFirstResponder {
    UIView * firstResponder = [self.tableView ad_findFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        return [self _indexPathForTextField:(UITextField *)firstResponder];
    }
    return nil;
}

- (void)_textFieldValueChanged:(UITextField *)textField {
    NSIndexPath * indexPath = [self _indexPathForTextField:textField];
    [self valueChangedForTextField:textField atIndexPath:indexPath];
}

- (UIView *)_textFieldAccessoryView {
    if (!_textFieldAccessoryView) {
        UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44.0f)];
        toolbar.tintColor = [UIColor blackColor];
        _nextBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"FDNextIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(_next:)];
        _nextBarButtonItem.width = 44.0f;
        _previousBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"FDPreviousIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(_previous:)];
        _previousBarButtonItem.width = 44.0f;
        UIBarButtonItem * flexibleBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        toolbar.items = @[flexibleBarButtonItem, _previousBarButtonItem, _nextBarButtonItem];
        _textFieldAccessoryView = toolbar;
    }
    return _textFieldAccessoryView;
}

- (void)_next:(id)sender {
    [self _moveToDirection:CTAccessoryViewDirectionNext];
}

- (void)_previous:(id)sender {
    [self _moveToDirection:CTAccessoryViewDirectionPrevious];
}

- (void)_moveToDirection:(CTAccessoryViewDirection)direction {
    NSIndexPath * currentIndexPath = [self _indexPathForFirstResponder];
    [self _moveToDirection:direction fromIndexPath:currentIndexPath];
}

- (void)_moveToDirection:(CTAccessoryViewDirection)direction fromIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath * nextIndexPath = [self _indexPathForDirection:direction andBaseIndexPath:indexPath];
    if (nextIndexPath) {
        ADFormTextFieldTableViewCell * nextCell = (ADFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:nextIndexPath];
        [nextCell.textField becomeFirstResponder];
    }
}

- (NSIndexPath *)_indexPathForDirection:(CTAccessoryViewDirection)direction andBaseIndexPath:(NSIndexPath *)baseIndexPath {
    if (!baseIndexPath) {
        return nil;
    }

    if (![self _canMoveToDirection:direction fromIndexPath:baseIndexPath]) {
        return nil;
    }

    NSInteger nextRow = baseIndexPath.row + (direction == CTAccessoryViewDirectionPrevious ? -1 : +1);
    return [NSIndexPath indexPathForRow:nextRow inSection:baseIndexPath.section];
}

- (BOOL)_canMoveToDirection:(CTAccessoryViewDirection)direction fromIndexPath:(NSIndexPath *)indexPath {
    switch (direction) {
        case CTAccessoryViewDirectionPrevious:
            return indexPath.row > 0;
        case CTAccessoryViewDirectionNext:
            return indexPath.row < [self numberOfFormCells] - 1;
    }
    return NO;
}

- (void)_updateInputAccessoryView {
    NSIndexPath * currentIndexPath = [self _indexPathForFirstResponder];
    if (currentIndexPath) {
        _nextBarButtonItem.enabled = [self _canMoveToDirection:CTAccessoryViewDirectionNext fromIndexPath:currentIndexPath];
        _previousBarButtonItem.enabled = [self _canMoveToDirection:CTAccessoryViewDirectionPrevious fromIndexPath:currentIndexPath];
    }
}

@end


@implementation ADFormTableViewController (Picker)

- (NSInteger)numberOfComponentsForIndexPath:(NSIndexPath *)indexPath {
    return 1; // to override
}

- (NSArray *)optionsForComponent:(NSInteger)component indexPath:(NSIndexPath *)indexPath {
    return nil; // to override
}

- (NSString *)stringFromSelectedIndexes:(NSArray *)indexes indexPath:(NSIndexPath *)indexPath {
    return @""; // to override
}

- (NSArray *)selectedIndexesFromString:(NSString *)string indexPath:(NSIndexPath *)indexPath {
    return nil; // to override
}


@end
