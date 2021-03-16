//
//  gameTitleView.swift
//  betlead
//
//  Created by vanness wu on 2019/6/27.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import Foundation

class GameTitleView: UIView {
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "PG电子"
        label.font = Fonts.pingFangTCSemibold(20)
        label.textColor = .white
        return label
    }()
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon-arrow_down"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        addSubview(titleLabel)
        addSubview(icon)
        titleLabel.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        icon.snp.makeConstraints { (maker) in
            maker.leading.equalTo(titleLabel.snp.trailing).offset(10)
            maker.centerY.equalTo(titleLabel)
            maker.size.equalTo(CGSize(width: 16, height: 16))
        }
    }
    
    func setTitle(_ title:String) {
        titleLabel.text = title
    }
    
    override var intrinsicContentSize: CGSize {
        UIView.layoutFittingExpandedSize
    }
    
}
