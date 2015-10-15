//
//  CTFormTableViewController.m
//  ChicTypes
//
//  Created by Pierre Felgines on 27/04/2015.
//
//

#import "ADFormTableViewController.h"
#import "ADFormTextFieldTableViewCell.h"
#import "ADFormTextViewTableViewCell.h"
#import "UIView+Responder.h"

typedef NS_ENUM(NSUInteger, ADAccessoryViewDirection) {
    ADAccessoryViewDirectionPrevious,
    ADAccessoryViewDirectionNext
};

@interface ADFormTableViewController () <UITextViewDelegate> {
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

- (void)applyConfiguration:(ADFormCellConfiguration *)configuration forIndexPath:(NSIndexPath *)indexPath {
    configuration.textColor = [UIColor blackColor];
    configuration.tintColor = [UIColor blackColor];
    configuration.textFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    configuration.titleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
}

- (NSInteger)numberOfFormSections {
    return 1;
}

- (NSInteger)numberOfFormCellsInSection:(NSInteger)section {
    return 0;
}

- (void)formAction:(id)sender {
    [self.tableView endEditing:YES];
}

- (NSString *)stringValueForIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell && [cell isKindOfClass:ADFormTextFieldTableViewCell.class]) {
        return ((ADFormTextFieldTableViewCell *)cell).textField.text;
    } else if (cell && [cell isKindOfClass:ADFormTextViewTableViewCell.class]) {
        return ((ADFormTextViewTableViewCell *)cell).textView.text;
    }
    return nil;
}

- (NSDate *)dateValueForIndexPath:(NSIndexPath *)indexPath {
    ADFormTextFieldTableViewCell * cell = (ADFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    ADFormCellConfiguration * configuration = [ADFormCellConfiguration new];
    [self applyConfiguration:configuration forIndexPath:indexPath];
    if (cell && configuration.cellType == ADFormTextCellTypeDate) {
        return [configuration.dateFormatter dateFromString:cell.textField.text];
    }
    return nil;
}

- (void)valueChangedForTextField:(UITextField *)textField atIndexPath:(NSIndexPath *)indexPath {
    // to override
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfFormSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfFormCellsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Create empty configuration
    ADFormCellConfiguration * configuration = [ADFormCellConfiguration new];
    // Ask subclass to fill configuration
    [self applyConfiguration:configuration forIndexPath:indexPath];


    if (configuration.cellType == ADFormTextCellTypeLongText) {
        ADFormTextViewTableViewCell * cell = [self _formTextViewCellForIndexPath:indexPath];
        [cell applyConfiguration:configuration];

        cell.textView.inputAccessoryView = [self _textFieldAccessoryView];
        cell.textView.delegate = self;
        return cell;
    } else {
        ADFormTextFieldTableViewCell * cell = [self _formCellForIndexPath:indexPath];
        [cell applyConfiguration:configuration];

        cell.textField.returnKeyType = [self _returnKeyTypeForIndexPath:indexPath];
        [cell.textField addTarget:self action:@selector(_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.textField.inputAccessoryView = [self _textFieldAccessoryView];
        cell.textField.delegate = self;

        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADFormCellConfiguration * configuration = [ADFormCellConfiguration new];
    [self applyConfiguration:configuration forIndexPath:indexPath];

    return configuration.cellType == ADFormTextCellTypeLongText ? 100.0f : UITableViewAutomaticDimension;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSIndexPath * indexPath = [self _indexPathForTextField:textField];
    if ([self _canMoveToDirection:ADAccessoryViewDirectionNext fromIndexPath:indexPath]) {
        [self _moveToDirection:ADAccessoryViewDirectionNext fromIndexPath:indexPath];
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

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self _updateInputAccessoryView];
}

#pragma mark - Private

- (ADFormTextFieldTableViewCell *)_formCellForIndexPath:(NSIndexPath *)indexPath {
    return (ADFormTextFieldTableViewCell *)[self _cellWithClass:ADFormTextFieldTableViewCell.class forIndexPath:indexPath];
}

- (ADFormTextViewTableViewCell *)_formTextViewCellForIndexPath:(NSIndexPath *)indexPath {
    return (ADFormTextViewTableViewCell *)[self _cellWithClass:ADFormTextViewTableViewCell.class forIndexPath:indexPath];
}

- (UITableViewCell *)_cellWithClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath {
    NSInteger key = indexPath.section * 100 + indexPath.row;
    if (!_cells[@(key)]) {
        _cells[@(key)] = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    return _cells[@(key)];
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

- (ADFormTextViewTableViewCell *)_cellForTextView:(UITextView *)textView {
    UIView * view = textView;
    while (view != nil) {
        if ([view isKindOfClass:ADFormTextViewTableViewCell.class]) {
            return (ADFormTextViewTableViewCell *)view;
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

- (NSIndexPath *)_indexPathForTextView:(UITextView *)textView {
    ADFormTextViewTableViewCell * cell = [self _cellForTextView:textView];
    return [self.tableView indexPathForCell:cell];
}

- (NSIndexPath *)_indexPathForFirstResponder {
    UIView * firstResponder = [self.tableView ad_findFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        return [self _indexPathForTextField:(UITextField *)firstResponder];
    } else if ([firstResponder isKindOfClass:[UITextView class]]) {
        return [self _indexPathForTextView:(UITextView *)firstResponder];
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

- (UIReturnKeyType)_returnKeyTypeForIndexPath:(NSIndexPath *)indexPath {
    NSInteger lastSection = [self numberOfFormSections] - 1;
    BOOL isLastSection = indexPath.section == lastSection;
    BOOL isLastRowInLastSection = indexPath.row == [self numberOfFormCellsInSection:lastSection] - 1;
    return (isLastSection && isLastRowInLastSection) ? UIReturnKeyGo : UIReturnKeyNext;
}

- (void)_next:(id)sender {
    [self _moveToDirection:ADAccessoryViewDirectionNext];
}

- (void)_previous:(id)sender {
    [self _moveToDirection:ADAccessoryViewDirectionPrevious];
}

- (void)_moveToDirection:(ADAccessoryViewDirection)direction {
    NSIndexPath * currentIndexPath = [self _indexPathForFirstResponder];
    [self _moveToDirection:direction fromIndexPath:currentIndexPath];
}

- (void)_moveToDirection:(ADAccessoryViewDirection)direction fromIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath * nextIndexPath = [self _indexPathForDirection:direction andBaseIndexPath:indexPath];
    if (nextIndexPath) {
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:nextIndexPath];

        if ([cell isKindOfClass:ADFormTextFieldTableViewCell.class]) {
            ADFormTextFieldTableViewCell * nextCell = (ADFormTextFieldTableViewCell *)cell;
            [nextCell.textField becomeFirstResponder];
        } else if ([cell isKindOfClass:ADFormTextViewTableViewCell.class]) {
            ADFormTextViewTableViewCell * nextCell = (ADFormTextViewTableViewCell *)cell;
            [nextCell.textView becomeFirstResponder];

        }
    }
}

- (NSIndexPath *)_indexPathForDirection:(ADAccessoryViewDirection)direction andBaseIndexPath:(NSIndexPath *)baseIndexPath {
    if (!baseIndexPath) {
        return nil;
    }

    if (![self _canMoveToDirection:direction fromIndexPath:baseIndexPath]) {
        return nil;
    }

    NSInteger nextSection = baseIndexPath.section;
    NSInteger nextRow = baseIndexPath.row;

    if (direction == ADAccessoryViewDirectionNext) {
        BOOL isLastRowInSection = baseIndexPath.row == [self numberOfFormCellsInSection:baseIndexPath.section] - 1;
        nextSection = isLastRowInSection ? baseIndexPath.section + 1 : baseIndexPath.section;
        nextRow = isLastRowInSection ? 0 : baseIndexPath.row + 1;
    } else {
        BOOL isFirstRowInSection = baseIndexPath.row == 0;
        nextSection = isFirstRowInSection ? baseIndexPath.section - 1 : baseIndexPath.section;
        nextRow = isFirstRowInSection ? [self numberOfFormCellsInSection:nextSection] - 1 : baseIndexPath.row - 1;
    }

    return [NSIndexPath indexPathForRow:nextRow inSection:nextSection];
}

- (BOOL)_canMoveToDirection:(ADAccessoryViewDirection)direction fromIndexPath:(NSIndexPath *)indexPath {
    switch (direction) {
        case ADAccessoryViewDirectionPrevious:
            return ![indexPath isEqual:[self _firstIndexPath]];
        case ADAccessoryViewDirectionNext:
            return ![indexPath isEqual:[self _lastIndexPath]];
    }
    return NO;
}

- (NSIndexPath *)_firstIndexPath {
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (NSIndexPath *)_lastIndexPath {
    NSInteger lastSection = [self numberOfFormSections] - 1;
    return [NSIndexPath indexPathForRow:[self numberOfFormCellsInSection:lastSection] - 1
                              inSection:lastSection];
}

- (void)_updateInputAccessoryView {
    NSIndexPath * currentIndexPath = [self _indexPathForFirstResponder];
    if (currentIndexPath) {
        _nextBarButtonItem.enabled = [self _canMoveToDirection:ADAccessoryViewDirectionNext fromIndexPath:currentIndexPath];
        _previousBarButtonItem.enabled = [self _canMoveToDirection:ADAccessoryViewDirectionPrevious fromIndexPath:currentIndexPath];
    }
}

@end
