//
//  FormRightAccessoryView.swift
//  FormDemo
//
//  Created by Gaétan Zanella on 07/08/2018.
//

import Foundation

class FormPickerRightAccessoryView: UIView {

    private lazy var imageView: UIImageView = self.createImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Private

    private func setup() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.ad_pinToSuperview()
    }

    private func createImageView() -> UIImageView {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "FormPickerIcon"))
        imageView.contentMode = .center
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }
}
