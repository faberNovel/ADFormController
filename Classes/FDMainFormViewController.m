//
//  FDMainFormViewController.m
//  FormDemo
//
//  Created by Pierre on 05/09/2015.
//
//

#import "FDMainFormViewController.h"
#import "CTFormTextFieldTableViewCell.h"
#import "FDKeyboardManager.h"

typedef NS_ENUM(NSUInteger, FDRowType) {
    FDRowTypeName,
    FDRowTypeEmail,
    FDRowTypePhoneNumber,
    FDRowTypeDate,
    FDRowTypeCount
};

static NSString * sCellIdentifier = @"Identifier";

@interface FDMainFormViewController () {
    FDKeyboardManager * _keyboardManager;
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

    _keyboardManager = [[FDKeyboardManager alloc] initWithTableView:self.tableView];
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
    switch (indexPath.row) {
        case FDRowTypeName: {
            placeholder = @"Name";
            autocapitalizationType = UITextAutocapitalizationTypeWords;
        } break;
        case FDRowTypeEmail: {
            placeholder = @"Email";
            keyboardType = UIKeyboardTypeEmailAddress;
        } break;
        case FDRowTypePhoneNumber: {
            placeholder = @"Phone Number";
            keyboardType = UIKeyboardTypePhonePad;
        } break;
        case FDRowTypeDate: {
            placeholder = @"Date";
        } break;
        default:
            break;
    }
    cell.textField.placeholder = placeholder;
    cell.textField.keyboardType = keyboardType;
    cell.textField.autocapitalizationType = autocapitalizationType;
    cell.textField.autocorrectionType = autocorrectionType;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Profile";
}

#pragma mark - UITableViewDelegate


@end
