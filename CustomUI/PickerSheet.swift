//
//  CategoryPickerViewController.swift
//  betlead
//
//  Created by Victor on 2019/6/24.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PickerSheet: BottomSheet {
    
    var doneButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("完成", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        return btn
    }()
    
    var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        return btn
    }()
    
    var categoryTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "类别"
        lb.font = Fonts.pingFangTCRegular(16)
        lb.textAlignment = .center
        return lb
    }()
    
    var mainPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .clear
        return picker
    }()
    
    private var onSelected = PublishSubject<Int>()
    var selectedRow: Int = 0
    var titles: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
        bindStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainPickerView.selectRow(selectedRow, inComponent: 0, animated: false)
    }
    
    required init() {
        super.init()
    }
    
    
    required init(_ parameters: Any? = nil) {
        fatalError("init(_:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCatgory(_ titles: [String], selected: Int = 0,barTitle: String = "类别") {
        self.selectedRow = selected
        self.titles = titles
        self.categoryTitleLabel.text = barTitle
    }
    private func bindStyle() {
        Themes.dreamWorkWhiteAndDarkBase.bind(to: defaultContainer.rx.backgroundColor).disposed(by: disposeBag)
        Themes.dreamWorkPrimaryBaseAndYellow.bind(to: cancelButton.rx.textColor).disposed(by: disposeBag)
        Themes.dreamWorkPrimaryBaseAndYellow.bind(to: doneButton.rx.textColor).disposed(by: disposeBag)
        Themes.dreamWorkBlackAndWhite.bind(to: categoryTitleLabel.rx.textColor).disposed(by: disposeBag)
        
    }
    
    private func setup() {
        mainPickerView.delegate = self
        mainPickerView.dataSource = self
        defaultContainer.addSubview(doneButton)
        defaultContainer.addSubview(cancelButton)
        defaultContainer.addSubview(categoryTitleLabel)
        defaultContainer.addSubview(mainPickerView)
        defaultContainer.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(55)
        }
        
        categoryTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(cancelButton.snp.right)
            make.height.equalTo(44)
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.left.equalTo(categoryTitleLabel.snp.right)
            make.height.equalTo(44)
            make.width.equalTo(55)
        }
        
        mainPickerView.snp.makeConstraints { (make) in
            make.top.equalTo(categoryTitleLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func pickerOnSelected() -> Observable<Int> {
        return onSelected.asObserver()
    }
    
    private func bind() {
        doneButton.rx.tap
            .subscribeSuccess { [weak self] in
            guard let strongSelf = self else { return }
                strongSelf.onSelected.onNext(strongSelf.selectedRow)
                strongSelf.cancel()
            }.disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribeSuccess { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.cancel()
            }.disposed(by: disposeBag)
        
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension PickerSheet: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let color: UIColor = DreamWorkStyle.share.interFaceStyle.value == .light ? .black : .white
        return NSAttributedString(string: titles[row], attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
