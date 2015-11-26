//
//  CTFormTextFieldTableViewCell.m
//  ChicTypes
//
//  Created by Pierre Felgines on 27/04/2015.
//
//

#import "ADFormTextFieldTableViewCell.h"
#import "ADTextFieldFormatter.h"
#import "ADTextField.h"

@interface ADFormTextFieldTableViewCell () <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSMutableArray * _dynamicConstraints;
    UIDatePicker * _datePicker;
    UIPickerView * _pickerView;
    id<ADTextFieldFormatter> _textFieldFormatter;
    NSDateFormatter * _dateFormatter;
    id<ADFormPickerDataSource> _formPickerDataSource;
    ADTextField * _textField;
}

@property (nonatomic) ADFormTextCellType cellType;
@property (nonatomic, strong) UIView * rightView;
@property (nonatomic, strong) UILabel * leftLabel;

- (IBAction)_dateChanged:(UIDatePicker *)sender;
- (IBAction)_textChanged:(UITextField *)textField;
- (void)_startEditingDatePicker;
- (void)_startEditingPickerView;

@end

@implementation ADFormTextFieldTableViewCell

static NSString * kLeftLabelKeyPath = @"_leftLabel.text";

- (void)dealloc {
    [self removeObserver:self forKeyPath:kLeftLabelKeyPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _textField = [[ADTextField alloc] init];
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_textField];
        [_textField addTarget:self action:@selector(_textChanged:) forControlEvents:UIControlEventAllEditingEvents];

        _leftLabel = [[UILabel alloc] init];
        _leftLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_leftLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_leftLabel];


        NSDictionary * views = NSDictionaryOfVariableBindings(_textField);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textField]|" options:0 metrics:nil views:views]];

        self.separatorInset = UIEdgeInsetsMake(0, 15.0f, 0, 0);

        _dynamicConstraints = [NSMutableArray array];

        [self addObserver:self forKeyPath:kLeftLabelKeyPath options:NSKeyValueObservingOptionNew context:NULL];

        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(_dateChanged:) forControlEvents:UIControlEventValueChanged];

        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kLeftLabelKeyPath]) {
        _textField.textAlignment = _leftLabel.text.length > 0 ? NSTextAlignmentRight : NSTextAlignmentLeft;
        [self setNeedsUpdateConstraints]; // update left label visibility
    }
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.contentView removeConstraints:_dynamicConstraints];
    [_dynamicConstraints removeAllObjects];

    if (_rightView) {
        NSDictionary * metrics = @{ @"rightViewWidth": @(_rightView.frame.size.width),
                                    @"rightViewHeight": @(_rightView.frame.size.height) };
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_textField]-[_rightView(rightViewWidth)]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:NSDictionaryOfVariableBindings(_textField, _rightView)]];
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rightView(rightViewHeight)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_textField, _rightView)]];
    } else {
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_textField]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textField)]];
    }

    if (_leftLabel.text.length > 0) {
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_leftLabel]-[_textField]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_leftLabel, _textField)]];
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_leftLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_leftLabel)]];
    } else {
         [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_textField]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textField)]];
    }

    [self.contentView addConstraints:_dynamicConstraints];
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // nothing
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.textField removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    self.textField.inputView = nil;
}

#pragma mark - Setters

- (void)setRightView:(UIView *)rightView {
    [_rightView removeFromSuperview];
    _rightView = rightView;
    _rightView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_rightView];
    [self setNeedsUpdateConstraints];
}

- (void)setCellType:(ADFormTextCellType)cellType {
    _cellType = cellType;
    switch (cellType) {
        case ADFormTextCellTypeEmail: {
            self.textField.keyboardType = UIKeyboardTypeEmailAddress;
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        } break;
        case ADFormTextCellTypePassword: {
            self.textField.secureTextEntry = YES;
        } break;
        case ADFormTextCellTypeName: {
            self.textField.keyboardType = UIKeyboardTypeAlphabet;
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        } break;
        case ADFormTextCellTypePhone: {
            self.textField.keyboardType = UIKeyboardTypePhonePad;
        } break;
        case ADFormTextCellTypeText: {
            self.textField.keyboardType = UIKeyboardTypeAlphabet;
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            self.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        } break;
        case ADFormTextCellTypeNumber: {
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        } break;
        case ADFormTextCellTypeDate: {
            self.textField.inputView = _datePicker;
            _textField.disablePasteAction = YES;
        } break;
        case ADFormTextCellTypePicker: {
            self.textField.inputView = _pickerView;
            _textField.disablePasteAction = YES;
        } break;
        default:
            break;
    }
}

#pragma mark - Getters

- (UITextField *)textField {
    return _textField;
}

#pragma mark - Methods

- (void)applyConfiguration:(ADFormCellConfiguration *)configuration {
    self.textField.placeholder = configuration.placeholder;
    self.leftLabel.text = configuration.title;
    self.cellType = configuration.cellType;
    self.rightView = configuration.rightView;

    self.textField.font = configuration.textFont;
    self.textField.textColor = configuration.textColor;
    self.textField.tintColor = configuration.tintColor;
    self.leftLabel.font = configuration.titleFont;
    self.leftLabel.textColor = configuration.titleColor;

    if (configuration.text.length > 0) {
        self.textField.text = configuration.text;
    }
    _textFieldFormatter = configuration.textFieldFormatter;
    [_textFieldFormatter textFieldValueChanged:self.textField];
    _dateFormatter = configuration.dateFormatter;
    _formPickerDataSource = configuration.formPickerDataSource;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [_formPickerDataSource numberOfComponents];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[_formPickerDataSource optionsForComponent:component] count];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_formPickerDataSource optionsForComponent:component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSMutableArray * selectedIndexes = [NSMutableArray array];
    for (int component = 0; component < _pickerView.numberOfComponents; component++) {
        [selectedIndexes addObject:@([_pickerView selectedRowInComponent:component])];
    }

    if (selectedIndexes.count) {
        NSString * value = [_formPickerDataSource stringFromSelectedIndexes:selectedIndexes];
        if (value.length) {
            self.textField.text = @"";
            [self.textField insertText:value];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    switch (self.cellType) {
        case ADFormTextCellTypeDate: {
            [self _startEditingDatePicker];
        } break;
        case ADFormTextCellTypePicker: {
            [self _startEditingPickerView];
        } break;
        default:
            break; // no op
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_textFieldFormatter) {
        return [_textFieldFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

#pragma mark - Private

- (IBAction)_dateChanged:(UIDatePicker *)sender {
    // Use insertText to simulate touch
    self.textField.text = @"";
    [self.textField insertText:[_dateFormatter stringFromDate:sender.date]];
}

- (IBAction)_textChanged:(UITextField *)textField {
    [_textFieldFormatter textFieldValueChanged:textField];
}

- (void)_startEditingDatePicker {
    if (self.textField.text.length == 0) {
        [self _dateChanged:_datePicker];
    } else {
        NSDate * date = [_dateFormatter dateFromString:self.textField.text];
        _datePicker.date = date;
    }
}

- (void)_startEditingPickerView {
    if (self.textField.text.length == 0) {
        for (int component = 0; component < _pickerView.numberOfComponents; component++) {
            [self pickerView:_pickerView didSelectRow:0 inComponent:component];
        }
    } else {
        NSArray * indexes = [_formPickerDataSource selectedIndexesFromString:self.textField.text];
        [indexes enumerateObjectsUsingBlock:^(NSNumber * indexNumber, NSUInteger idx, BOOL * _Nonnull stop) {
            [_pickerView selectRow:[indexNumber integerValue] inComponent:idx animated:NO];
        }];
    }
}

@end
