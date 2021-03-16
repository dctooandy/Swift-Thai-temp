//
//  NoDataView.swift
//  betlead
//
//  Created by Victor on 2019/7/1.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import UIKit

class NoDataView: UIView {
    private let imv: UIImageView = UIImageView()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = Fonts.pingFangTCRegular(20)
        lb.textColor = #colorLiteral(red: 0.8349764943, green: 0.7494625449, blue: 0.7986139655, alpha: 1)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(image: UIImage?, title: String) {
        super.init(frame: .zero)
        imv.image = image
        titleLabel.text = title
        setup()
    }
    
    private func setup() {
        addSubview(imv)
        addSubview(titleLabel)
        imv.contentMode = .scaleAspectFill
        imv.snp.makeConstraints { (make) in
            let s = sizeFrom(scale: 0.44)
            make.size.equalTo(s)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-s/3)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imv.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
    }
}
