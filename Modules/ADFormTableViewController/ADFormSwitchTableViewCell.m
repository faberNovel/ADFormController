//
//  ADFormSwitchTableViewCell.m
//  FormDemo
//
//  Created by Roland Borgese on 01/06/2016.
//
//

#import "ADFormSwitchTableViewCell.h"
#import "ADFormCellConfiguration.h"

static NSString * const kStringYes = @"YES";
static NSString * const kStringNo = @"NO";
static const CGFloat kMargin = 15.f;

@interface ADFormSwitchTableViewCell ()
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> * dynamicConstraints;
@property (nonatomic, strong) UIView * rightView;
@property (nonatomic, strong) UILabel * leftLabel;

- (void)_switchValueChanged:(id)sender;
@end

@implementation ADFormSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _switchView = [[UISwitch alloc] init];
        _switchView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_switchView];
        [_switchView addTarget:self action:@selector(_switchValueChanged:) forControlEvents:UIControlEventValueChanged];

        _leftLabel = [[UILabel alloc] init];
        _leftLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_leftLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_leftLabel];


        NSDictionary * views = NSDictionaryOfVariableBindings(_switchView);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_switchView]|" options:0 metrics:nil views:views]];

        self.separatorInset = UIEdgeInsetsMake(0, kMargin, 0, 0);

        _dynamicConstraints = [NSMutableArray array];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.contentView removeConstraints:_dynamicConstraints];
    [_dynamicConstraints removeAllObjects];

    NSDictionary * views = NSDictionaryOfVariableBindings(_switchView, _leftLabel, _rightView);
    NSDictionary * metrics = @{@"rightViewWidth" : @(_rightView.frame.size.width),
                               @"rightViewHeight" : @(_rightView.frame.size.height),
                               @"margin" : @(kMargin)};

    if (_rightView) {
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_switchView]-[_rightView(rightViewWidth)]-0-|"
                                                                                         options:NSLayoutFormatAlignAllCenterY
                                                                                         metrics:metrics
                                                                                           views:views]];
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rightView(rightViewHeight)]"
                                                                                         options:0
                                                                                         metrics:metrics
                                                                                           views:views]];
    } else {
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_switchView]-margin-|"
                                                                                         options:0
                                                                                         metrics:metrics
                                                                                           views:views]];
    }

    if (_leftLabel.text.length > 0) {
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_leftLabel]-[_switchView]"
                                                                                         options:0
                                                                                         metrics:metrics
                                                                                           views:views]];
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_leftLabel]|"
                                                                                         options:0
                                                                                         metrics:metrics
                                                                                           views:views]];
    } else {
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_switchView]"
                                                                                         options:0
                                                                                         metrics:metrics
                                                                                           views:views]];
    }

    [self.contentView addConstraints:_dynamicConstraints];
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

#pragma mark - Setters

- (void)setRightView:(UIView *)rightView {
    [_rightView removeFromSuperview];
    _rightView = rightView;
    _rightView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_rightView];
    [self setNeedsUpdateConstraints];
}

#pragma mark - ADFormTextInputTableViewCell

- (id <ADFormTextInputTableViewCellDelegate>)delegate {
    return nil;
}

- (void)setDelegate:(id <ADFormTextInputTableViewCellDelegate>)delegate {/* no delegate */}

- (UIView *)inputAccessoryView {
    return nil;
}

- (void)setInputAccessoryView:(UIView *)inputAccessoryView {/* no inputAccessoryView */}

- (UIReturnKeyType)returnKeyType {
    return UIReturnKeyDefault;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType {/* no returnKey */}

- (NSString *)textContent {
    return self.switchView.isOn ? kStringYes : kStringNo;
}

- (void)setTextContent:(NSString *)textContent {
    self.switchView.on = [textContent isEqualToString:kStringYes];
}

- (void)applyConfiguration:(ADFormCellConfiguration *)configuration {
    self.leftLabel.text = configuration.title;
    self.rightView = configuration.rightView;

    self.leftLabel.font = configuration.titleFont;
    self.leftLabel.textColor = configuration.titleColor;

    if (configuration.text.length > 0) {
        [self setTextContent:configuration.text];
    }
}

- (void)beginEditing {
    [self.switchView becomeFirstResponder];
}

#pragma mark - Private

- (void)_switchValueChanged:(id)sender {
    //TODO:
}

@end
