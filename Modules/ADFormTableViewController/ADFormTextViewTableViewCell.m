//
//  ADFormTextViewTableViewCell.m
//  Nexity
//
//  Created by Pierre Felgines on 13/10/2015.
//
//

#import "ADFormTextViewTableViewCell.h"
#import "ADPlaceholderTextView.h"
#import "ADFormCellTextConfiguration.h"

@interface ADFormTextViewTableViewCell () <UITextViewDelegate> {
    UILabel * _titleLabel;
    NSMutableArray * _dynamicConstraints;
    ADPlaceholderTextView * _placeholderTextView;
}

@end

@implementation ADFormTextViewTableViewCell

@synthesize delegate = _delegate;

static NSString * kTitleLabelKeyPath = @"_titleLabel.text";

- (void)dealloc {
    [self removeObserver:self forKeyPath:kTitleLabelKeyPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _placeholderTextView = [[ADPlaceholderTextView alloc] init];
        _placeholderTextView.delegate = self;
        _placeholderTextView.textContainerInset = UIEdgeInsetsZero;
        _placeholderTextView.textContainer.lineFragmentPadding = 0;
        _placeholderTextView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_placeholderTextView];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.contentView addSubview:_titleLabel];

        NSDictionary * views = NSDictionaryOfVariableBindings(_placeholderTextView);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_placeholderTextView]-15-|" options:0 metrics:nil views:views]];

        self.separatorInset = UIEdgeInsetsMake(0, 15.0f, 0, 0);

        _dynamicConstraints = [NSMutableArray array];

        [self addObserver:self forKeyPath:kTitleLabelKeyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kTitleLabelKeyPath]) {
        [self setNeedsUpdateConstraints]; // update title label visibility
    }
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.contentView removeConstraints:_dynamicConstraints];
    [_dynamicConstraints removeAllObjects];


    if (_titleLabel.text.length > 0) {
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_titleLabel]-[_placeholderTextView]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel, _placeholderTextView)]];
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_titleLabel]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    } else {
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_placeholderTextView]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_placeholderTextView)]];
    }

    [self.contentView addConstraints:_dynamicConstraints];
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // nothing
}

#pragma mark - Getters

- (UITextView *)textView {
    return _placeholderTextView;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textInputTableViewCellDidBeginEditing:)]) {
        [self.delegate textInputTableViewCellDidBeginEditing:self];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textInputTableViewCellValueChanged:)]) {
        [self.delegate textInputTableViewCellValueChanged:self];
    }
}

#pragma mark - ADFormTextInputTableViewCell

- (void)applyConfiguration:(ADFormCellTextConfiguration *)configuration {
    _titleLabel.text = configuration.title;

    _titleLabel.font = configuration.titleFont;
    _titleLabel.textColor = configuration.titleColor;

    _placeholderTextView.font = configuration.textFont;
    _placeholderTextView.textColor = configuration.textColor;
    _placeholderTextView.tintColor = configuration.tintColor;

    if (configuration.text.length > 0) {
        _placeholderTextView.text = configuration.text;
    }
    _placeholderTextView.placeholder = configuration.placeholder;
}

- (void)beginEditing {
    [_placeholderTextView becomeFirstResponder];
}

- (NSString *)textContent {
    return _placeholderTextView.text;
}

- (void)setTextContent:(NSString *)textContent {
    _placeholderTextView.text = textContent;
}

- (void)setInputAccessoryView:(UIView *)inputAccessoryView {
    _placeholderTextView.inputAccessoryView = inputAccessoryView;
}

- (UIView *)inputAccessoryView {
    return _placeholderTextView.inputAccessoryView;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType {
    // no op
}

- (UIReturnKeyType)returnKeyType {
    return _placeholderTextView.returnKeyType;
}

@end
