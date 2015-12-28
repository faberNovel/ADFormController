//
//  FDTestFormTableViewController.m
//  FormDemo
//
//  Created by Pierre Felgines on 27/11/15.
//
//

#import "FDTestFormTableViewController.h"
#import "ADFormController.h"
#import "FDExpirationDateFormPickerDataSource.h"
#import "FDCreditCardTextFieldFormatter.h"
#import "ADSimpleFormPickerDataSource.h"    

typedef NS_ENUM(NSUInteger, FDRowType) {
    FDRowTypeGender,
    FDRowTypeName,
    FDRowTypeEmail,
    FDRowTypePhoneNumber,
    FDRowTypeLongText,
    FDRowTypeDate,
    FDRowTypeCount
};

typedef NS_ENUM(NSUInteger, FDCreditCardRowType) {
    FDCreditCardRowTypeNumber,
    FDCreditCardRowTypeExpirationDate,
    FDCreditCardRowTypeCount
};

typedef NS_ENUM(NSUInteger, FDPasswordRowType) {
    FDPasswordRowTypeNewPassword,
    FDPasswordRowTypeNewPasswordConfirmation,
    FDPasswordRowTypeCount
};

@interface FDTestFormTableViewController () <ADFormControllerDelegate> {
    ADFormController * _formController;
    BOOL _passwordVisible;
}
@property (nonatomic, strong) UIButton * passwordButton;
@end

@implementation FDTestFormTableViewController

+ (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _formController = [[ADFormController alloc] initWithTableView:self.tableView];
    _formController.delegate = self;
}

- (UIButton *)passwordButton {
    if (!_passwordButton) {
        _passwordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_passwordButton setTitle:@"Show" forState:UIControlStateNormal];
        [_passwordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _passwordButton.titleLabel.font = [UIFont italicSystemFontOfSize:10.0f];
        _passwordButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10.0f, 0, 10.0f);
        [_passwordButton addTarget:self action:@selector(_togglePassword:) forControlEvents:UIControlEventTouchUpInside];
        [_passwordButton sizeToFit];
    }
    return _passwordButton;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return FDRowTypeCount;
        } break;
        case 1: {
            return FDCreditCardRowTypeCount;
        } break;
        case 2: {
            return FDPasswordRowTypeCount;
        } break;
        default:
            break;
    }
    return FDRowTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_formController cellForRowAtIndexPath:indexPath];
}

#pragma mark - ADFormControllerDelegate

- (void)formController:(ADFormController *)formController
    applyConfiguration:(ADFormCellConfiguration *)configuration
          forIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case FDRowTypeGender: {
                configuration.placeholder = @"Gender";
                configuration.cellType = ADFormTextCellTypePicker;
                configuration.formPickerDataSource = [[ADSimpleFormPickerDataSource alloc] initWithOptions:@[ @"Male", @"Female" ]];
                if (self.isPrefilled) {
                    configuration.text = @"Male";
                }
                if (self.showTitles) {
                    configuration.title = @"Gender";
                }
            } break;
            case FDRowTypeName: {
                configuration.placeholder = @"Name";
                configuration.cellType = ADFormTextCellTypeName;
                if (self.isPrefilled) {
                    configuration.text = @"Georges";
                }
                if (self.showTitles) {
                    configuration.title = @"Name";
                }
            } break;
            case FDRowTypeEmail: {
                configuration.placeholder = @"Email";
                configuration.cellType = ADFormTextCellTypeEmail;
                if (self.isPrefilled) {
                    configuration.text = @"toto.titi@gmail.com";
                }
                if (self.showTitles) {
                    configuration.title = @"Email";
                }
            } break;
            case FDRowTypePhoneNumber: {
                configuration.placeholder = @"Phone";
                configuration.cellType = ADFormTextCellTypePhone;
                if (self.isPrefilled) {
                    configuration.text = @"0612131415";
                }
                if (self.showTitles) {
                    configuration.title = @"Phone";
                }
            } break;
            case FDRowTypeLongText: {
                configuration.placeholder = @"Long text";
                configuration.cellType = ADFormTextCellTypeLongText;
                if (self.isPrefilled) {
                    configuration.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras sed sapien quam. Sed dapibus est id enim facilisis, at posuere turpis adipiscing. Quisque sit amet dui dui.";
                }
                if (self.showTitles) {
                    configuration.title = @"Long text";
                }
            } break;
            case FDRowTypeDate: {
                configuration.placeholder = @"Date";
                configuration.cellType = ADFormTextCellTypeDate;
                configuration.dateFormatter = [self.class _dateFormatter];
                if (self.isPrefilled) {
                    configuration.text = @"04/09/1990";
                }
                if (self.showTitles) {
                    configuration.title = @"Date";
                }
            } break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case FDCreditCardRowTypeNumber: {
                configuration.placeholder = @"Credit card";
                configuration.cellType = ADFormTextCellTypeNumber;
                configuration.textFieldFormatter = [FDCreditCardTextFieldFormatter new];
                if (self.isPrefilled) {
                    configuration.text = @"5131423412231223";
                }
                if (self.showTitles) {
                    configuration.title = @"Credit card";
                }
            } break;
            case FDCreditCardRowTypeExpirationDate: {
                configuration.placeholder = @"Expiration Date";
                configuration.cellType = ADFormTextCellTypePicker;
                configuration.formPickerDataSource = [FDExpirationDateFormPickerDataSource new];
                if (self.isPrefilled) {
                    configuration.text = @"04/25";
                }
                if (self.showTitles) {
                    configuration.title = @"Expiration date";
                }
            } break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case FDPasswordRowTypeNewPassword: {
                configuration.placeholder = @"New password";
                if (!_passwordVisible) {
                    configuration.cellType = ADFormTextCellTypePassword;
                }
                if (self.isPrefilled) {
                    configuration.text = @"abcdef";
                }
                if (self.showTitles) {
                    configuration.title = @"New password";
                }
                configuration.rightView = self.passwordButton;
            } break;
            case FDPasswordRowTypeNewPasswordConfirmation: {
                configuration.placeholder = @"Confirmation";
                configuration.cellType = ADFormTextCellTypePassword;
                if (self.isPrefilled) {
                    configuration.text = @"abcdef";
                }
                if (self.showTitles) {
                    configuration.title = @"Confirmation";
                }
            } break;
        }
    }
}

- (UIView *)formController:(ADFormController *)formController inputAccessoryViewForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == FDPasswordRowTypeNewPasswordConfirmation) {
        UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44.0f)];
        UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Check password"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(_checkPassword:)];
        toolbar.items = @[ barButtonItem ];
        return toolbar;
    }
    return formController.defaultInputAccessoryView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == FDRowTypeLongText) {
        return 100.0f;
    }
    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return @"Profile";
        } break;
        case 1: {
            return @"Credit card";
        } break;
        case 2: {
            return @"Password";
        } break;
        default:
            break;
    }
    return nil;
}

#pragma mark - Private

+ (NSDateFormatter *)_dateFormatter {
    static NSDateFormatter * sDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sDateFormatter = [[NSDateFormatter alloc] init];
        sDateFormatter.dateFormat = @"dd/MM/yyyy";
    });
    return sDateFormatter;
}

- (void)_checkPassword:(id)sender {
    NSString * newPassword = [_formController stringValueForIndexPath:[NSIndexPath indexPathForRow:FDPasswordRowTypeNewPassword inSection:2]];
    NSString * newPasswordConfirmation = [_formController stringValueForIndexPath:[NSIndexPath indexPathForRow:FDPasswordRowTypeNewPasswordConfirmation inSection:2]];
    if ([newPassword isEqualToString:newPasswordConfirmation]) {
        NSLog(@"Same password \\o/");
    } else {
        NSLog(@"/!\\ Password error");
    }
}

- (void)_togglePassword:(id)sender {
    _passwordVisible = !_passwordVisible;
    [self.passwordButton setTitle:_passwordVisible ? @"Hide" : @"Show" forState:UIControlStateNormal];

    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:FDPasswordRowTypeNewPassword inSection:2];
    [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
}

@end
