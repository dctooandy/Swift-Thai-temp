//
//  CheckBoxView.swift
//  betlead
//
//  Created by Victor on 2019/5/28.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import Foundation
import UIKit

class CheckBoxView: UIControl {
    
    private var title: String? = nil
    
    private var font: UIFont = Fonts.pingFangTCRegular(20)
    
    private var titleColor: UIColor = .red
    
    private var checkBoxSize: CGFloat = 15.0
    
    private var checkBox: CheckBox?
    
    private var checkBoxColor: UIColor = .blue
    
    var isCheck: Bool {
        get {
            return self.checkBox?.isCheck ?? false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    
    init(title: String? = nil, font: UIFont = UIFont.systemFont(ofSize: 15), titleColor: UIColor = .blue, checkBoxSize: CGFloat = 15, checkBoxColor: UIColor = .blue) {
        super.init(frame: .zero)
        self.title = title
        self.font = font
        self.titleColor = titleColor
        self.checkBoxSize = checkBoxSize
        self.checkBoxColor = checkBoxColor
        setupViews()
    }
    
    
    
    func setupViews() {
        checkBox = CheckBox(boxColor: checkBoxColor)
        checkBox?.layer.cornerRadius = checkBoxSize / 2
        checkBox?.clipsToBounds = true
        checkBox?.isUserInteractionEnabled = false
        addSubview(checkBox!)
        checkBox?.snp.makeConstraints({ (make) in
            make.width.height.equalTo(checkBoxSize)
            make.left.centerY.equalToSuperview()
        })
        
        
        
        if title != nil {
            let label = UILabel()
            label.text = title!
            label.font = font
            label.textColor = titleColor
            addSubview(label)
            label.snp.makeConstraints { (make) in
                make.left.equalTo(checkBox!.snp.right).offset(8)
                make.top.bottom.right.equalToSuperview()
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            checkBox?.isCheck = self.isSelected
        }
    }
}
