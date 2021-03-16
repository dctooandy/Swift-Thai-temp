//
//  TfRightButton.swift
//  betlead
//
//  Created by Victor on 2019/6/21.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import UIKit

class TfRightButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func setImageTitle(image: UIImage?, title: String? ,isCounting:Bool = false) {
        
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        setImage(image, for: .normal)
        setTitle(title, for: .normal)
        titleLabel?.font = Fonts.pingFangSCRegular(15)
        setTitleColor(Themes.thaiPrimaryBase, for: .normal)
        if isCounting == false
        {
            self.layer.borderColor = Themes.thaiDisPrimaryBase.cgColor
            setTitleColor(Themes.thaiDisPrimaryBase, for: .disabled)
        }else
        {
            self.layer.borderColor = Themes.thaiPrimaryBase.cgColor
            setTitleColor(Themes.thaiPrimaryBase, for: .disabled)
        }
    }
    
    func setImage(_ image: UIImage?) {
        setImage(image, for: .normal)
    }
}
