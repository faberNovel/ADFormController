//
//  PlaceholderTextView.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

class PlaceholderTextView : UITextView {

    var placeholder = "" {
        didSet {
            setNeedsDisplay()
        }
    }

    var placeholderColor = UIColor(red: (199.0/255.0), green: (199.0/255.0), blue: (205.0/255.0), alpha: 1.0) {
        didSet {
            setNeedsDisplay()
        }
    }

    //MARK: - UITextView

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

    override func insertText(_ text: String) {
        super.insertText(text)
        setNeedsDisplay()
    }

    //MARK: - UIView

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(PlaceholderTextView.textChanged(_:)),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard text.isEmpty && !placeholder.isEmpty else {
            return
        }
        let newRect = placeholderRectForBounds(bounds)
        guard let fontToUse = font == nil ? typingAttributes[NSAttributedString.Key.font] : font else {
            return
        }
        guard let newStyle = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle else {
            return
        }
        newStyle.lineBreakMode = .byTruncatingTail
        newStyle.alignment = textAlignment
        let stringToDraw: NSString = placeholder as NSString
        let attributes : [NSAttributedString.Key: Any] = [
            .font: fontToUse,
            .paragraphStyle: newStyle,
            .foregroundColor: placeholderColor
        ]
        stringToDraw.draw(in: newRect, withAttributes: attributes)
    }

    //MARK: - Private

    @objc private func textChanged(_ notification: Notification) {
        setNeedsDisplay()
    }

    private func placeholderRectForBounds(_ bounds: CGRect) -> CGRect {
        var rect = bounds.inset(by: contentInset)
        guard let style = typingAttributes[NSAttributedString.Key.paragraphStyle].flatMap({ $0 as? NSParagraphStyle }) else {
            return rect
        }
        rect.origin.x += style.headIndent
        rect.origin.y += style.firstLineHeadIndent
        return rect
    }
}
