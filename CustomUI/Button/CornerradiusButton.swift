//
//  CornerradiusButton.swift
//  betlead
//
//  Created by Victor on 2019/6/24.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import UIKit

class CornerradiusButton: UIButton {

  
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.titleLabel?.font = Fonts.pingFangTCRegular(20)
        self.layer.cornerRadius = Views.defaultSubmitBtnHeight/2
        self.clipsToBounds = true
    }
    override var isEnabled: Bool {
        didSet {
            if self.isEnabled == true{
//                Log.v("按鈕可用")
                backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.02745098039, blue: 0.5215686275, alpha: 1)
            } else {
//                Log.v("按鈕禁用")
                backgroundColor = #colorLiteral(red: 0.9917225242, green: 0.786259234, blue: 0.874286592, alpha: 1)
            }
        }
    }

}
