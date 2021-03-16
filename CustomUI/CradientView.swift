//
//  CradientView.swift
//  betlead
//
//  Created by Victor on 2019/6/14.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import UIKit

enum GradientViewType {
    case label
    case mainSegment
    case bottomSheet
    case txSuccess
    case txFail
    case mainCell
    case gameList
    
    var colors: [CGColor] {
        switch self {
        case .label:
            return [UIColor(red: 243, green: 50, blue: 117).cgColor,
                    UIColor(red: 223, green: 7, blue: 113).cgColor]
        case .mainSegment:
            return [UIColor(red: 223, green: 7, blue: 113).cgColor,
                    UIColor(red: 243, green: 50, blue: 117).cgColor]
        case .bottomSheet:
            return [UIColor(red: 223, green: 7, blue: 133).cgColor,
                    UIColor(red: 243, green: 50, blue: 117).cgColor]
        case .txSuccess:
            return [UIColor(rgb: 0x2ab5f7).cgColor,
                    UIColor(rgb: 0x4232f3).cgColor]
        case .txFail:
            return [UIColor(rgb: 0xf7ba2a).cgColor,
                    UIColor(rgb: 0xf33275).cgColor]
        case .mainCell:
            return [UIColor(red: 253, green: 252, blue: 252, a: 0).cgColor,
                    UIColor(red: 249, green: 248, blue: 248).cgColor]
        case .gameList:
            return [UIColor(red: 253, green: 252, blue: 252, a: 0).cgColor,
                    UIColor(red: 223, green: 7, blue: 133).cgColor]
        }
    }
    
    var locations: [NSNumber] {
        [0.0, 1.0]
    }
    
    var startPoint: CGPoint {
        switch self {
        case .mainCell, .gameList:
            return CGPoint(x: 0.5, y: 0)
        default:
            return CGPoint(x: 0, y: 0)
        }
    }
    
    var endPoint: CGPoint {
        switch self {
        case .mainCell, .gameList:
            return CGPoint(x: 0.5, y: 1)
        default:
            return CGPoint(x: 1, y: 0)
        }
        
    }
}
class GradientView: UIView {

    private lazy var type: GradientViewType = .mainSegment
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = type.colors
        layer.locations = type.locations
        layer.startPoint = type.startPoint
        layer.endPoint = type.endPoint
        return layer
    }()
    
    init(type: GradientViewType) {
        super.init(frame: .zero)
        self.type = type
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        gradientLayer.frame = self.bounds
    }
    
    private func setupLayout() {
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

class GradientLabel: UILabel {
    /*
     層級問題 重寫屬性
     https://www.jianshu.com/p/f91e42310e85
    */
    override class var layerClass: AnyClass { //
        return CAGradientLayer.self
    }
    
    private var type: GradientViewType = .label
    
    init(type: GradientViewType) {
        super.init(frame: .zero)
        self.type = type
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        guard let layer = layer as? CAGradientLayer else { return }
        layer.colors = type.colors
        layer.locations = type.locations
        layer.startPoint = type.startPoint
        layer.endPoint = type.endPoint
    }
    
    func updateGradientColor(type: GradientViewType) {
        self.type = type
        setupLayout()
    }
    
    func setLayerColorClear() {
        guard let layer = layer as? CAGradientLayer else { return }
        layer.colors = nil
    }
}
