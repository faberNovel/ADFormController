//
//  ADFormController.m
//  FormDemo
//
//  Created by Pierre Felgines on 27/11/15.
//
//

#import "ADFormController.h"
#import "ADFormTextViewTableViewCell.h"
#import "ADFormTextFieldTableViewCell.h"
#import "ADTextInputAccessoryView.h"
#import "ADFormDirectionManager.h"
#import "UIView+Traverse.h"
#import "UIView+Responder.h"

@interface ADFormController () <ADFormTextInputTableViewCellDelegate> {
    NSMutableDictionary * _cells;
    ADTextInputAccessoryView * _defaultInputAccessoryView;
    ADFormDirectionManager * _formDirectionManager;
}
@property (nonatomic, weak) UITableView * tableView;
@end

@implementation ADFormController

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        _tableView = tableView;
        _cells = [NSMutableDictionary dictionary];
        _formDirectionManager = [[ADFormDirectionManager alloc] initWithTableView:self.tableView];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Create empty configuration
    ADFormCellConfiguration * configuration = [ADFormCellConfiguration new];
    configuration.textColor = [UIColor blackColor];
    configuration.tintColor = [UIColor blackColor];
    configuration.textFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    configuration.titleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];

    if ([self.delegate respondsToSelector:@selector(formController:applyConfiguration:forIndexPath:)]) {
        [self.delegate formController:self applyConfiguration:configuration forIndexPath:indexPath];
    }

    UIView * accessoryView = self.defaultInputAccessoryView;
    if ([self.delegate respondsToSelector:@selector(formController:inputAccessoryViewForIndexPath:)]) {
        accessoryView = [self.delegate formController:self inputAccessoryViewForIndexPath:indexPath];
    }

    UITableViewCell<ADFormTextInputTableViewCell> * cell = [self _cellFromConfiguration:configuration indexPath:indexPath];;
    cell.delegate = self;
    cell.inputAccessoryView = accessoryView;
    cell.returnKeyType = [self _returnKeyTypeForIndexPath:indexPath];
    [cell applyConfiguration:configuration];

    return cell;
}

#pragma mark - Getter

- (UIView *)defaultInputAccessoryView {
    if (!_defaultInputAccessoryView) {
        ADTextInputAccessoryView * textInputAccessoryView = [[ADTextInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44.0f)];

        textInputAccessoryView.nextBarButtonItem.target = self;
        textInputAccessoryView.nextBarButtonItem.action = @selector(_next:);

        textInputAccessoryView.previousBarButtonItem.target = self;
        textInputAccessoryView.previousBarButtonItem.action = @selector(_previous:);

        _defaultInputAccessoryView = textInputAccessoryView;
    }
    return _defaultInputAccessoryView;
}

#pragma mark - Methods

- (NSString *)stringValueForIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(ADFormTextInputTableViewCell)]) {
        id<ADFormTextInputTableViewCell> inputCell = (id<ADFormTextInputTableViewCell>)cell;
        return [inputCell textContent];
    }
    return nil;
}

- (NSDate *)dateValueForIndexPath:(NSIndexPath *)indexPath {
    ADFormTextFieldTableViewCell * cell = (ADFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    ADFormCellConfiguration * configuration = [ADFormCellConfiguration new];
    if ([self.delegate respondsToSelector:@selector(formController:applyConfiguration:forIndexPath:)]) {
        [self.delegate formController:self applyConfiguration:configuration forIndexPath:indexPath];
    }
    
    if (cell && configuration.cellType == ADFormTextCellTypeDate) {
        return [configuration.dateFormatter dateFromString:cell.textField.text];
    }
    return nil;
}

#pragma mark - ADFormTextInputTableViewCellDelegate

- (void)textInputTableViewCellDidBeginEditing:(id<ADFormTextInputTableViewCell>)textInputTableViewCell {
    [self _updateInputAccessoryView];
}

- (BOOL)textInputTableViewCellShouldReturn:(UITableViewCell<ADFormTextInputTableViewCell> *)textInputTableViewCell {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:textInputTableViewCell];
    if ([_formDirectionManager canMoveToDirection:ADAccessoryViewDirectionNext fromIndexPath:indexPath]) {
        [self _moveToDirection:ADAccessoryViewDirectionNext fromIndexPath:indexPath];
        return NO;
    }

    if ([self.delegate respondsToSelector:@selector(formControllerAction:)]) {
        [self.delegate formControllerAction:self];
    }

    return YES;
}

- (void)textInputTableViewCellValueChanged:(UITableViewCell<ADFormTextInputTableViewCell> *)textInputTableViewCell {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:textInputTableViewCell];
    if (indexPath && [self.delegate respondsToSelector:@selector(formController:valueChangedForIndexPath:)]) {
        [self.delegate formController:self valueChangedForIndexPath:indexPath];
    }
}

#pragma mark - Private

- (UITableViewCell<ADFormTextInputTableViewCell> *)_cellFromConfiguration:(ADFormCellConfiguration *)configuration
                                                                indexPath:(NSIndexPath *)indexPath {

    UITableViewCell<ADFormTextInputTableViewCell> * cell = nil;
    if (configuration.cellType == ADFormTextCellTypeLongText) {
        cell = [self _cellWithClass:ADFormTextViewTableViewCell.class
                       forIndexPath:indexPath];
    } else {
        cell = [self _cellWithClass:ADFormTextFieldTableViewCell.class
                       forIndexPath:indexPath];
    }
    return cell;
}

- (UITableViewCell<ADFormTextInputTableViewCell> *)_cellWithClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath {
    NSInteger key = indexPath.section * 100 + indexPath.row;
    if (!_cells[@(key)]) {
        _cells[@(key)] = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    return _cells[@(key)];
}

- (UIReturnKeyType)_returnKeyTypeForIndexPath:(NSIndexPath *)indexPath {
    NSInteger lastSection = [self.tableView numberOfSections] - 1;
    BOOL isLastSection = indexPath.section == lastSection;
    BOOL isLastRowInLastSection = indexPath.row == [self.tableView numberOfRowsInSection:lastSection] - 1;
    return (isLastSection && isLastRowInLastSection) ? UIReturnKeyGo : UIReturnKeyNext;
}

- (UITableViewCell *)_cellForTextInput:(UIView<UITextInput> *)textInput {
    return (UITableViewCell *)[textInput ad_superviewOfClass:UITableViewCell.class];
}

- (NSIndexPath *)_indexPathForTextInput:(UIView<UITextInput> *)textInput {
    UITableViewCell * cell = [self _cellForTextInput:textInput];
    return [self.tableView indexPathForCell:cell];
}

- (NSIndexPath *)_indexPathForFirstResponder {
    UIView * firstResponder = [self.tableView ad_findFirstResponder];
    if ([firstResponder conformsToProtocol:@protocol(UITextInput)]) {
        return [self _indexPathForTextInput:(UIView<UITextInput> *)firstResponder];
    }
    return nil;
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
        if ([cell conformsToProtocol:@protocol(ADFormTextInputTableViewCell)]) {
            id<ADFormTextInputTableViewCell> inputCell = (id<ADFormTextInputTableViewCell>)cell;
            [inputCell beginEditing];
        }
    }
}

- (void)_updateInputAccessoryView {
    NSIndexPath * currentIndexPath = [self _indexPathForFirstResponder];
    if (currentIndexPath) {
        _defaultInputAccessoryView.nextBarButtonItem.enabled = [_formDirectionManager canMoveToDirection:ADAccessoryViewDirectionNext fromIndexPath:currentIndexPath];
        _defaultInputAccessoryView.previousBarButtonItem.enabled = [_formDirectionManager canMoveToDirection:ADAccessoryViewDirectionPrevious fromIndexPath:currentIndexPath];
    }
}

@end
