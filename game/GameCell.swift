//
//  GameCell.swift
//  betlead
//
//  Created by vanness wu on 2019/6/27.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
class GameCell: UICollectionViewCell {
    private lazy var likeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_love"))
        return imageView
    }()
    
    private lazy var gameImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon-game_default"))
        return imageView
    }()
    
    private lazy var gameGroupNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Joker"
        label.textColor = .white
        label.font = Fonts.pingFangTCSemibold(12)
        label.isHidden = true
        return label
    }()
    
    private lazy var gameNameLabel: UILabel = {
        let label = UILabel()
        label.text = "夜戏貂蝉"
        label.textColor = .white
        label.font = Fonts.pingFangTCSemibold(14)
        return label
    }()
    
    private lazy var gradientView: GradientView = {
        let view = GradientView(type: .gameList)
        return view
    }()
    
    private let subject = PublishSubject<Bool>()
    private var dispose:Disposable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        contentView.addSubview(gameImageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(gameGroupNameLabel)
        contentView.addSubview(gameNameLabel)
        contentView.addSubview(likeImageView)
        
        gameImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        gameGroupNameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(gameNameLabel.snp_top).offset(-3)
            make.left.equalTo(gameNameLabel)
        }
        
        gameNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalTo(likeImageView.snp_left)
        }
        
        likeImageView.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview().offset(-10)
            make.size.equalTo(16)
        }
        
        gradientView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    func configureCell(gameDto:Game){
        gameImageView.sdLoad(with: URL(string: gameDto.Images ?? ""), withPlaceholderImage: UIImage(named: "icon-game_default"), completed: nil)
        gameGroupNameLabel.text = gameDto.GroupName
        gameNameLabel.text = gameDto.GameName
        likeImageView.image = gameDto.recordString == "1" ? UIImage(named: "icon_love-h") : UIImage(named: "icon_love")
    }
    
    func configureCell(for gameListData: GameList){
         gameImageView.sdLoad(with: URL(string: gameListData.Images), withPlaceholderImage: UIImage(named: "icon-game_default"), completed: nil)
        gameGroupNameLabel.text = gameListData.GroupName
        gameNameLabel.text = gameListData.GameName
        likeImageView.image = gameListData.recordString == "1" ? UIImage(named: "icon_love-h") : UIImage(named: "icon_love")
    }
    
    func rxLike() -> Observable<Void> {
        return likeImageView.rx.click.throttle(1, scheduler: MainScheduler.instance)
    }
    
    func updateFavorite(isFavoritr: Bool) {
        if isFavoritr {
            likeImageView.image = UIImage(named: "icon_love-h")
        } else {
            likeImageView.image = UIImage(named: "icon_love")
        }
    }
}
