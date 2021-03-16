//
//  MarqueeView.swift
//  betlead
//
//  Created by Victor on 2019/8/20.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import UIKit
import RxSwift

class MarqueeView: UIView {
    
    private lazy var label1: UILabel = {
        let lb = UILabel()
        lb.tag = 1
        lb.textColor = Themes.darkGrey
        lb.font = Fonts.pingFangTCRegular(12)
        return lb
    }()
    
    private lazy var label2: UILabel = {
        let lb = UILabel()
        lb.tag = 2
        lb.textColor = Themes.darkGrey
        lb.font = Fonts.pingFangTCRegular(12)
        return lb
    }()
    
    private var currentLabel = UILabel()
    private var nextLabel = UILabel()
    private var duration: Double = 0.75
    fileprivate let viewModel = MarqueeViewModel()
    let takeOutMarqueeView = PublishSubject<Void>()
    private var defaultMarqueeCount : Int = 0
    private let dpg = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindViewModel()
        bindStyle()
    }
    
    func bindStyle() {
        Themes.thaiBrownAndBrown.bind(to: label1.rx.textColor).disposed(by: dpg)
        Themes.thaiBrownAndBrown.bind(to: label2.rx.textColor).disposed(by: dpg)
    }
    
    func bindViewModel() {
        viewModel.selectedMarquee
            .subscribeSuccess { [weak self] (dto) in
                if dto.NewsName != "暂无公告资料"
                {
                    self?.nextNews(title: dto.NewsName)
                }else
                {
                    if self!.defaultMarqueeCount < 2
                    {
                        self?.takeOutMarqueeView.onNext(())
                        self?.nextNews(title: dto.NewsName)
                        self!.defaultMarqueeCount += 1
                    }
                }
        }.disposed(by: dpg)
    }
    
    func nextNews(title: String) {
        if currentLabel.text == nil {
            currentLabel.text = title
            return
        }
        nextLabel.text = title
        moveLabel()
    }
    
    func moveLabel() {
        let viewWidth = frame.width
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.currentLabel.frame.origin = CGPoint(x: -viewWidth, y: 0)
            strongSelf.nextLabel.frame.origin = .zero
        }){ [weak self] (status) in
            guard let strongSelf = self else { return }
            let tmpCurrentLabel = strongSelf.nextLabel
            strongSelf.nextLabel = strongSelf.currentLabel
            strongSelf.nextLabel.frame.origin.x = viewWidth
            strongSelf.currentLabel = tmpCurrentLabel
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if label1.frame.width > 0 { return }
        label1.frame = CGRect(origin: .zero, size: frame.size)
        label2.frame = CGRect(origin: CGPoint(x: frame.width, y: 0), size: frame.size)
        clipsToBounds = true
        addSubview(label1)
        addSubview(label2)
        var tempOneString = ""
        var tempTwoString = ""
        tempOneString = currentLabel.text ?? ""
        tempTwoString = nextLabel.text ?? ""
        currentLabel = label1
        nextLabel = label2
        label1.text = tempOneString
        label2.text = tempTwoString
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension Reactive where Base: MarqueeView {
    var selectedMarquee: Observable<News> {
        return base.rx.click.withLatestFrom(self.base.viewModel.selectedMarquee)
    }
}
