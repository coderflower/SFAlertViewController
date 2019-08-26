//
//  Extensions.swift
//  SFAlertViewController
//
//  Created by 蔡龙君 on 2019/8/23.
//

import Foundation

public extension SFAlertViewController {
    /// 按钮样式
    public enum AlertButton {
        case `default`(String)
        case cancel(String)
        case disabled(String)
        case destructive(String)
        var style: UIAlertAction.Style {
            switch self {
            case .default, .disabled:
                return .default
            case .cancel:
                return .cancel
            case .destructive:
                return .destructive
            }
        }
        
        public var title: String {
            switch self {
            case .default(let title):
                return title
            case .cancel(let title):
                return title
            case .disabled(let title):
                return title
            case .destructive(let title):
                return title
            }
        }
    }
}
