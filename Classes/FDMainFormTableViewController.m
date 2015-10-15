//
//  FDMainFormTableViewController.m
//  FormDemo
//
//  Created by Pierre Felgines on 21/09/2015.
//
//

#import "FDMainFormTableViewController.h"
#import "ADFormTextFieldTableViewCell.h"
#import "FDCreditCardTextFieldFormatter.h"
#import "FDExpirationDateFormPickerDataSource.h"


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

@interface FDMainFormTableViewController () {

}

@end

@implementation FDMainFormTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(formAction:)];
}

#pragma mark - FDTableViewController

+ (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

#pragma mark - CTFormTableViewController

- (NSInteger)numberOfFormSections {
    return 3;
}

- (NSInteger)numberOfFormCellsInSection:(NSInteger)section {
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

- (void)applyConfiguration:(ADFormCellConfiguration *)configuration forIndexPath:(NSIndexPath *)indexPath {
    [super applyConfiguration:configuration forIndexPath:indexPath];
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
                configuration.textFieldFormatterClass = [FDCreditCardTextFieldFormatter class];
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
                configuration.cellType = ADFormTextCellTypePassword;
                if (self.isPrefilled) {
                    configuration.text = @"abcdef";
                }
                if (self.showTitles) {
                    configuration.title = @"New password";
                }
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

- (void)formAction:(id)sender {
    [super formAction:sender];

    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:FDRowTypeGender inSection:0];
    NSString * gender = [self stringValueForIndexPath:indexPath];
    DDLogInfo(@"Gender = %@", gender);

    NSDate * date = [self dateValueForIndexPath:[NSIndexPath indexPathForRow:FDRowTypeDate inSection:0]];
    DDLogInfo(@"Date = %@", date);
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


@end
