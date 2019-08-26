//
//  SFAlertViewController.swift
//  SFAlertViewController
//
//  Created by 蔡龙君 on 2019/8/23.
//

import UIKit
extension UIAlertController {
    
}
public class SFAlertViewController: UIViewController {
    private let spacing: CGFloat = 10
    private let maxHeight = UIScreen.main.bounds.height - 180
    /// 显示样式
    public typealias Style = UIAlertController.Style
    
    /// 内容视图
    private lazy var backgroundView: UIView = {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alpha = 0
        $0.addGestureRecognizer(singleTap)
        return $0
    }(UIView())
    
    /// 点击手势
    private lazy var singleTap: UITapGestureRecognizer = {
        $0.isEnabled = backgoundTapDismissEnable
        return $0
    }(UITapGestureRecognizer(target: self, action: #selector(singleTap(sender:))))
    
    /// 背景点击隐藏是否启用(默认为false)
    public var backgoundTapDismissEnable: Bool = true {
        didSet {
            self.singleTap.isEnabled = backgoundTapDismissEnable
        }
    }
    /// 内容视图
    private lazy var containerView: UIView = {
        $0.backgroundColor = UIColor.white
        $0.alpha = 0
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    /// 内容视图
    private lazy var contentView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = spacing
        $0.axis = .vertical
        return $0
    }(UIStackView(arrangedSubviews: [header]))
    
    private lazy var header: SFAlertViewHeader = {
        $0.backgroundColor = UIColor.white
        $0.isHidden = true
        return $0
    }(SFAlertViewHeader(spacing: spacing))
    /// 自定义的view
    private var customView: UIView?
    /// 自定义view的高度
    private var headerHeight: CGFloat = 0
    
    /// 行高
    private var rowHeight: CGFloat = 57
    /// 是否需要特殊处理取消按钮
    private var shouldHandleCancel: Bool = false
    /// actionSheet时需要增加到额外高度,(cancelButton的高度 + 间距)
    private var extraHeight: CGFloat {
        return shouldHandleCancel ? (rowHeight + spacing) : 0
    }
    /// 按钮view
    private lazy var buttonsView: UITableView = {
        $0.isScrollEnabled = false
        $0.delegate = self
        $0.dataSource = self
        $0.separatorInset = UIEdgeInsets.zero
        $0.separatorStyle = .none
        $0.register(SFAlertViewCell.self, forCellReuseIdentifier: "SFAlertViewCell")
        return $0
    }(UITableView(frame: .zero, style: .plain))
    /// 需要显示的按钮
    private var buttons: [AlertButton] = []
    
    /// cancelButton
    private lazy var cancelButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 15
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.backgroundColor = UIColor.white
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton(type: .custom))
   
    /// 最大的宽度
    private let maxAlertWidth: CGFloat = 270
    /// 安全区域距离底部
    private lazy var safeAreaInsetsBottom: CGFloat = {
        if #available(iOS 11.0, *) {
            return (UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.bottom ?? 0) + 10
        } else {
            return 10
        }
    }()
    private var columns: Int = 0
    private var maxWidth: CGFloat {
        return preferredStyle == .alert ? maxAlertWidth : (UIScreen.main.bounds.width - sheetInsets.left - sheetInsets.right)
    }
    
    private lazy var sheetInsets = UIEdgeInsets(top: 20, left: 8, bottom: safeAreaInsetsBottom, right: 8)
    private var containerViewBottomConstriant: NSLayoutConstraint?
    
    let alertTitle: String?
    let message: String?
    let preferredStyle: Style
    private var completion: ((Int, AlertButton?) -> Void)?
    public init(title: String? = nil,
                message: String? = nil,
                customView: UIView? = nil,
                buttons: [AlertButton],
                preferredStyle: Style = .alert,
                completion: ((Int, AlertButton?) -> Void)?) {
        /// 只允许添加一个cancel类型的按钮
        guard buttons.filter({$0.style == .cancel}).count <= 1 else {
            fatalError("只允许添加一个cancel类型的按钮")
        }
        self.alertTitle = title
        self.message = message
        self.customView = customView
        self.buttons = buttons
        self.preferredStyle = preferredStyle
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .coverVertical
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configSubviews()
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        willShowAnimation()
    }
    
    private func willShowAnimation() {
        switch preferredStyle {
        case .actionSheet:
            containerViewBottomConstriant?.constant = containerView.bounds.height + extraHeight
            self.view.layoutIfNeeded()
            containerViewBottomConstriant?.constant = -(safeAreaInsetsBottom + extraHeight)
            UIView.animate(withDuration: 0.25, animations: {
                self.containerView.alpha = 1
                self.backgroundView.alpha = 1
                self.view.layoutIfNeeded()
            })
        default:
            self.containerView.alpha = 1
            self.backgroundView.alpha = 1
        }
    }
}

extension SFAlertViewController {
    
   public static func show(in viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController,
                     title: String? = nil,
                     message: String?,
                     customView: UIView? = nil,
                     buttons:[AlertButton] = [],
                     preferredStyle: Style = .alert,
                     completion: ((Int, AlertButton?) -> Void)? = nil) {
        let alertController = SFAlertViewController(title: title,
                                                    message: message,
                                                    customView: customView,
                                                    buttons: buttons,
                                                    preferredStyle: preferredStyle,
                                                    completion: completion)
        
        DispatchQueue.main.async(execute: {
            viewController?.present(alertController, animated: false, completion: nil)
        })
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        switch preferredStyle {
        case .alert:
            UIView.animate(withDuration: 0.25, animations: {
                self.containerView.alpha = 0
                self.backgroundView.alpha = 0
            }) { (_) in
                super.dismiss(animated: false, completion: completion)
            }
        default:
            containerViewBottomConstriant?.constant = containerView.bounds.height
            UIView.animate(withDuration: 0.25, animations: {
                self.backgroundView.alpha = 0
                self.view.layoutIfNeeded()
            }) { (_) in
                super.dismiss(animated: false, completion: completion)
            }
        }
    }
}


extension SFAlertViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return columns
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SFAlertViewCell") as? SFAlertViewCell else {
            fatalError()
        }
        let buttonType = buttons[indexPath.row]
        cell.leftCompletion = { [weak self] in
            self?.tappedButtonAtIndex(indexPath.row, buttonType: buttonType)
        }
        if preferredStyle == .alert, buttons.count == 2 {
            let rightButtonType = buttons[indexPath.row + 1]
            cell.config(using: buttonType, rightButtonType: rightButtonType)
            cell.rightCompletion = { [weak self] in
                self?.tappedButtonAtIndex(indexPath.row + 1, buttonType: rightButtonType)
            }
        } else {
            cell.config(using: buttonType)
            cell.rightCompletion = nil
        }
        return cell
    }
}

extension SFAlertViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}

/// private
private extension SFAlertViewController {
    private func configSubviews() {
        configBackgroundView()
        configContainerView()
    }
    
    private func configBackgroundView() {
        view.addSubview(backgroundView)
        /// 背景视图布局
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    private func configContainerView() {
        view.addSubview(containerView)
        /// containerView布局
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
        if preferredStyle == .alert {
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        } else {
            containerViewBottomConstriant = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -sheetInsets.bottom)
            containerViewBottomConstriant?.isActive = true
        }
        
        configContentView()
        
    }
    
    private func configContentView() {
        containerView.addSubview(contentView)
        let shouldConfigHeader = (alertTitle != nil || message != nil || customView != nil)
        /// contentView布局
        contentView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: shouldConfigHeader ? spacing : 0).isActive = true
        contentView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: buttons.isEmpty ? -spacing  : 0).isActive = true
        if shouldConfigHeader {
            configHeader()
        }
        configButtonsView()
    }
    
    private func configHeader() {
        header.config(using: alertTitle, message: message, customView: customView, width: maxWidth)
        /// 计算高度
        let customViewSize = header.systemLayoutSizeFitting(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        headerHeight = customViewSize.height
        header.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true
        header.isHidden = false
        
    }
    
    private func configButtonsView() {
        guard !buttons.isEmpty else { return }
        /// 将cancel类型放到最后
        if buttons.contains(where: {$0.style == .cancel}),
            let index = buttons.firstIndex(where: {$0.style == .cancel}) {
            buttons.swapAt(index, buttons.count - 1)
        }
        buttonsView.isHidden = false
        
        contentView.addArrangedSubview(buttonsView)
        
        /// 计算按钮view的高度
        var buttonsHeight = calculateButtonsViewHeight()
        ///
        var totalHeight = buttonsHeight + headerHeight
        /// actionSheet情况下需要将cancel特殊处理
        if shouldHandleCancel {
            /// 展示底部的footer
            view.addSubview(cancelButton)
            cancelButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10).isActive = true
            cancelButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
            cancelButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
            cancelButton.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
            totalHeight += extraHeight
        }
        
        /// 判断高度是否超出限制
        if totalHeight > maxHeight {
            /// 缩小tableView高度
            buttonsHeight -= (totalHeight - maxHeight)
            buttonsView.isScrollEnabled = true
        }
        buttonsView.heightAnchor.constraint(equalToConstant: buttonsHeight).isActive = true
    }
    /// 计算按钮view高度
    private func calculateButtonsViewHeight() -> CGFloat {
        guard !buttons.isEmpty else { return 0 }
        /// 判断是alert 还是actionSheet
        switch preferredStyle {
        case .alert:
            /// 如果是alert, 并且只有两个Action, 那就1行显示两个按钮
            if buttons.count == 2 {
                columns = 1
                rowHeight = 44
            } else {
                columns = buttons.count
            }
        case .actionSheet:
            /// 判断是否包含cancel,包含则将cancel单独出来
            if buttons.contains(where: {$0.style == .cancel}) {
                columns = buttons.count - 1
                shouldHandleCancel = true
                cancelButton.setTitle(buttons.last?.title, for: .normal)
            } else {
                columns = buttons.count
            }
        }
        return rowHeight * CGFloat(columns)
    }
    /// 背景点击
    @objc private func singleTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped() {
        tappedButtonAtIndex(buttons.count - 1, buttonType: buttons.last)
    }
    
    private func tappedButtonAtIndex(_ index: Int, buttonType: SFAlertViewController.AlertButton?) {
        dismiss(animated: false)
        completion?(index, buttonType)
    }
}
