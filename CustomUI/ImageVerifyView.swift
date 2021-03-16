//
//  ImageVerifyView.swift
//  betlead
//
//  Created by Victor on 2019/6/12.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ImageVerifyView: UIView {
    
    private var navHeaderImgView: UIImageView? = nil
    var dismissButton: UIButton? = nil
    private var titleLabel: UILabel? = nil
    private var imageVerityView: WMZCodeView? = nil
    private let disposeBag = DisposeBag()
    private var onSuccess = PublishSubject<Bool>()
    private let backgroundImv = UIImageView()
    func rxVerifySuccess() -> Observable<Bool> {
        return onSuccess.asObserver()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
        bindStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dismissBtnPressed() {
        self.removeFromSuperview()
    }
    
    func bindStyle() {
        Themes.dreamWorkNavigationBg.bind(to: navHeaderImgView!.rx.image).disposed(by: disposeBag)
        Themes.dreamWorkBgImage.bind(to: backgroundImv.rx.image).disposed(by: disposeBag)
        Themes.dreamWorkBlackAndWhite.bind(to: imageVerityView!.tipLabel.rx.textColor).disposed(by: disposeBag)
    }
    
    func setup() {
        insertSubview(backgroundImv, at: 0)
        backgroundImv.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if navHeaderImgView == nil {
            navHeaderImgView = UIImageView()
            navHeaderImgView?.contentMode = .scaleToFill
            navHeaderImgView?.image = UIImage(named: "navigation-bg")
            addSubview(navHeaderImgView!)
            navHeaderImgView?.snp.makeConstraints({ (make) in
                make.top.left.right.centerX.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.142)
            })
        }
        
        if dismissButton == nil {
            dismissButton = UIButton()
            dismissButton?.addTarget(self, action: #selector(dismissBtnPressed), for: .touchUpInside)
            dismissButton?.setImage(UIImage(named: "icon-close"), for: .normal)
            addSubview(dismissButton!)
            dismissButton?.snp.makeConstraints({ (make) in
                make.left.equalTo(24)
                make.top.equalTo(68)
                make.size.equalTo(24)
            })
        }
        
        
        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel?.text = "滑块验证"
            titleLabel?.textColor = .white
            titleLabel?.font = Fonts.pingFangTCRegular(20)
            addSubview(titleLabel!)
            titleLabel?.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(dismissButton!)
            })
        }
        if imageVerityView == nil {
            
            imageVerityView = WMZCodeView()
            imageVerityView?.add(with: .image, withImageName: "a", witgFrame: CGRect(x: 0, y: self.frame.height * 0.142 + 30, width: self.frame.width, height: 50)) { [weak self] (success) in
                print("success: \(success)")
                self?.onSuccess.onNext(success)
            }
            addSubview(imageVerityView!)
        }
    }
}
