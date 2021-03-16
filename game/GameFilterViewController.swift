//
//  GameFilterViewController.swift
//  betlead
//
//  Created by vanness wu on 2019/7/1.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Toaster
class GameFilterViewController:GameBaseViewController {
    
    
    
    @IBOutlet weak var backgroundImv: UIImageView!
    @IBOutlet weak var topBgImv: UIImageView!
    @IBOutlet weak var resetBtn:UIButton!
    @IBOutlet weak var dismissBtn:UIButton!
    @IBOutlet weak var categoryScrollView:UIScrollView!
    @IBOutlet weak var categoryContentView:UIView!
    @IBOutlet weak var lineScrollView:UIScrollView!
    @IBOutlet weak var lineContentView:UIView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var lineTitleLabel: UILabel!
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    private var gameDtos = [GameDto]()
    private var filterGameDtos = [GameDto]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private var gameTagDtos = [GameTagDto]()
    private var gameCategoryTagDtos = [GameTagDto]()
    private var gameLineTagDtos = [GameTagDto]()
    private let padding:CGFloat = 24
    private var filterIds = [Int]() {
        didSet{
            if filterIds.count == 0 { filterGameDtos = gameDtos }
            else {
                filterGameDtos = gameDtos.filter({ (gameDto) -> Bool in
                    for tag in filterIds {
                        if gameDto.gameTag.contains(tag.description) { return true }
                    }
                    return false
                })
            }
        }
    }
    
    private var labels = [PaddingLabel]()
    let future = PublishSubject<Void>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGameTag()
        setupTopBtns()
        setupCollectionView()
        fetchGameList()
        bindStyle()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        future.onNext(())
    }
    
    static func loadViewFromNib(groupId:String) -> GameFilterViewController{
        let newVC = GameFilterViewController.loadNib()
        newVC.groupId = groupId
        return newVC
    }
    
    private func bindStyle() {
        Themes.dreamWorkNavigationBg.bind(to: topBgImv.rx.image).disposed(by: disposeBag)
        Themes.dreamWorkBgImage.bind(to: backgroundImv.rx.image).disposed(by: disposeBag)
        Themes.dreamWorkGrayBaseAndGrayLightest.bind(to: lineTitleLabel.rx.textColor).disposed(by: disposeBag)
        Themes.dreamWorkGrayDarkAndWhite.bind(to: categoryTitleLabel.rx.textColor).disposed(by: disposeBag)
    }
    
    private func setupCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth = (Views.screenWidth - 24*2 - 16)/2
        let itemHeight = itemWidth  * 0.63 + 20
        collectionView.collectionViewLayout = flowLayout
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.registerXibCell(type: GameCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
    }
    
    private func fetchGameTag(){
        Beans.gameServer.getGameTagList().subscribeSuccess {[weak self] (gameTagDtos) in
            guard let weakSelf = self else { return }
            weakSelf.gameTagDtos = gameTagDtos
            weakSelf.setupLabels()
            }.disposed(by: disposeBag)
    }
    
    private func setupLabels(){
        gameCategoryTagDtos = gameTagDtos.filter({$0.gameTagGroupId == 1})
        gameLineTagDtos = gameTagDtos.filter({$0.gameTagGroupId == 2})
        var width:CGFloat = padding
        for category in gameCategoryTagDtos{
            let label = createLabel()
            label.text = category.gameTagName
            label.sizeToFit()
            categoryScrollView.addSubview(label)
            labels.append(label)
            label.applyCornerRadius(radius: 15)
            label.frame = CGRect(x: width, y: 0, width: label.frame.width + 20, height: 30)
            width = label.frame.maxX + 4
            label.tag = Int(category.id)
        }
        categoryScrollView.contentSize.width = width + padding - 4
        width = padding
        for line in gameLineTagDtos {
            let label = createLabel()
            label.text = line.gameTagName
            label.sizeToFit()
            lineScrollView.addSubview(label)
            labels.append(label)
            label.applyCornerRadius(radius: 15)
            label.frame = CGRect(x: width, y: 0, width: label.frame.width + 20, height: 30)
            width = label.frame.maxX + 4
            label.tag = Int(line.id)
        }
        lineScrollView.contentSize.width = width + padding - 4
        
        Observable.merge(labels.map { (label) -> Observable<PaddingLabel> in
            return label.rx.click.map{
                Beans.matomoServer.track(eventWithCategory: MCategory.GameProperty.rawValue, action: MAction.Check.rawValue , name:label.text)
                return label
                
            }
        }).subscribeSuccess(setSelected)
            .disposed(by: disposeBag)
        
    }
    
    private func createLabel() -> PaddingLabel {
        let label = PaddingLabel()
        label.backgroundColor = DreamWorkStyle.share.isLightMode() ? .white : Themes.primaryDarkBase
        label.textAlignment = .center
        label.textColor = DreamWorkStyle.share.isLightMode() ? Themes.grayDark : .white
        label.applyBorder(color: DreamWorkStyle.share.isLightMode() ? Themes.grayDark : .white, borderWidth: 1)
        return label
    }
    
    private func setupTopBtns(){
        dismissBtn.rx.tap.subscribeSuccess { (_) in
            self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        resetBtn.rx.tap.subscribeSuccess {[weak self] (_) in
            guard let weakSelf = self else { return }
            weakSelf.reset()
            }.disposed(by: disposeBag)
        
    }
    private func reset(){
        Beans.matomoServer.track(eventWithCategory: MCategory.GameProperty.rawValue, action: MAction.Click.rawValue ,name:"重置条件")
        let bgColor = DreamWorkStyle.share.isLightMode() ? .white : Themes.primaryDarkBase
        let textColor = DreamWorkStyle.share.isLightMode() ? Themes.grayDark : .white
        labels.forEach { (label) in
            label.textColor = textColor
            label.backgroundColor = bgColor
        }
        filterIds = []
    }
    
    override func fetchGameList(){
         guard let groupId = groupId else {return}
        Beans.gameServer.fetchGameList(gameType: .newest,game_group_id: groupId).subscribeSuccess { [weak self](gameDtos) in
            guard let weakSelf = self else { return }
            weakSelf.gameDtos = gameDtos
            weakSelf.filterGameDtos = gameDtos
            }.disposed(by: disposeBag)
    }
    
    private func setSelected(label:PaddingLabel){
        let bgColor = DreamWorkStyle.share.isLightMode() ? .white : Themes.primaryDarkBase
        let textColor = DreamWorkStyle.share.isLightMode() ? Themes.grayDark : .white
        let setSelected = !filterIds.contains(label.tag)
        if setSelected {
            label.textColor = .white
            label.backgroundColor = Themes.primaryBase
            filterIds.append(label.tag)
        } else {
            label.textColor = textColor
            label.backgroundColor = bgColor
            filterIds.removeAll(where: {$0 == label.tag})
        }
    }
    
}

extension GameFilterViewController : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,Gamingable {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterGameDtos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(type: GameCell.self, indexPath: indexPath)
        let dto = filterGameDtos[indexPath.row]
//        cell.configureCell(gameDto: dto)
        cell.rxLike().subscribeSuccess {[weak self] (_) in
            self?.handleLike(dto: dto)
            }.disposed(by: disposeBag)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let groupId = groupId ,
              let groupIdInt = Int(groupId)
              else {return}
        let dto = filterGameDtos[indexPath.row]
        enterGame(game_group_id: groupIdInt, game_id: dto.id)
    }
    
}
