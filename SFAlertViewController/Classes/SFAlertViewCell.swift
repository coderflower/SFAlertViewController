//
//  SFAlertViewCell.swift
//  SFAlertViewController
//
//  Created by 蔡龙君 on 2019/8/26.
//

import UIKit

class SFAlertViewCell: UITableViewCell {
    /// 分割线
    private(set) lazy var separatorView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(red: 0.783922, green: 0.780392, blue: 0.8, alpha: 1)
        return $0
    }(UIView())
    
    private lazy var leftButton: UIButton = {
        $0.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1, alpha: 1), for: .selected)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.backgroundColor = UIColor.white
        $0.setTitleColor(UIColor.black.withAlphaComponent(0.25), for: .disabled)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton(type: .custom))
    
    private lazy var rightButton: UIButton = {
        $0.isHidden = true
        $0.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1, alpha: 1), for: .selected)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.backgroundColor = UIColor.white
        $0.setTitleColor(UIColor.black.withAlphaComponent(0.25), for: .disabled)
        $0.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton(type: .custom))
    
    var leftCompletion: (() -> Void)?
    var rightCompletion: (() -> Void)?
    
    /// 内容视图
    private lazy var stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
        return $0
    }(UIStackView(arrangedSubviews: [leftButton, rightButton]))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configSubviews()
    }
}

/// public
extension SFAlertViewCell {
    func config(using leftButtonType: SFAlertViewController.AlertButton, rightButtonType: SFAlertViewController.AlertButton? = nil) {
        
        configButton(leftButton, using: leftButtonType)
        guard let rightButtonType = rightButtonType else {
            separatorView.isHidden = true
            rightButton.isHidden = true
            return
        }
        separatorView.isHidden = false
        configButton(rightButton, using: rightButtonType)
    }
}

/// private
extension SFAlertViewCell {
    
    private func configSubviews() {
        contentView.addSubview(stackView)
        contentView.addSubview(separatorView)
        contentView.backgroundColor = UIColor(red: 0.783922, green: 0.780392, blue: 0.8, alpha: 1)
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.5).isActive = true
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    private func configButton(_ button: UIButton, using type: SFAlertViewController.AlertButton) {
        switch type {
        case .cancel:
            button.isEnabled = true
            button.isSelected = false
        case .disabled:
            button.isEnabled = false
            button.isSelected = false
        case .default:
            button.isEnabled = true
            button.isSelected = false
        case .destructive:
            button.isEnabled = true
            button.isSelected = true
        }
        button.setTitle(type.title, for: .normal)
        button.isHidden = false
    }
    @objc private func leftButtonTapped() {
        leftCompletion?()
    }
    @objc private func rightButtonTapped() {
        rightCompletion?()
    }
}
