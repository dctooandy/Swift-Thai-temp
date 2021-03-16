//
//  VerticalTopAlignLabel.swift
//  betlead
//
//  Created by Victor on 2019/6/24.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import UIKit
/// 让Label文字从顶部开始
class VerticalTopAlignLabel: UILabel {
    
    override func draw(_ rect: CGRect) {
        guard let labelText = text else { return }
        let attText = NSAttributedString(string: labelText,
                                         attributes: [NSAttributedString.Key.font: font!])
        var newRect = rect
        newRect.size.height = attText.boundingRect(with: rect.size, options: .usesFontLeading, context: nil).size.height
        if numberOfLines != 0 {
            newRect.size.height = max(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
        }
        super.drawText(in: newRect)
    }
}
