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

typedef NS_ENUM(NSUInteger, FDRowType) {
    FDRowTypeGender,
    FDRowTypeName,
    FDRowTypeEmail,
    FDRowTypePhoneNumber,
    FDRowTypeLongText,
    FDRowTypeDate,
    FDRowTypeCreditCard,
    FDRowTypeCount
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

- (NSInteger)numberOfFormCells {
    return FDRowTypeCount;
}

- (void)applyConfiguration:(ADFormCellConfiguration *)configuration forIndexPath:(NSIndexPath *)indexPath {
    [super applyConfiguration:configuration forIndexPath:indexPath];
    switch (indexPath.row) {
        case FDRowTypeGender: {
            configuration.placeholder = @"Gender";
            configuration.cellType = ADFormTextCellTypePicker;
            configuration.formPickerDataSource = [[ADSimpleFormPickerDataSource alloc] initWithOptions:@[ @"Male", @"Female" ]];
        } break;
        case FDRowTypeName: {
            configuration.placeholder = @"Name";
            configuration.cellType = ADFormTextCellTypeName;
        } break;
        case FDRowTypeEmail: {
            configuration.placeholder = @"Email";
            configuration.cellType = ADFormTextCellTypeEmail;
        } break;
        case FDRowTypePhoneNumber: {
            configuration.placeholder = @"Phone";
            configuration.cellType = ADFormTextCellTypePhone;
        } break;
        case FDRowTypeLongText: {
            configuration.placeholder = @"Long text";
            configuration.cellType = ADFormTextCellTypeLongText;
        } break;
        case FDRowTypeDate: {
            configuration.placeholder = @"Date";
            configuration.cellType = ADFormTextCellTypeDate;
            configuration.dateFormatter = [self.class _dateFormatter];
            configuration.text = @"04/09/1990";
        } break;
        case FDRowTypeCreditCard: {
            configuration.placeholder = @"Credit card";
            configuration.cellType = ADFormTextCellTypeNumber;
            configuration.textFieldFormatterClass = [FDCreditCardTextFieldFormatter class];
        } break;
        default:
            break;
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
