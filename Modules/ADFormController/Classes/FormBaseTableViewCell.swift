//
//  FormBaseTableViewCell.swift
//  ADFormController
//
//  Created by Pierre Felgines on 13/04/2018.
//

import Foundation
import UIKit

protocol FormTableViewCellActionHandler: class {
    func handleLeftViewAction(from cell: FormBaseTableViewCell)
    func handleRightViewAction(from cell: FormBaseTableViewCell)
}

class FormBaseTableViewCell: UITableViewCell {

    private lazy var stackView: UIStackView = self.createStackView()
    private lazy var rightContainerView: UIView = self.createAccessoryContainerView()
    private lazy var leftContainerView: UIView = self.createAccessoryContainerView()
    private lazy var rightContainerTapGesture: UITapGestureRecognizer = self.createRightViewTapGestureRecognizer()
    private lazy var leftContainerTapGesture: UITapGestureRecognizer = self.createLeftViewTapGestureRecognizer()
    var hideRightViewWhenEditing = false

    weak var actionHandler: FormTableViewCellActionHandler?

    var rightView: UIView? {
        willSet {
            guard let rightView = self.rightView else {
                return
            }
            rightView.removeFromSuperview()
        }
        didSet {
            rightContainerView.isHidden = self.rightView == nil
            guard let rightView = self.rightView else {
                return
            }
            rightView.translatesAutoresizingMaskIntoConstraints = false
            rightContainerView.addSubview(rightView)
            NSLayoutConstraint.activate([
                rightView.trailingAnchor.constraint(equalTo: rightContainerView.trailingAnchor),
                rightView.leadingAnchor.constraint(equalTo: rightContainerView.leadingAnchor),
                rightView.topAnchor.constraint(equalTo: rightContainerView.topAnchor),
                rightView.bottomAnchor.constraint(equalTo: rightContainerView.bottomAnchor)
            ])
        }
    }

    var leftView: UIView? {
        willSet {
            guard let leftView = self.leftView else {
                return
            }
            leftView.removeFromSuperview()
        }
        didSet {
            leftContainerView.isHidden = self.leftView == nil
            guard let leftView = self.leftView else {
                return
            }
            leftView.translatesAutoresizingMaskIntoConstraints = false
            leftContainerView.addSubview(leftView)
            NSLayoutConstraint.activate([
                leftView.trailingAnchor.constraint(equalTo: leftContainerView.trailingAnchor),
                leftView.leadingAnchor.constraint(equalTo: leftContainerView.leadingAnchor),
                leftView.topAnchor.constraint(equalTo: leftContainerView.topAnchor),
                leftView.bottomAnchor.constraint(equalTo: leftContainerView.bottomAnchor)
            ])
        }
    }

    var defaultContentInset: UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0)
    }

    // MARK: - Lifecycle

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Public

    func insertSubviewInStackView(_ subview: UIView) {
        stackView.insertArrangedSubview(
            subview,
            at: stackView.arrangedSubviews.count - 1 // before rightContainerView
        )
    }

    func updateStackViewConstraints(with insets: UIEdgeInsets) {
        stackView.removeFromSuperview() // clear constraints
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -insets.right),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: insets.left),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets.top),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets.bottom)
        ])
    }

    // MARK: - Actions

    @objc private func tapGestureAction(_ sender: UITapGestureRecognizer) {
        switch sender {
        case leftContainerTapGesture:
            actionHandler?.handleLeftViewAction(from: self)
        case rightContainerTapGesture:
            actionHandler?.handleRightViewAction(from: self)
        default:
            break
        }
    }


    // MARK: - Private

    private func setup() {
        selectionStyle = .none
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 0)
        updateStackViewConstraints(with: defaultContentInset)
        stackView.addArrangedSubview(leftContainerView)
        stackView.addArrangedSubview(rightContainerView)
        leftContainerView.addGestureRecognizer(leftContainerTapGesture)
        rightContainerView.addGestureRecognizer(rightContainerTapGesture)
    }

    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8.0
        return stackView
    }

    private func createAccessoryContainerView() -> UIView {
        let view = UIView()
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        return view
    }

    private func createLeftViewTapGestureRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
    }

    private func createRightViewTapGestureRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
    }
}
