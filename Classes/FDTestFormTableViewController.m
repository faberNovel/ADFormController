//
//  FDTestFormTableViewController.m
//  FormDemo
//
//  Created by Pierre Felgines on 27/11/15.
//
//

#import "FDTestFormTableViewController.h"
#import "FDSharedObjectiveCHeader.h"
#import "FDExpirationDateFormPickerDataSource.h"
#import "FDCreditCardTextFieldFormatter.h"
#import "FDEnglishAccessoryToolbar.h"
#import "FDSharedObjectiveCHeader.h"
#import "FDFormModel.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <ADDynamicLogLevel/ADDynamicLogLevel.h>

typedef NS_ENUM(NSUInteger, FDRowType) {
    FDRowTypeGender,
    FDRowTypeName,
    FDRowTypeEmail,
    FDRowTypePhoneNumber,
    FDRowTypeLongText,
    FDRowTypeDate,
    FDRowTypeSwitch,
    FDRowTypeNoInputAccessory,
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

@interface FDTestFormTableViewController () <FormControllerDelegate> {
    FormController * _formController;
    BOOL _passwordVisible;
}
@property (nonatomic, strong) FDFormModel * formModel;
@property (nonatomic, strong) UIButton * passwordButton;
@end

@implementation FDTestFormTableViewController

+ (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.formModel = [[FDFormModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _formController = [[FormController alloc] initWithTableView:self.tableView];
    _formController.delegate = self;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Print"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(_printValues:)];

    if (self.customAccessoryView) {
        _formController.defaultAccessoryView = [[FDEnglishAccessoryToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 64.0f)];
    }
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

- (void)setPrefilled:(BOOL)prefilled {
    _prefilled = prefilled;
    if (_prefilled) {
        self.formModel.gender = @"Male";
        self.formModel.name = @"Georges";
        self.formModel.email = @"toto.titi@gmail.com";
        self.formModel.phone = @"0612131415";
        self.formModel.summary = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras sed sapien quam. Sed dapibus est id enim facilisis, at posuere turpis adipiscing. Quisque sit amet dui dui.";
        self.formModel.married = YES;
        self.formModel.birthDate = [NSDate date];
        self.formModel.creditCard = @"5131423412231223";
        self.formModel.expiration = @"04/25";
    }
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

#pragma mark - FormControllerDelegate

- (FormCellConfiguration *)configurationForFormController:(FormController *)formController
                                                atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case FDRowTypeGender: {
                FormCellTextConfiguration * configuration = [[FormCellTextConfiguration alloc] init];
                configuration.placeholder = @"Gender";
                configuration.cellType = FormTextCellTypePicker;
                configuration.formPickerDataSource = [[SimpleFormPickerDataSource alloc] initWithOptions:@[ @"Male", @"Female" ]];
                configuration.text = self.formModel.gender;
                if (self.showTitles) {
                    configuration.title = @"Gender";
                }
                return configuration;
            } break;
            case FDRowTypeName: {
                FormCellTextConfiguration * configuration = [[FormCellTextConfiguration alloc] init];
                configuration.placeholder = @"Name";
                configuration.cellType = FormTextCellTypeName;
                configuration.text = self.formModel.name;
                if (self.showTitles) {
                    configuration.title = @"Name";
                }
                return configuration;
            } break;
            case FDRowTypeEmail: {
                FormCellTextConfiguration * configuration = [[FormCellTextConfiguration alloc] init];
                configuration.placeholder = @"Email";
                configuration.cellType = FormTextCellTypeEmail;
                configuration.text = self.formModel.email;
                if (self.showTitles) {
                    configuration.title = @"Email";
                }
                return configuration;
            } break;
            case FDRowTypePhoneNumber: {
                FormCellTextConfiguration * configuration = [[FormCellTextConfiguration alloc] init];
                configuration.placeholder = @"Phone";
                configuration.cellType = FormTextCellTypePhone;
                configuration.text = self.formModel.phone;
                if (self.showTitles) {
                    configuration.title = @"Phone";
                }
                return configuration;
            } break;
            case FDRowTypeLongText: {
                FormCellTextConfiguration * configuration = [[FormCellTextConfiguration alloc] init];
                configuration.placeholder = @"Long text";
                configuration.cellType = FormTextCellTypeLongText;
                configuration.text = self.formModel.summary;
                if (self.showTitles) {
                    configuration.title = @"Long text";
                }
                return configuration;
            } break;
            case FDRowTypeDate: {
                FormCellTextConfiguration * configuration = [[FormCellTextConfiguration alloc] init];
                configuration.placeholder = @"Date";
                configuration.cellType = FormTextCellTypeDate;
                configuration.dateFormatter = [self.class _dateFormatter];
                configuration.text = [[self.class _dateFormatter] stringFromDate:self.formModel.birthDate];
                if (self.showTitles) {
                    configuration.title = @"Date";
                }
                return configuration;
            } break;
            case FDRowTypeSwitch: {
                FormCellBoolConfiguration * configuration = [[FormCellBoolConfiguration alloc] init];
                configuration.boolValue = self.formModel.married;
                configuration.title = @"Maried";
                configuration.onTintColor = [UIColor greenColor];
                configuration.tintColor = [UIColor redColor];
                configuration.switchZoom = 0.65f;
                return configuration;
            } break;
            case FDRowTypeNoInputAccessory: {
                FormCellTextConfiguration * configuration = [[FormCellTextConfiguration alloc] init];
                configuration.placeholder = @"Useless row with no input accessory";
                configuration.cellType = FormTextCellTypeName;
                if (self.showTitles) {
                    configuration.title = @"No accessory here";
                }
                return configuration;
            } break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case FDCreditCardRowTypeNumber: {
                FormCellTextConfiguration * configuration = [[FormCellTextConfiguration alloc] init];
                configuration.placeholder = @"Credit card";
                configuration.cellType = FormTextCellTypeNumber;
                configuration.textFieldFormatter = [FDCreditCardTextFieldFormatter new];
                configuration.text = self.formModel.creditCard;
                if (self.showTitles) {
                    configuration.title = @"Credit card";
                }
                return configuration;
            } break;
            case FDCreditCardRowTypeExpirationDate: {
                FormCellTextConfiguration * configuration = [[FormCellTextConfiguration alloc] init];
                configuration.placeholder = @"Expiration Date";
                configuration.cellType = FormTextCellTypePicker;
                configuration.formPickerDataSource = [FDExpirationDateFormPickerDataSource new];
                configuration.text = self.formModel.expiration;
                if (self.showTitles) {
                    configuration.title = @"Expiration date";
                }
                return configuration;
            } break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case FDPasswordRowTypeNewPassword: {
                FormCellTextConfiguration * configuration = [[FormCellTextConfiguration alloc] init];
                configuration.placeholder = @"New password";
                if (!_passwordVisible) {
                    configuration.cellType = FormTextCellTypePassword;
                }
                if (self.isPrefilled) {
                    configuration.text = @"abcdef";
                }
                if (self.showTitles) {
                    configuration.title = @"New password";
                }
                configuration.rightView = self.passwordButton;
                return configuration;
            } break;
            case FDPasswordRowTypeNewPasswordConfirmation: {
                FormCellTextConfiguration * configuration = [[FormCellTextConfiguration alloc] init];
                configuration.placeholder = @"Confirmation";
                configuration.cellType = FormTextCellTypePassword;
                if (self.isPrefilled) {
                    configuration.text = @"abcdef";
                }
                if (self.showTitles) {
                    configuration.title = @"Confirmation";
                }
                return configuration;
            } break;
        }
    }
    return nil;
}

- (UIView *)formController:(FormController *)formController inputAccessoryViewAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == FDPasswordRowTypeNewPasswordConfirmation) {
        UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44.0f)];
        UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Check password"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(_checkPassword:)];
        toolbar.items = @[ barButtonItem ];
        return toolbar;
    } else if (indexPath.section == 0 && indexPath.row == FDRowTypeNoInputAccessory) {
        return nil;
    }
    return formController.defaultAccessoryView.view;
}

- (void)formController:(FormController *)formController valueChangedForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case FDRowTypeGender: {
                self.formModel.gender = [formController stringValueForIndexPath:indexPath];
            } break;
            case FDRowTypeName: {
                self.formModel.name = [formController stringValueForIndexPath:indexPath];
            } break;
            case FDRowTypeEmail: {
                self.formModel.email = [formController stringValueForIndexPath:indexPath];
            } break;
            case FDRowTypePhoneNumber: {
                self.formModel.phone = [formController stringValueForIndexPath:indexPath];
            } break;
            case FDRowTypeLongText: {
                self.formModel.summary = [formController stringValueForIndexPath:indexPath];
            } break;
            case FDRowTypeDate: {
                self.formModel.birthDate = [formController dateValueForIndexPath:indexPath];
            } break;
            case FDRowTypeSwitch: {
                self.formModel.married = [formController boolValueForIndexPath:indexPath];
            } break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case FDCreditCardRowTypeNumber: {
                self.formModel.creditCard = [formController stringValueForIndexPath:indexPath];
            } break;
            case FDCreditCardRowTypeExpirationDate: {
                self.formModel.expiration = [formController stringValueForIndexPath:indexPath];
            } break;
        }
    }
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

- (void)_printValues:(id)sender {
}

@end
