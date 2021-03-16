//
//  CancelButton.swift
//  betlead
//
//  Created by Victor on 2019/6/19.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import UIKit

class CancelButton: UIButton {

    override func draw(_ rect: CGRect) {
//        setBackgroundImage(UIImage(color: Themes.primaryBase), for: .normal)
        addGradientLayer(colors: [#colorLiteral(red: 0.8745098039, green: 0.02745098039, blue: 0.5215686275, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.1960784314, blue: 0.4588235294, alpha: 1)], direction: .toRight)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
    }
    
}
