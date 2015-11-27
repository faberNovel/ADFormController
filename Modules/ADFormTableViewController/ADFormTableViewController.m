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
#import "ADFormDirectionManager.h"
#import "UIView+Traverse.h"
#import "ADTextInputAccessoryView.h"

@interface ADFormTableViewController () <UITextFieldDelegate, UITextViewDelegate> {
    NSMutableDictionary * _cells;
    ADFormDirectionManager * _formDirectionManager;
}

@property (nonatomic, strong) ADTextInputAccessoryView * textInputAccessoryView;

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

    _formDirectionManager = [[ADFormDirectionManager alloc] initWithTableView:self.tableView];

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    if ([self.class tableViewStyle] == UITableViewStylePlain) {
        self.tableView.tableFooterView = [UIView new];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self _dismissKeyboard];
}

#pragma mark - Getter

- (ADTextInputAccessoryView *)textInputAccessoryView {
    if (!_textInputAccessoryView) {
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44.0f);
        _textInputAccessoryView = [[ADTextInputAccessoryView alloc] initWithFrame:frame];
        _textInputAccessoryView.nextBarButtonItem.target = self;
        _textInputAccessoryView.nextBarButtonItem.action = @selector(_next:);
        _textInputAccessoryView.previousBarButtonItem.target = self;
        _textInputAccessoryView.previousBarButtonItem.action = @selector(_previous:);
    }
    return _textInputAccessoryView;
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
    [self _dismissKeyboard];
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

        cell.textView.inputAccessoryView = self.textInputAccessoryView;
        cell.textView.delegate = self;
        return cell;
    } else {
        ADFormTextFieldTableViewCell * cell = [self _formCellForIndexPath:indexPath];
        [cell applyConfiguration:configuration];

        cell.textField.returnKeyType = [self _returnKeyTypeForIndexPath:indexPath];
        [cell.textField addTarget:self action:@selector(_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.textField.inputAccessoryView = self.textInputAccessoryView;
        cell.textField.delegate = self;

        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADFormCellConfiguration * configuration = [ADFormCellConfiguration new];
    [self applyConfiguration:configuration forIndexPath:indexPath];

    return configuration.cellType == ADFormTextCellTypeLongText ? 100.0f : 44.0f;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSIndexPath * indexPath = [self _indexPathForTextField:textField];
    if ([_formDirectionManager canMoveToDirection:ADAccessoryViewDirectionNext fromIndexPath:indexPath]) {
        [self _moveToDirection:ADAccessoryViewDirectionNext fromIndexPath:indexPath];
        return NO;
    }
    [self formAction:nil];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self _updateInputAccessoryView];
    ADFormTextFieldTableViewCell * cell = [self _cellForTextField:textField];
    [cell textFieldDidBeginEditing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    ADFormTextFieldTableViewCell * cell = [self _cellForTextField:textField];
    return [cell textField:textField shouldChangeCharactersInRange:range replacementString:string];
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
    return (ADFormTextFieldTableViewCell *)[textField ad_superviewOfClass:ADFormTextFieldTableViewCell.class];
}

- (ADFormTextViewTableViewCell *)_cellForTextView:(UITextView *)textView {
    return (ADFormTextViewTableViewCell *)[textView ad_superviewOfClass:ADFormTextViewTableViewCell.class];
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
    NSIndexPath * nextIndexPath = [_formDirectionManager indexPathForDirection:direction andBaseIndexPath:indexPath];
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

- (void)_updateInputAccessoryView {
    NSIndexPath * currentIndexPath = [self _indexPathForFirstResponder];
    if (currentIndexPath) {
        self.textInputAccessoryView.nextBarButtonItem.enabled = [_formDirectionManager canMoveToDirection:ADAccessoryViewDirectionNext
                                                                                            fromIndexPath:currentIndexPath];
        self.textInputAccessoryView.previousBarButtonItem.enabled = [_formDirectionManager canMoveToDirection:ADAccessoryViewDirectionPrevious
                                                                                                fromIndexPath:currentIndexPath];
    }
}

- (void)_dismissKeyboard {
    [self.tableView endEditing:YES];
}

@end
