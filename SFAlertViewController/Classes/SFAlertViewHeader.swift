//
//  SFAlertViewHeader.swift
//  SFAlertViewController
//
//  Created by 蔡龙君 on 2019/8/26.
//

import UIKit

internal class SFAlertViewHeader: UIView {
    /// 内容视图
    private lazy var stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = spacing
        $0.axis = .vertical
        return $0
    }(UIStackView(arrangedSubviews: [titleLabel, messageLabel, customContainerView]))
    /// 标题
    private(set) lazy var titleLabel: UILabel = {
        $0.isHidden = true
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    /// 消息
    private(set) lazy var messageLabel: UILabel = {
        $0.isHidden = true
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    /// 自定义的view
    private(set) var customContainerView: UIView = {
        $0.isHidden = true
        $0.backgroundColor = UIColor.white
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    let spacing: CGFloat
    init(spacing: CGFloat) {
        self.spacing = spacing
        super.init(frame: .zero)
        configSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configSubviews() {
        addSubview(stackView)
        backgroundColor = UIColor.white
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: spacing).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: spacing).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -spacing).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing).isActive = true
    }
}

extension SFAlertViewHeader {
    func config(using title: String?, message: String?, customView: UIView?, width: CGFloat) {
        if let title = title {
            titleLabel.text = title
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
        
        if let message = message {
            messageLabel.text = message
            messageLabel.isHidden = false
        } else {
            messageLabel.isHidden = true
        }
        guard let customView = customView else { return }
        customContainerView.isHidden = false
        customContainerView.addSubview(customView)
        let customViewWidth: CGFloat
        let customViewHeight: CGFloat
        /// 如果是使用frame布局
        if customView.frame != CGRect.zero {
            customViewWidth = customView.frame.width
            customViewHeight = customView.frame.height
        } else {
            customViewWidth = width - 2 * spacing
            let customViewSize = customView.systemLayoutSizeFitting(CGSize(width: customViewWidth, height: CGFloat.greatestFiniteMagnitude), withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
            customViewHeight = customViewSize.height
        }
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.widthAnchor.constraint(equalToConstant: customViewWidth).isActive = true
        customView.centerXAnchor.constraint(equalTo: customContainerView.centerXAnchor).isActive = true
        customView.centerYAnchor.constraint(equalTo: customContainerView.centerYAnchor).isActive = true
        customView.heightAnchor.constraint(equalToConstant: customViewHeight).isActive = true
        customContainerView.heightAnchor.constraint(equalToConstant: customViewHeight).isActive = true
    }
}
