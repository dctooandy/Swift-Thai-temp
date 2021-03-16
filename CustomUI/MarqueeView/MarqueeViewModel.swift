//
//  MarqueeViewModel.swift
//  betlead
//
//  Created by Victor on 2019/10/3.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MarqueeViewModel: BaseViewModel {
    let marqueeDtos = BehaviorRelay<[News]>(value: [])
    let selectedMarquee = PublishSubject<News>()
    
    override init() {
        super.init()
        Beans.newsServer.getMarqueeNews().subscribeSuccess { [weak self] (dtos) in
            if dtos.count>0
            {
                self?.marqueeDtos.accept(dtos)
                self?.bind()
            }else
            {
                self?.marqueeDtos.accept([News()])
                self?.selectedMarquee.onNext(News())
                
            }
        }.disposed(by: disposeBag)

    }
    
    func bind() {
        let timer = Observable<Int>.timer(0, period: 5, scheduler: MainScheduler.instance)
            .map { [weak self] (index) -> Int in
                guard let weakSelf = self , index != 0 else { return 0 }
                return index%weakSelf.marqueeDtos.value.count
        }
        
        Observable.combineLatest(marqueeDtos.asObservable(),timer) {dtos, index -> News in
            return dtos[index]
        }
        .subscribeSuccess(selectedMarquee)
        .disposed(by: disposeBag)
    }
}
