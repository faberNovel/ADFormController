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
    FDRowTypeDate,
    FDRowTypeCreditCard,
    FDRowTypeCount
};

@interface FDMainFormTableViewController () {
    NSArray * _genders;
}

@end

@implementation FDMainFormTableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _genders = @[ @"Male", @"Female" ];
    }
    return self;
}

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

- (void)configureCell:(ADFormTextFieldTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    [super configureCell:cell forIndexPath:indexPath];

    switch (indexPath.row) {
        case FDRowTypeGender: {
            cell.textField.placeholder = @"Gender";
            cell.cellType = CTFormTextCellTypePicker;
        } break;
        case FDRowTypeName: {
            cell.textField.placeholder = @"Name";
            cell.cellType = CTFormTextCellTypeName;
        } break;
        case FDRowTypeEmail: {
            cell.textField.placeholder = @"Email";
            cell.cellType = CTFormTextCellTypeEmail;
        } break;
        case FDRowTypePhoneNumber: {
            cell.textField.placeholder = @"Phone";
            cell.cellType = CTFormTextCellTypePhone;
        } break;
        case FDRowTypeDate: {
            cell.textField.placeholder = @"Date";
            cell.cellType = CTFormTextCellTypeDate;
        } break;
        case FDRowTypeCreditCard: {
            cell.textField.placeholder = @"Credit card";
            cell.cellType = CTFormTextCellTypeNumber;
            cell.textFieldFormatterClass = [FDCreditCardTextFieldFormatter class];
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
}

- (NSInteger)numberOfComponentsForIndexPath:(NSIndexPath *)indexPath {
    return 1;
}

- (NSArray *)optionsForComponent:(NSInteger)component indexPath:(NSIndexPath *)indexPath {
    return _genders;
}

- (NSString *)stringFromSelectedIndexes:(NSArray *)indexes indexPath:(NSIndexPath *)indexPath {
    NSInteger index = [[indexes lastObject] integerValue];
    return _genders[index];
}

- (NSArray *)selectedIndexesFromString:(NSString *)string indexPath:(NSIndexPath *)indexPath {
    NSInteger index = [_genders indexOfObject:string];
    return @[ @(index) ];
}

@end
