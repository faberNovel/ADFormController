//
//  CTFormTextFieldTableViewCell.m
//  ChicTypes
//
//  Created by Pierre Felgines on 27/04/2015.
//
//

#import "ADFormTextFieldTableViewCell.h"
#import "ADFormCellTextConfiguration.h"
#import "ADPickerViewTextFieldBinding.h"

#import <ADFormController/ADFormController-Swift.h>

@interface ADFormTextFieldTableViewCell () <UITextFieldDelegate> {
    NSMutableArray * _dynamicConstraints;
    id<TextFieldFormatter> _textFieldFormatter;
    FormTextField * _textField;
    DatePickerTextFieldBinging * _datePickerBinding;
    ADPickerViewTextFieldBinding * _pickerViewBinding;
}

@property (nonatomic) ADFormTextCellType cellType;
@property (nonatomic, strong) UIView * rightView;
@property (nonatomic, strong) UILabel * leftLabel;

- (IBAction)_textChanged:(UITextField *)textField;

@end

@implementation ADFormTextFieldTableViewCell

@synthesize delegate = _delegate;
@synthesize inputAccessoryView = _inputAccessoryView;

static NSString * kLeftLabelKeyPath = @"_leftLabel.text";

- (void)dealloc {
    [self removeObserver:self forKeyPath:kLeftLabelKeyPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _textField = [[FormTextField alloc] init];
        _textField.delegate = self;
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

        _datePickerBinding = [[DatePickerTextFieldBinging alloc] initWithTextField:self.textField];
        _pickerViewBinding = [[ADPickerViewTextFieldBinding alloc] initWithTextField:self.textField];
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

    self.textField.secureTextEntry = NO;
    switch (cellType) {
        case ADFormTextCellTypeEmail: {
            self.textField.keyboardType = UIKeyboardTypeEmailAddress;
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        } break;
        case ADFormTextCellTypePassword: {
            self.textField.secureTextEntry = YES;
        } break;
        case ADFormTextCellTypePasswordNumber: {
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
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
            self.textField.inputView = _datePickerBinding.datePicker;
            _textField.disablePasteAction = YES;
        } break;
        case ADFormTextCellTypePicker: {
            self.textField.inputView = _pickerViewBinding.pickerView;
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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    switch (self.cellType) {
        case ADFormTextCellTypeDate: {
            [_datePickerBinding startEditing];
        } break;
        case ADFormTextCellTypePicker: {
            [_pickerViewBinding startEditing];
        } break;
        default:
            break; // no op
    }

    if ([self.delegate respondsToSelector:@selector(textInputTableViewCellDidBeginEditing:)]) {
        [self.delegate textInputTableViewCellDidBeginEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_textFieldFormatter) {
        return [_textFieldFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textInputTableViewCellShouldReturn:)]) {
        return [self.delegate textInputTableViewCellShouldReturn:self];
    }
    return YES;
}

#pragma mark - ADFormTextInputTableViewCell

- (void)applyConfiguration:(ADFormCellTextConfiguration *)configuration {
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
    _datePickerBinding.dateFormatter = configuration.dateFormatter;
    _pickerViewBinding.formPickerDataSource = configuration.formPickerDataSource;
}

- (void)beginEditing {
    [_textField becomeFirstResponder];
}

- (NSString *)textContent {
    return _textField.text;
}

- (void)setTextContent:(NSString *)textContent {
    _textField.text = textContent;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType {
    _textField.returnKeyType = returnKeyType;
}

- (UIReturnKeyType)returnKeyType {
    return _textField.returnKeyType;
}

#pragma mark - Private

- (IBAction)_textChanged:(UITextField *)textField {
    [_textFieldFormatter textFieldValueChanged:textField];
    if ([self.delegate respondsToSelector:@selector(textInputTableViewCellValueChanged:)]) {
        [self.delegate textInputTableViewCellValueChanged:self];
    }
}

@end
