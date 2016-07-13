//
//  PlaceholderTextView.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

class PlaceholderTextView: UITextView {
    var placeholder: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    var placeholderColor: UIColor = UIColor.init(red: (199.0/255.0), green: (199.0/255.0), blue: (205.0/255.0), alpha: 1.0) {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: UITextView
    override var text: String! {
        didSet {
            setNeedsDisplay()
        }
    }

    override var attributedText: NSAttributedString! {
        didSet {
            setNeedsDisplay()
        }
    }

    override var contentInset: UIEdgeInsets {
        didSet {
            setNeedsDisplay()
        }
    }

    override var font: UIFont? {
        didSet {
            setNeedsDisplay()
        }
    }

    override var textAlignment: NSTextAlignment {
        didSet {
            setNeedsDisplay()
        }
    }

    override func insertText(text: String) {
        super.insertText(text)
        setNeedsDisplay()
    }

    // MARK: UIView
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(PlaceholderTextView.textChanged(_:)),
                                                         name: UITextViewTextDidChangeNotification,
                                                         object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        guard text.isEmpty && !placeholder.isEmpty else {
            return
        }
        let newRect = placeholderRectForBounds(bounds)
        guard let fontToUse = font == nil ? typingAttributes[NSFontAttributeName] : font else {
            return
        }
        var newStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        newStyle.lineBreakMode = .ByTruncatingTail
        newStyle.alignment = textAlignment
        let stringToDraw: NSString = placeholder
        stringToDraw.drawInRect(newRect,
                                withAttributes: [NSFontAttributeName: fontToUse,
                                    NSParagraphStyleAttributeName: newStyle,
                                    NSForegroundColorAttributeName: placeholderColor])
    }

    // MARK: Private
    @objc private func textChanged(notification: NSNotification) {
        setNeedsDisplay()
    }

    private func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        var rect = UIEdgeInsetsInsetRect(bounds, contentInset)
        guard let style = typingAttributes[NSParagraphStyleAttributeName].flatMap({ $0 as? NSParagraphStyle }) else {
            return rect
        }
        rect.origin.x += style.headIndent
        rect.origin.y += style.firstLineHeadIndent
        return rect
    }
}
