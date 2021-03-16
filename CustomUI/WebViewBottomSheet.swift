//
//  WebViewBottomSheet.swift
//  betlead
//
//  Created by Victor on 2019/7/30.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import UIKit
import WebKit
class WebViewBottomSheet: BottomSheet {
    
    private lazy var contentWebView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
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
    
    required init(_ parameters: Any? = nil) {
        super.init()
        guard let urlStr = parameters as? String, urlStr != "" else { return }
        urlString = urlStr
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if urlString == "" { return }
        contentWebView.load(URLRequest(url: URL(string: urlString)!))
    }
    override func setupViews() {
        super.setupViews()
        defaultContainer.addSubview(contentWebView)
        defaultContainer.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalToSuperview()
//            maker.height.equalTo(600 + Views.bottomOffset)
            maker.height.equalTo(height(600/818) + (Views.isIPad() ? 34 : Views.bottomOffset))
        }
        
        contentWebView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: Views.bottomOffset, right: 0) )
        }
        
        view.layoutIfNeeded()
        defaultContainer.roundCorner(corners: [.topLeft,.topRight], radius: 18)
    }

}

extension WebViewBottomSheet: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString {
            print("url string = \(url)")
        }
    }
}
