//
//  WalletDetailLabel.swift
//  ThaiLuck
//
//  Created by Andy Chen on 2020/2/3.
//  Copyright © 2020 Andy Chen. All rights reserved.
//

import Foundation
class WalletDetailDefaultLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        self.setup()
    }
    func setup() {
        self.font = Fonts.pingFangSCSemibold(20)
        self.textColor = #colorLiteral(red: 0.3378837705, green: 0.1950254142, blue: 0.3042808771, alpha: 1)
        self.numberOfLines = 1
        self.textAlignment = .left
    }
}
class WalletDetailLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        self.setup()
    }
    func setup() {
        self.font = Fonts.pingFangSCSemibold(20)
        self.textColor = #colorLiteral(red: 0.920527637, green: 0.4266157746, blue: 0.696144402, alpha: 1)
        self.numberOfLines = 1
        self.textAlignment = .right
    }
}
