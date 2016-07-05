//
//  ADPlaceholderTextView.m
//  Nexity
//
//  Created by Pierre Felgines on 13/10/2015.
//
//

#import "ADPlaceholderTextView.h"

@interface ADPlaceholderTextView () {

}

@end

@implementation ADPlaceholderTextView

CGFloat const ADPlaceholderTextChangedAnimationDuration = 0.25f;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.placeholder = @"";
        // iOS default placeholder color
        self.placeholderColor = [UIColor colorWithRed:(199.0f / 255.0f) green:(199.0f / 255.0f) blue:(205.0f / 255.0f) alpha:1.0f];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_textChanged:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Setters

- (void)setText:(NSString *)string {
    [super setText:string];
    [self setNeedsDisplay];
}

- (void)insertText:(NSString *)string {
    [super insertText:string];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    [self setNeedsDisplay];
}

#pragma mark - UIView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.text.length == 0 && self.placeholder.length > 0) {
        CGRect rect = [self _placeholderRectForBounds:self.bounds];
        UIFont * font = self.font ? self.font : self.typingAttributes[NSFontAttributeName];

        NSMutableParagraphStyle * style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        style.alignment = self.textAlignment;

        [self.placeholder drawInRect:rect withAttributes:@{ NSFontAttributeName: font,
                                                            NSParagraphStyleAttributeName: style,
                                                            NSForegroundColorAttributeName: self.placeholderColor}];
    }
}

#pragma mark - Private

- (void)_textChanged:(NSNotification *)notification {
    [self setNeedsDisplay];
}

- (CGRect)_placeholderRectForBounds:(CGRect)bounds {
    CGRect rect = UIEdgeInsetsInsetRect(bounds, self.contentInset);
    if (self.typingAttributes) {
        NSParagraphStyle * style = self.typingAttributes[NSParagraphStyleAttributeName];
        if (style) {
            rect.origin.x += style.headIndent;
            rect.origin.y += style.firstLineHeadIndent;
        }
    }
    return rect;
}

@end
