//
//  ADFormSwitchTableViewCell.m
//  FormDemo
//
//  Created by Roland Borgese on 01/06/2016.
//
//

#import "ADFormSwitchTableViewCell.h"
#import "ADFormCellBoolConfiguration.h"

static const CGFloat kMargin = 15.f;

@interface ADFormSwitchTableViewCell ()
@property (nonatomic, readonly, strong) UISwitch * switchView;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> * dynamicConstraints;
@property (nonatomic, strong) UIView * rightView;
@property (nonatomic, strong) UILabel * leftLabel;

- (void)_switchValueChanged:(id)sender;
- (void)_setupStaticConstraints;
@end

@implementation ADFormSwitchTableViewCell

@synthesize delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _switchView = [[UISwitch alloc] init];
        _switchView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_switchView];
        [_switchView addTarget:self action:@selector(_switchValueChanged:) forControlEvents:UIControlEventValueChanged];

        _leftLabel = [[UILabel alloc] init];
        _leftLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _leftLabel.numberOfLines = 0;
        [self.contentView addSubview:_leftLabel];

        self.separatorInset = UIEdgeInsetsMake(0, kMargin, 0, 0);

        [self _setupStaticConstraints];
        _dynamicConstraints = [NSMutableArray array];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.contentView removeConstraints:_dynamicConstraints];
    [_dynamicConstraints removeAllObjects];

    NSDictionary * metrics = @{@"rightViewWidth" : @(_rightView.frame.size.width),
                               @"rightViewHeight" : @(_rightView.frame.size.height),
                               @"margin" : @(kMargin)};

    if (_rightView) {
        NSDictionary * views = NSDictionaryOfVariableBindings(_switchView, _rightView);
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_switchView]-[_rightView(rightViewWidth)]-0-|"
                                                                                         options:NSLayoutFormatAlignAllCenterY
                                                                                         metrics:metrics
                                                                                           views:views]];
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rightView(rightViewHeight)]"
                                                                                         options:0
                                                                                         metrics:metrics
                                                                                           views:views]];
    } else {
        NSDictionary * views = NSDictionaryOfVariableBindings(_switchView);
        [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_switchView]-margin-|"
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

#pragma mark - ADFormBoolInputTableViewCell

- (void)setBoolContent:(BOOL)boolContent {
    self.switchView.on = boolContent;
}

- (BOOL)boolContent {
    return self.switchView.isOn;
}

- (void)applyConfiguration:(ADFormCellBoolConfiguration *)configuration {
    self.leftLabel.text = configuration.title;
    self.rightView = configuration.rightView;
    self.leftLabel.font = configuration.titleFont;
    self.leftLabel.textColor = configuration.titleColor;
    self.switchView.on = configuration.boolValue;
    self.switchView.onTintColor = configuration.onTintColor;
    self.switchView.tintColor = configuration.tintColor;
    //hack to have a nice background color for off position
    self.switchView.layer.cornerRadius = 16.0f;
    self.switchView.backgroundColor = configuration.tintColor;
}

#pragma mark - Private

- (void)_setupStaticConstraints {
    NSDictionary * views = NSDictionaryOfVariableBindings(_switchView, _leftLabel);
    NSDictionary * metrics = @{@"margin" : @(kMargin)};
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_switchView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_leftLabel]-margin-[_switchView]"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_leftLabel(>=42)]|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:views]];
}

- (void)_switchValueChanged:(id)sender {
    [self.delegate boolInputTableViewCellDidChangeValue:self];
}

@end
