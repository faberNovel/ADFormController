//
//  FDMainFormViewController.m
//  FormDemo
//
//  Created by Pierre on 05/09/2015.
//
//

#import "FDMainFormViewController.h"
#import "CTFormTextFieldTableViewCell.h"
#import "ADKeyboardManager.h"
#import "UIView+Responder.h"

typedef NS_ENUM(NSUInteger, CTAccessoryViewDirection) {
    CTAccessoryViewDirectionPrevious,
    CTAccessoryViewDirectionNext
};

typedef NS_ENUM(NSUInteger, FDRowType) {
    FDRowTypeName,
    FDRowTypeEmail,
    FDRowTypePhoneNumber,
    FDRowTypeDate,
    FDRowTypeCount
};

static NSString * sCellIdentifier = @"Identifier";

@interface FDMainFormViewController () {
    ADKeyboardManager * _keyboardManager;
    UIDatePicker * _datePicker;

    UIView * _textFieldAccessoryView;
    UIBarButtonItem * _nextBarButtonItem;
    UIBarButtonItem * _previousBarButtonItem;
}

@end

@implementation FDMainFormViewController

+ (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Profile";

    [self.tableView registerClass:[CTFormTextFieldTableViewCell class] forCellReuseIdentifier:sCellIdentifier];
    self.tableView.tableFooterView = [UIView new];

    _keyboardManager = [[ADKeyboardManager alloc] initWithTableView:self.tableView];
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_keyboardManager startObservingKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_keyboardManager endObservingKeyboard];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return FDRowTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CTFormTextFieldTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier forIndexPath:indexPath];

    NSString * placeholder = nil;
    UIKeyboardType keyboardType = UIKeyboardTypeAlphabet;
    UITextAutocapitalizationType autocapitalizationType = UITextAutocapitalizationTypeNone;
    UITextAutocorrectionType autocorrectionType = UITextAutocorrectionTypeNo;
    UIView * inputView = nil;
    switch (indexPath.row) {
        case FDRowTypeName: {
            placeholder = @"Name";
            autocapitalizationType = UITextAutocapitalizationTypeWords;
        } break;
        case FDRowTypeEmail: {
            placeholder = @"Email";
            keyboardType = UIKeyboardTypeEmailAddress;

            UIImageView * imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"FDNextIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            imageView.tintColor = [UIColor redColor];
            cell.textField.rightViewMode = UITextFieldViewModeAlways;
            cell.textField.rightView = imageView;

        } break;
        case FDRowTypePhoneNumber: {
            placeholder = @"Phone Number";
            keyboardType = UIKeyboardTypePhonePad;
        } break;
        case FDRowTypeDate: {
            placeholder = @"Date";
            inputView = _datePicker;
        } break;
        default:
            break;
    }
    cell.textField.placeholder = placeholder;
    cell.textField.keyboardType = keyboardType;
    cell.textField.autocapitalizationType = autocapitalizationType;
    cell.textField.autocorrectionType = autocorrectionType;
    cell.textField.inputView = inputView;
    cell.textField.inputAccessoryView = [self _textFieldAccessoryView];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Profile";
}

#pragma mark - UITableViewDelegate

#pragma mark - Private

- (UIView *)_textFieldAccessoryView {
    if (!_textFieldAccessoryView) {
        UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44.0f)];
        _nextBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"FDNextIcon"]
                                                              style:UIBarButtonItemStyleBordered
                                                             target:self
                                                             action:@selector(_next:)];
        _nextBarButtonItem.width = 44.0f;
        _previousBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"FDPreviousIcon"]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(_previous:)];
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
    NSIndexPath * nextIndexPath = [self _indexPathForDirection:direction andBaseIndexPath:currentIndexPath];
    if (nextIndexPath) {
        CTFormTextFieldTableViewCell * nextCell = (CTFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:nextIndexPath];
        [nextCell.textField becomeFirstResponder];
    }
    [self _updateInputAccessoryView];
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
            return indexPath.row < FDRowTypeCount - 1;
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

- (NSIndexPath *)_indexPathForTextField:(UITextField *)textField {
    CTFormTextFieldTableViewCell * cell = [self _cellForTextField:textField];
    return [self.tableView indexPathForCell:cell];
}

- (NSIndexPath *)_indexPathForFirstResponder {
    UIView * firstResponder = [self.tableView ad_findFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        return [self _indexPathForTextField:(UITextField *)firstResponder];
    }
    return nil;
}

- (CTFormTextFieldTableViewCell *)_cellForTextField:(UITextField *)textField {
    UIView * view = textField;
    while (view != nil) {
        if ([view isKindOfClass:CTFormTextFieldTableViewCell.class]) {
            return (CTFormTextFieldTableViewCell *)view;
        }
        view = view.superview;
    }
    return nil;
}

- (CTFormTextFieldTableViewCell *)_cellFromFirstResponder {
    UIView * firstResponderView = [self.tableView ad_findFirstResponder];
    if ([firstResponderView isKindOfClass:UITextField.class]) {
        return [self _cellForTextField:(UITextField *)firstResponderView];
    }
    return nil;
}

@end
