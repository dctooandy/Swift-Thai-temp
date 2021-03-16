//
//  OKButton.swift
//  betlead
//
//  Created by Victor on 2019/6/19.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import UIKit

class OKButton: UIButton {

    var titleColor: UIColor? = nil
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = rect.height / 2
        layer.borderColor = #colorLiteral(red: 0.8745098039, green: 0.02745098039, blue: 0.5215686275, alpha: 1)
        layer.borderWidth = 1
        setTitleColor(titleColor ?? #colorLiteral(red: 0.8745098039, green: 0.02745098039, blue: 0.5215686275, alpha: 1), for: .normal)
    }
}
