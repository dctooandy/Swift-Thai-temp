//
//  BetLeadWebViewController.swift
//  betlead
//
//  Created by Victor on 2019/8/14.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import Foundation
import WebKit
import RxCocoa
import RxSwift
import Toaster

class BetLeadWebViewController: BaseViewController {
    let subject = PublishSubject<Any?>()
    var nextSheet:BottomSheet.Type?
    var nextNextSheet:BottomSheet.Type?
    var nextNextSheetVC:BottomSheet?
    var nextSheetVC:BottomSheet?
    private lazy var contentWebView: WKWebView = {
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
        if UIDevice().userInterfaceIdiom == .phone
        {
            webview.customUserAgent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.20 (KHTML, like Gecko) Mobile/7B298g"
        }else
        {
            webview.customUserAgent = "Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10"
        }
        return webview
    }()
    
    var urlString = "https://www.yahoo.com"
    
    func setup() {
        view.addSubview(contentWebView)
        view.backgroundColor = .clear
        contentWebView.backgroundColor = .clear
        contentWebView.scrollView.backgroundColor = .clear
        contentWebView.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview().offset((self.navigationController == nil) ?  (Views.isIPad() ? 24 : Views.statusBarHeight) : 0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset((Views.isIPad() ? 20 : Views.bottomOffset))
        }
    }
    
    required init(_ parameters: Any? = nil) {
        super.init()
        guard let urlStr = parameters as? String, urlStr != "" else { return }
        urlString = urlStr
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LoadingViewController.show()
        contentWebView.load(URLRequest(url: URL(string: urlString)!))
    }
    private func assignNextSheet(_ newVC:BottomSheet){
        if let nextSheet = self.nextNextSheet {
            newVC.nextSheet = nextSheet
        }
        if let nextSheetVC = self.nextNextSheetVC {
            newVC.nextSheetVC = nextSheetVC
        }
    }
    func dismissVC(nextSheet:BottomSheet? = nil)  {
        if let nextSheet = nextSheet {
          guard  let presentingVC = presentingViewController else { return }
            dismiss(animated: true) {
                nextSheet.start(viewController: presentingVC)
            }
        }
        if let nextSheet = self.nextSheet {
            guard  let presentingVC = presentingViewController else { return }
            dismiss(animated: true) {
                let nextVC = nextSheet.init()
                self.assignNextSheet(nextVC)
                nextVC.start(viewController: presentingVC)
            }
        }
        if let nextSheet = self.nextSheetVC {
            guard  let presentingVC = presentingViewController else { return }
            dismiss(animated: true) {
               self.assignNextSheet(nextSheet)
                nextSheet.start(viewController: presentingVC)
            }
        }
       
        dismiss(animated: true, completion: nil)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "QR Code照片 Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "QR Code照片", message: "已储存至本地相簿", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

extension BetLeadWebViewController: WKNavigationDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        guard let method = Method(rawValue: message.name)
            else { return }
        switch method {
        case .app_info:
            dismiss(animated: true, completion: nil)
            DeepLinkManager.share.handleDeeplink(navigation: .moreInfo)
        case .app_help:
            dismiss(animated: true, completion: nil)
            DeepLinkManager.share.handleDeeplink(navigation: .moreHelp)
        case .app_service:
            LiveChatService.share.betLeadServicePresent()
        case .app_gohome:
            dismiss(animated: true, completion: nil)
        case .app_addBankCard:
            guard let memberProfileDto = ThaiMemberDto.share
            else { return }
            if memberProfileDto.PhoneStatus?.bool == true
            {
                let newVC = AddBankCardBottomSheet()
                newVC.nextSheet = PaymenetBottomSheet.self
                dismissVC(nextSheet: newVC)
            }
            else
            {
                let newVC = PhoneVerifyBottomSheet()
                newVC.nextSheet = AddBankCardBottomSheet.self
                newVC.nextNextSheetVC = PaymenetBottomSheet()
                DefaultAlert(message: "手機驗證".LocalizedString).showAndAutoDismiss()
//                _ = DefaultAlert(mode: .NoShot, message: "手機驗證".LocalizedString)
//                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
//                Toast.show(msg: "请先进行电话验证")
                dismissVC(nextSheet: newVC)
            }
        case .token_expired:
            dismiss(animated: true, completion: {
                ErrorHandler.showAlert(
                    title: "error",
                    message: "網路連線逾時，請稍候再試".LocalizedString ,
                    completeBlock:
                    {
                        UIApplication.shared.keyWindow?.rootViewController =  LoginSignupViewController.share.isLogin(true)
                    }
                )
            })
        case .deposit_log:
            print("tx deposit")
            DeepLinkManager.share.handleDeeplink(navigation: .txRecord(0))
        case .withdraw_log:
            print("tx withdraw")
            DeepLinkManager.share.handleDeeplink(navigation: .txRecord(0))
        case .webImgLongPressHandler:
                if let urlString = message.body as? String {
                    // 将 base64的图片字符串转化成Data
                    let imageData = Data(base64Encoded: urlString)
                    if imageData != nil
                    {
                    // 将Data转化成图片
                        let image = UIImage(data: imageData!)
                        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                    }
                }

        default: break
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish loading.")
        _ = LoadingViewController.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("fail: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString {
            print("url string = \(url)")
        }
    }
}
