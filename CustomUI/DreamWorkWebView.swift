//
//  BetLeadWebView.swift
//  betlead
//
//  Created by Victor on 2019/8/8.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import UIKit
import WebKit
class DreamWorkWebView: UIView, WKNavigationDelegate {
    
    lazy var wkWebView: WKWebView = {
        let wv = WKWebView()
        wv.navigationDelegate = self
        return wv
    }()
    
    func loadHtml(_ str: String, baseURL: URL? = nil) {
        if UIDevice().userInterfaceIdiom == .phone
        {
            wkWebView.customUserAgent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.20 (KHTML, like Gecko) Mobile/7B298g"
        }else
        {
            wkWebView.customUserAgent = "Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10"
        }
        wkWebView.loadHTMLString(str, baseURL: baseURL)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(wkWebView)
        wkWebView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            print(navigationAction.request.url?.absoluteString ?? "no url.")
            DeepLinkManager.share.parserUrlFromBroeser(navigationAction.request.url)
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
}
