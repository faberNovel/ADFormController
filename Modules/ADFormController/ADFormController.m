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
#import "ADFormSwitchTableViewCell.h"
#import "ADFormBoolInputTableViewCell.h"
#import "ADFormCellBoolConfiguration.h"
#import "ADFormCellTextConfiguration.h"
#import "ADFormCellConfigurable.h"

@interface ADFormController () <ADFormTextInputTableViewCellDelegate, ADFormBoolInputTableViewCellDelegate, ADFormDirectionManagerDelegate, ADFormCellConfigurable> {
    NSMutableDictionary<NSIndexPath *, UITableViewCell *> * _cells;
    UIView<ADNavigableButtons> * _defaultInputAccessoryView;
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
        _formDirectionManager.delegate = self;
        [self _setupDefaultInputAccessoryView];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADFormCellConfiguration * configuration = nil;
    if ([self.delegate respondsToSelector:@selector(configurationForFormController:atIndexPath:)]) {
        configuration = [self.delegate configurationForFormController:self atIndexPath:indexPath];
    }
    return [configuration visit:self atIndexPath:indexPath];
}

#pragma mark - Getter/Setter

- (void)setDefaultInputAccessoryView:(UIView<ADNavigableButtons> *)defaultInputAccessoryView {
    _defaultInputAccessoryView = defaultInputAccessoryView;
    [self _addMovingSelectorsToInputAccessoryView:defaultInputAccessoryView];
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

- (BOOL)boolValueForIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(ADFormBoolInputTableViewCell)]) {
        id<ADFormBoolInputTableViewCell> inputCell = (id<ADFormBoolInputTableViewCell>)cell;
        return inputCell.boolContent;
    }
    return NO;
}

- (NSDate *)dateValueForIndexPath:(NSIndexPath *)indexPath {
    ADFormTextFieldTableViewCell * cell = (ADFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    ADFormCellConfiguration * configuration = nil;
    if ([self.delegate respondsToSelector:@selector(configurationForFormController:atIndexPath:)]) {
        configuration = [self.delegate configurationForFormController:self atIndexPath:indexPath];
    }
    if (cell && [configuration isKindOfClass:ADFormCellTextConfiguration.class]) {
        return [((ADFormCellTextConfiguration *)configuration).dateFormatter dateFromString:cell.textField.text];
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

#pragma mark - ADFormBoolInputTableViewCellDelegate

- (void)boolInputTableViewCellDidChangeValue:(UITableViewCell<ADFormBoolInputTableViewCell> *)boolInputTableViewCell {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:boolInputTableViewCell];
    if (indexPath && [self.delegate respondsToSelector:@selector(formController:valueChangedForIndexPath:)]) {
        [self.delegate formController:self valueChangedForIndexPath:indexPath];
    }
}

#pragma mark - ADFormDirectionManagerDelegate

- (BOOL)formDirectionManager:(ADFormDirectionManager *)formDirectionManager canEditCellAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return [cell conformsToProtocol:@protocol(ADFormTextInputTableViewCell)];
}

#pragma mark - ADFormCellConfigurable

- (UITableViewCell<ADFormBoolInputTableViewCell> *)boolInputCellWithConfiguration:(ADFormCellBoolConfiguration *)configuration
                                                                      atIndexPath:(NSIndexPath *)indexPath {
    ADFormSwitchTableViewCell * cell = (ADFormSwitchTableViewCell *)[self _cellWithClass:ADFormSwitchTableViewCell.class forIndexPath:indexPath];
    cell.delegate = self;
    [cell applyConfiguration:(ADFormCellBoolConfiguration *)configuration];
    return cell;
}

- (UITableViewCell<ADFormTextInputTableViewCell> *)textInputCellWithConfiguration:(ADFormCellTextConfiguration *)configuration
                                                                      atIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell<ADFormTextInputTableViewCell> * cell = nil;
    if (configuration.cellType == ADFormTextCellTypeLongText) {
        cell = (ADFormTextViewTableViewCell *)[self _cellWithClass:ADFormTextViewTableViewCell.class forIndexPath:indexPath];
    } else {
        cell = (ADFormTextFieldTableViewCell *)[self _cellWithClass:ADFormTextFieldTableViewCell.class forIndexPath:indexPath];
    }
    cell.delegate = self;
    [cell applyConfiguration:configuration];

    UIView * accessoryView = self.defaultInputAccessoryView;
    if ([self.delegate respondsToSelector:@selector(formController:inputAccessoryViewForIndexPath:)]) {
        accessoryView = [self.delegate formController:self inputAccessoryViewForIndexPath:indexPath];
    }
    cell.inputAccessoryView = accessoryView;
    cell.returnKeyType = [self _returnKeyTypeForIndexPath:indexPath];
    return cell;
}

#pragma mark - Private

- (void)_setupDefaultInputAccessoryView {
    ADTextInputAccessoryView * textInputAccessoryView = [[ADTextInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44.0f)];
    self.defaultInputAccessoryView = textInputAccessoryView;
}

- (void)_addMovingSelectorsToInputAccessoryView:(UIView<ADNavigableButtons> *)inputAccessoryView {
    inputAccessoryView.nextBarButtonItem.target = self;
    inputAccessoryView.nextBarButtonItem.action = @selector(_next:);

    inputAccessoryView.previousBarButtonItem.target = self;
    inputAccessoryView.previousBarButtonItem.action = @selector(_previous:);
}

- (UITableViewCell *)_cellWithClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath {
    if (!_cells[indexPath]) {
        _cells[indexPath] = [(UITableViewCell *)[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    return (UITableViewCell*) _cells[indexPath];
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
