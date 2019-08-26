//
//  AutoLayoutView.swift
//  SFAlertViewController_Example
//
//  Created by 蔡龙君 on 2019/8/25.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class AutoLayoutView: UIView {

    private lazy var titleLabel: UILabel = {
        let temLabel = UILabel()
        temLabel.text = "文本"
        temLabel.backgroundColor = UIColor.red
        temLabel.textColor = UIColor.white
        temLabel.textAlignment = .center
        return temLabel
    }()
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        configView()
        configLocation()
    }
    
    private func configView() {
        addSubview(titleLabel)
    }
    
    private func configLocation() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
