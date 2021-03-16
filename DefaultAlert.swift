//
//  DefaultAlert.swift
//  ThaiLuck
//
//  Created by Andy Chen on 2020/2/14.
//  Copyright © 2020 Andy Chen. All rights reserved.
//

import Foundation
import WebKit
import UIKit

class DefaultAlert:BaseViewController  {
    static private let share = DefaultAlert()
    private var lineNumber:Int = 0
    private var completion: ((Bool) -> ())?
    private var alertMode : DefaultAlertViewMode
    private var alertMessage : String = ""
    private let container = UIView(color: .white)
    private lazy var bgView : UIView = {
       let view = UIView(color: UIColor.black.withAlphaComponent(0.5))
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissVC))
        view.addGestureRecognizer(tap)
        return view
    }()
    private let topBgView = UIView()
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.font = Fonts.pingFangTCRegular(16)
        label.textColor = .white
        label.text = "提示".LocalizedString
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    private let hintLabel:UILabel = {
        let label = UILabel()
        label.font = Fonts.pingFangTCRegular(16)
        label.textColor = Themes.grayBase
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "請先登錄帳號".LocalizedString
        return label
    }()
    
    private let registerBtn:UIButton = {
        let btn = UIButton()
        btn.layer.borderColor = #colorLiteral(red: 0.8745098039, green: 0.02745098039, blue: 0.5215686275, alpha: 1)
        btn.layer.borderWidth = 1
        btn.setTitle("註 冊".LocalizedString, for: .normal)
        btn.titleLabel?.font = Fonts.pingFangTCRegular(16)
        btn.setTitleColor(#colorLiteral(red: 0.8745098039, green: 0.02745098039, blue: 0.5215686275, alpha: 1), for: .normal)
        btn.applyCornerRadius(radius: height(20/818))
        btn.isHidden = true
        return btn
    }()
    
    private let loginBtn:UIButton = {
        let btn = UIButton()
//        btn.backgroundColor = Themes.primaryBase
        btn.setTitle("登錄".LocalizedString, for: .normal)
        btn.titleLabel?.font = Fonts.pingFangTCRegular(16)
        btn.setTitleColor(.white, for: .normal)
        btn.applyCornerRadius(radius: height(20/818))
        btn.isHidden = true
        return btn
    }()
    private let submitBtn:UIButton = {
        let btn = UIButton()
        btn.layer.borderColor = #colorLiteral(red: 0.8745098039, green: 0.02745098039, blue: 0.5215686275, alpha: 1)
        btn.layer.borderWidth = 1
        btn.setTitle("確定".LocalizedString, for: .normal)
        btn.titleLabel?.font = Fonts.pingFangTCRegular(16)
        btn.setTitleColor(#colorLiteral(red: 0.8745098039, green: 0.02745098039, blue: 0.5215686275, alpha: 1), for: .normal)
        btn.applyCornerRadius(radius: height(20/818))
        btn.isHidden = true
        return btn
    }()
    private let cancelBtn:UIButton = {
        let btn = UIButton()
//        btn.backgroundColor = Themes.primaryBase
        btn.setTitle("取消".LocalizedString, for: .normal)
        btn.titleLabel?.font = Fonts.pingFangTCRegular(16)
        btn.setTitleColor(.white, for: .normal)
        btn.applyCornerRadius(radius: height(20/818))
        btn.isHidden = true
        return btn
    }()
    private lazy var contentWebView:WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        for method in Method.allCases {
            configuration.userContentController.add(self, name: method.rawValue)
        }
        let source: String = "var meta = document.createElement('meta');" + "meta.name = 'viewport';" + "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" + "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(script)
        let webview = WKWebView(frame: self.view.frame, configuration: configuration)
        webview.navigationDelegate = self
        webview.scrollView.alwaysBounceVertical = false
        if UIDevice().userInterfaceIdiom == .phone
        {
            webview.customUserAgent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.20 (KHTML, like Gecko) Mobile/7B298g"
        }else
        {
            webview.customUserAgent = "Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10"
        }
        webview.isHidden = true
        return webview
    }()
    
    init(mode:DefaultAlertViewMode = .NoShot , message:String = "") {
        self.alertMode = mode
        self.alertMessage = message
        super.init()
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    init(mode:DefaultAlertViewMode = .NoShot , message:String = "", completeBlock:@escaping(Bool) -> ()) {
        self.completion = completeBlock
        self.alertMode = mode
        self.alertMessage = message
        super.init()
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDefaultViews()
        bindBtns()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateLines()
        detectMode()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    private func detectMode()
    {
        container.snp.remakeConstraints { (maker) in
            maker.centerY.centerX.equalToSuperview()
            maker.width.equalTo(alertMode.containerWidth)
            maker.height.equalTo(height(CGFloat(lineNumber*30)/812) + alertMode.containerOffectHeight)
        }
        switch alertMode {
        case .NoShot:
//            Log.v("沒有選項")
            submitBtn.isHidden = true
            cancelBtn.isHidden = true
            registerBtn.isHidden = true
            loginBtn.isHidden = true
            contentWebView.isHidden = true
            titleLabel.isHidden = true

            container.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.7411764706, blue: 0.7921568627, alpha: 1)
            container.layer.borderWidth = 4
            hintLabel.snp.remakeConstraints { (maker) in
                maker.centerX.centerY.equalToSuperview()
                maker.width.equalTo(alertMode.hintLabelWidth)
            }
            hintLabel.textColor = #colorLiteral(red: 0.337254902, green: 0.1921568627, blue: 0.3019607843, alpha: 1)
            hintLabel.font = Fonts.pingFangTCSemibold(18)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismiss(animated: true, completion: {})
            }
        case .OneShot:
//            Log.v("一個選項")
            submitBtn.isHidden = false
            cancelBtn.isHidden = true
            registerBtn.isHidden = true
            loginBtn.isHidden = true
            contentWebView.isHidden = true
            titleLabel.isHidden = false
            submitBtn.snp.makeConstraints { (maker) in
                maker.leading.equalTo(18)
                maker.trailing.equalTo(-18)
                maker.height.equalTo(height(40/818))
                maker.bottom.equalToSuperview().offset(-height(20/812))
            }
            view.layoutIfNeeded()
            submitBtn.setTitleColor(.white, for: .normal)
            submitBtn.addGradientLayer(colors: [#colorLiteral(red: 0.8745098039, green: 0.02745098039, blue: 0.5215686275, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.1960784314, blue: 0.4588235294, alpha: 1)], direction: .toRight)
        case .TwoCandy:
//            Log.v("兩個選項")
            submitBtn.isHidden = false
            cancelBtn.isHidden = false
            registerBtn.isHidden = true
            loginBtn.isHidden = true
            contentWebView.isHidden = true
            titleLabel.isHidden = false
            submitBtn.snp.makeConstraints { (maker) in
                maker.leading.equalTo(18)
                maker.trailing.equalTo(container.snp_centerX).offset(-6)
                maker.height.equalTo(height(40/818))
                maker.bottom.equalToSuperview().offset(-height(20/812))
            }
            cancelBtn.snp.makeConstraints { (maker) in
                maker.trailing.equalTo(-18)
                maker.leading.equalTo(container.snp_centerX).offset(6)
                maker.height.equalTo(height(40/818))
                maker.bottom.equalTo(submitBtn)
            }
            view.layoutIfNeeded()
            cancelBtn.addGradientLayer(colors: [#colorLiteral(red: 0.8745098039, green: 0.02745098039, blue: 0.5215686275, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.1960784314, blue: 0.4588235294, alpha: 1)], direction: .toRight)
        case .GoLoginSighup:
//            Log.v("原先的LoginAlert")
            submitBtn.isHidden = true
            cancelBtn.isHidden = true
            registerBtn.isHidden = false
            loginBtn.isHidden = false
            contentWebView.isHidden = true
            titleLabel.isHidden = false
            registerBtn.snp.makeConstraints { (maker) in
                maker.leading.equalTo(18)
                maker.trailing.equalTo(container.snp_centerX).offset(-6)
                maker.height.equalTo(height(40/818))
                maker.bottom.equalToSuperview().offset(-height(20/812))
            }
            loginBtn.snp.makeConstraints { (maker) in
                maker.trailing.equalTo(-18)
                maker.leading.equalTo(container.snp_centerX).offset(6)
                maker.height.equalTo(height(40/818))
                maker.bottom.equalTo(registerBtn)
            }
            view.layoutIfNeeded()
            loginBtn.addGradientLayer(colors: [#colorLiteral(red: 0.8745098039, green: 0.02745098039, blue: 0.5215686275, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.1960784314, blue: 0.4588235294, alpha: 1)], direction: .toRight)
        case .WebContent:
            Log.v("加裝Webview")
            submitBtn.isHidden = false
            cancelBtn.isHidden = true
            registerBtn.isHidden = true
            loginBtn.isHidden = true
            contentWebView.isHidden = false
            titleLabel.isHidden = false
            submitBtn.snp.makeConstraints { (maker) in
                maker.leading.equalTo(18)
                maker.trailing.equalTo(-18)
                maker.height.equalTo(height(40/818))
                maker.bottom.equalToSuperview().offset(-height(20/812))
            }
            view.layoutIfNeeded()
            submitBtn.setTitleColor(.white, for: .normal)
            submitBtn.addGradientLayer(colors: [#colorLiteral(red: 0.8745098039, green: 0.02745098039, blue: 0.5215686275, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.1960784314, blue: 0.4588235294, alpha: 1)], direction: .toRight)
            contentWebView.snp.makeConstraints { (maker) in
                maker.centerX.equalToSuperview()
//                maker.left.equalToSuperview().offset(width(20/414))
//                maker.right.equalToSuperview().offset(width(-20/414))
                maker.width.equalTo(alertMode.hintLabelWidth)
                maker.top.equalTo(titleLabel.snp.bottom).offset(height(24/818))
                maker.bottom.equalTo(submitBtn.snp.top)
                //                maker.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: Views.bottomOffset, right: 0) )
            }
            contentWebView.loadHTMLString(self.alertMessage , baseURL: nil)
        }
    }
    private func setupDefaultViews()
    {
        bgView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(UIEdgeInsets.zero)
        }
        container.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.width.equalTo(alertMode.containerWidth)
            maker.height.equalTo(height(CGFloat(lineNumber*30 + 100)/812))
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(height(56/818))
        }
        
        hintLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(height(24/812))
            maker.width.equalTo(alertMode.hintLabelWidth)
            maker.centerX.equalToSuperview()
        }
    }
    private func calculateLines()
    {
        if alertMode != .GoLoginSighup
        {
            hintLabel.text = alertMessage
        }
        lineNumber = hintLabel.calculateMaxLines(width: alertMode.hintLabelWidth)
    }
    private func setupViews(){
        view.addSubview(bgView)
        view.addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(hintLabel)
        container.addSubview(submitBtn)
        container.addSubview(cancelBtn)
        container.addSubview(registerBtn)
        container.addSubview(loginBtn)
        container.addSubview(contentWebView)
        container.applyCornerRadius(radius: height(16/818))
//        titleLabel.addGradientLayer(colors: [#colorLiteral(red: 0.8745098039, green: 0.02745098039, blue: 0.5215686275, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.1960784314, blue: 0.4588235294, alpha: 1)], direction: .toRight)
        titleLabel.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.02745098039, blue: 0.5215686275, alpha: 1)
    }
    private func bindBtns(){
        submitBtn.rx.tap.subscribeSuccess { (_) in
            self.dissmissVC()
            if self.completion != nil
            {
                self.completion!(true)
            }
            }.disposed(by: disposeBag)
        
        cancelBtn.rx.tap.subscribeSuccess { (_) in
            self.dissmissVC()
            }.disposed(by: disposeBag)
        registerBtn.rx.tap.subscribeSuccess { (_) in
            UIApplication.shared.keyWindow?.rootViewController = LoginSignupViewController.share.isLogin(false)
            }.disposed(by: disposeBag)
        
        loginBtn.rx.tap.subscribeSuccess { (_) in
            UIApplication.shared.keyWindow?.rootViewController = LoginSignupViewController.share.isLogin(true)
            }.disposed(by: disposeBag)
    }
    
    @objc private func dissmissVC(){
        dismiss(animated: true) {
            if self.completion != nil
             {
                 self.completion!(false)
             }
        }
    }
    func showAndAutoDismiss() {
        self.hintLabel.text = self.alertMessage
        DispatchQueue.main.async {
            self.modalPresentationStyle = .overCurrentContext
            self.modalTransitionStyle = .crossDissolve
            if self.isBeingPresented == false
            {
                UIApplication.topViewController()?.present(self, animated: false, completion: nil)
            }else{
                Log.v("上次的動畫還沒消除")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             self.dissmissVC()
         }
    }
}
extension DefaultAlert: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        Beans.walletServer.walletTransferAll().subscribeSuccess { (isScuuess) in
            LoadingViewController.action(mode: .success, title: "回收成功".LocalizedString).subscribeSuccess({
                _ = LoadingViewController.dismiss()
                ThaiWalletDto.update()
            }).disposed(by: self.disposeBag)
            
        }.disposed(by: disposeBag)
        guard let method = Method(rawValue: message.name) else { return }
        switch method {
        case .app_service:
            LiveChatService.share.betLeadServicePresent()
        case .app_deposit:
            DeepLinkManager.share.handleDeeplink(navigation: .walletDeposit)
        case .app_mypage:
            DeepLinkManager.share.handleDeeplink(navigation: .member)
        default: break
        }
    }
}
extension DefaultAlert: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
//        loadingView.isHidden = true
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    {
//        loadingView.isHidden = true
    }
}
