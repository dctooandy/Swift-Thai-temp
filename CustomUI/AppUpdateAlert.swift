//
//  AppUpdateAlert.swift
//  betlead
//
//  Created by Victor on 2019/9/17.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import Foundation

class AppUpdateAlert: PopupBottomSheet {
    
    typealias DoneHandler = (Bool) -> ()
    var doneHandler: DoneHandler?
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.font = Fonts.pingFangTCRegular(16)
        label.textColor = .white
        label.text = "版本更新".LocalizedString
        label.textAlignment = .center
        return label
    }()
    private lazy var messageLabel: UILabel = {
        let lb = UILabel()
        lb.font = Fonts.pingFangTCRegular(lb.font.pointSize)
        lb.textAlignment = .center
        lb.textColor = .black
        lb.numberOfLines = 0
        return lb
    }()
    private lazy var confirmButton: OKButton = {
        let btn = OKButton()
        btn.setTitle("更新".LocalizedString, for: .normal)
        btn.titleLabel?.font = Fonts.pingFangTCRegular(16)
        btn.addTarget(self, action: #selector(okButtonPressed(_:)), for: .touchUpInside)
        return btn
    }()

    private lazy var cancelButton: CancelButton = {
        let btn = CancelButton()
        btn.setTitle("拒絕".LocalizedString, for: .normal)
        btn.titleLabel?.font = Fonts.pingFangTCRegular(16)
        btn.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
        return btn
    }()
    var downloadUrl: String = ""
    
    init(_ parameters: Any? = nil, _ done: DoneHandler?) {
        super.init()
        isAddDismissGesture(false)
        disablePanGesture()
        guard let appVersionDto = parameters as? ThaiAppVersionDto else { return }
        doneHandler = done
        setup(data: appVersionDto)
    }
    
    private func setup(data: ThaiAppVersionDto) {
        downloadUrl = data.Link
        messageLabel.text = "版本號".LocalizedString + (data.VersionDisplay ?? "")
//            .replacingOccurrences(of: "\\n", with: "\n")
        if data.Update == 2 {
            cancelButton.isHidden = true
            titleLabel.text = "APP有新版本，請立即更新".LocalizedString
        }else
        {
            cancelButton.isHidden = false
            titleLabel.text = "APP有新版本，是否更新?".LocalizedString
        }
    }
    
    override func setupViews() {
        super.setupViews()
        dismissButton.isHidden = true
        setupUI()
    }
    
    func setupUI() {
        defaultContainer.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        let titleView = GradientView(type: .mainSegment)
        defaultContainer.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(height(56/818))
        }
        
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        let msgContentView = UIView()
        defaultContainer.addSubview(msgContentView)
        msgContentView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        defaultContainer.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        let stackView = UIStackView(arrangedSubviews: [confirmButton, cancelButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        defaultContainer.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(msgContentView.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(height(40/818))
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func okButtonPressed(_ sender: UIButton) {
        // go app down load web
        doneHandler?(true)
        guard let url = URL(string: downloadUrl) else { return }
        UIApplication.shared.canOpenURL(url)
        UIApplication.shared.open(url)
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func cancelButtonPressed(_ sender: UIButton) {
        doneHandler?(false)
        self.dismiss(animated: true, completion: nil)
    }
    
    required init(_ parameters: Any? = nil) {
        super.init()
        guard let appVersionDto = parameters as? ThaiAppVersionDto else { return }
        setup(data: appVersionDto)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    
}
