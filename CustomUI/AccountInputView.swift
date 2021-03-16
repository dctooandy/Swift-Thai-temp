//
//  AccountInputView.swift
//  betlead
//
//  Created by Victor on 2019/6/5.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class AccountInputView: UIView {

    var isRemember: Bool = false
    var line1 = UIView()
    var line2 = UIView()
    var line3 = UIView()
    var line4 = UIView()
  
    var accountLabel = UILabel()
    var passwordLabel = UILabel()
    var phoneLabel = UILabel()
    var mailLabel = UILabel()

    var accountTextField = UITextField()
    var passwordTextField = UITextField()
    var phoneTextField = UITextField()
    var mailTextField = UITextField()
    
    var accountInvalidLabel = UILabel()
    var passwordInvalidLabel = UILabel()
    var phoneInvalidLabel = UILabel()
    var mailInvalidLabel = UILabel()
    
    let passwordRightButton = UIButton()
    let rememberPWCheckLabel: UILabel = {
        let label = UILabel()
        label.text = "✓"
        label.textColor = #colorLiteral(red: 0.9478314519, green: 0.08514311165, blue: 0.486807704, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    let rememberPWLabel : UILabel = {
        let label = UILabel()
        label.text = "記住密碼".LocalizedString
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.4711072445, green: 0.3156135678, blue: 0.4212393165, alpha: 1)
        label.font = Fonts.pingFangTCSemibold(16)
        return label
    }()
    let forgetPWLabel : UILabel = {
        let label = UILabel()
        label.text = "忘記密碼".LocalizedString
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.749516964, green: 0.6279987097, blue: 0.7222363353, alpha: 1)
        label.font = Fonts.pingFangTCSemibold(16)
        return label
    }()
    let finalComfirmLabel: UILabel = {
        let label = UILabel()
        label.text = "賬號或密碼錯誤".LocalizedString
        label.textColor = #colorLiteral(red: 0.9712567925, green: 0.122583665, blue: 0.162686944, alpha: 1)
        label.textAlignment = .center
        label.font = Fonts.pingFangTCSemibold(16)
        label.isHidden = true
        label.alpha = 0
        return label
    }()
    private var lineColor: UIColor = .white
    private var inputMode: LoginMode = .account
    private var isLogin: Bool = true
    
    private let displayPwdImg = UIImage(named: "iconEye1")
    private let undisplayPwdImg =  UIImage(named: "iconEye2")
    
    private let onClick = PublishSubject<String>()
    private let dpg = DisposeBag()
    private let accountCheckPassed = BehaviorSubject(value: false)
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    convenience init(inputMode: LoginMode, isLogin: Bool, lineColor: UIColor) {
        self.init(frame: .zero)
        self.inputMode = inputMode
        self.isLogin = isLogin
        self.lineColor = lineColor
        self.setup()
        self.bindPwdButton()
        self.bindTextfield()
        self.bindStyle()
    }
    
    private func bindStyle() {
//        if !isLogin {
//            Themes.dreamWorkBlackAndWhite.bind(to: accountTextField.rx.textColor).disposed(by: dpg)
//            Themes.dreamWorkBlackAndWhite.bind(to: passwordTextField.rx.textColor).disposed(by: dpg)
//            Themes.dreamWorkGrayBaseAndWhite.bind(to: passwordRightButton.rx.tintColor).disposed(by: dpg)
//        }else
//        {
//            Themes.dreamWorkBlackAndWhite.bind(to: accountTextField.rx.textColor).disposed(by: dpg)
//            Themes.dreamWorkBlackAndWhite.bind(to: passwordTextField.rx.textColor).disposed(by: dpg)
//            Themes.dreamWorkGrayBaseAndWhite.bind(to: passwordRightButton.rx.tintColor).disposed(by: dpg)
//        }
        
    }
    
    func bindPwdButton() {
        
        passwordRightButton.rx.tap
            .subscribeSuccess { [weak self] in
                self?.pwdRightButtonPressed()
        }.disposed(by: dpg)
        rememberPWCheckLabel.rx.click.subscribeSuccess { [weak self] in
            self?.bindRememberPWCheckLabelUI(showClick: self!.isRemember)
        }.disposed(by: dpg)
    }
    
    func bindRememberPWCheckLabelUI(showClick:Bool)
    {
        rememberPWCheckLabel.text = (!showClick ? "✓" : "")
        isRemember = !showClick
        passwordRightButton.isHidden = isRemember

        if passwordTextField.isSecureTextEntry == false
        {
            passwordRightButton.sendActions(for: .touchUpInside)
        }
    }
    func handleRemeberPW()
    {
        if isRemember == true
        {
            KeychainManager.share.setRemeberPW(passwordTextField.text!)
            
        }else
        {
            KeychainManager.share.clearRememberPW()
        }
    }
    func bindTextfield() {
        // Login
        let isLoginAccountValid = accountTextField.rx.text
            .map { [weak self] (str) -> CGFloat in
                guard let strongSelf = self, let acc = str else { return 1.0  }
                if strongSelf.inputMode == .phone {
                    return RegexHelper.match(pattern:. phone, input: acc) ? 0.0:1.0
                }
                return RegexHelper.match(pattern: .account, input: acc) ? 0.0:1.0
        }
        let isLoginPasswordValid = passwordTextField.rx.text
            .map { [weak self] (str) -> CGFloat in
                guard let strongSelf = self, let acc = str else { return 1.0 }
                if strongSelf.inputMode == .phone {
                    return RegexHelper.match(pattern: .otp, input: acc) ? 0.0:1.0
                }
                return RegexHelper.match(pattern: .password, input: acc) ? 0.0:1.0
        }
        //signup
        let isAccountValid = accountTextField.rx.text
            .map { [weak self] (str) -> CGFloat in
                guard let strongSelf = self, let acc = str else { return 1.0  }
                if strongSelf.inputMode == .phone {
                    return (RegexHelper.match(pattern:. phone, input: acc) && acc.count > 0 ) ? 0.0:1.0
                }
                return (RegexHelper.match(pattern:. account, input: acc) && acc.count > 0 ) ? 0.0:1.0
        }
        let isPasswordValid = passwordTextField.rx.text
            .map { [weak self] (str) -> CGFloat in
                guard let strongSelf = self, let acc = str else { return 1.0 }
                if strongSelf.inputMode == .phone {
                    return (RegexHelper.match(pattern: .otp, input: acc) && acc.count > 0 ) ? 0.0:1.0
                }
                return (RegexHelper.match(pattern: .password, input: acc) && acc.count > 0 ) ? 0.0:1.0
        }
        let isPhoneValid = phoneTextField.rx.text
            .map { [weak self] (str) -> CGFloat in
                guard let strongSelf = self, let acc = str else { return 1.0  }
                if strongSelf.inputMode == .phone {
                    return (RegexHelper.match(pattern:. phone, input: acc) && acc.count > 0 ) ? 0.0:1.0
                }
                return (RegexHelper.match(pattern: .phone, input: acc) && acc.count > 0 ) ? 0.0:1.0
        }
        let isMailValid = mailTextField.rx.text
            .map { [weak self] (str) -> CGFloat in
                guard let strongSelf = self, let acc = str else { return 1.0 }
                if strongSelf.inputMode == .phone {
                    return (RegexHelper.match(pattern: .otp, input: acc) && acc.count > 0 ) ? 0.0:1.0
                }
                return (RegexHelper.match(pattern: .mail, input: acc) && acc.count > 0 ) ? 0.0:1.0
        }
        
        let isAccountValidColor = accountTextField.rx.text
            .map { [weak self] (str) -> UIColor in
                guard let strongSelf = self, let acc = str else { return Themes.thaiLineNoValid  }
                if strongSelf.inputMode == .phone {
                    return RegexHelper.match(pattern:. phone, input: acc) ? Themes.thaiLineNormal : Themes.thaiLineNoValid
                }
                return RegexHelper.match(pattern: .account, input: acc) ? Themes.thaiLineNormal : Themes.thaiLineNoValid
        }
        let isPasswordValidColor = passwordTextField.rx.text
            .map { [weak self] (str) -> UIColor in
                guard let strongSelf = self, let acc = str else { return Themes.thaiLineNoValid }
                if strongSelf.inputMode == .phone {
                    return RegexHelper.match(pattern: .otp, input: acc) ? Themes.thaiLineNormal : Themes.thaiLineNoValid
                }
                return RegexHelper.match(pattern: .password, input: acc) ? Themes.thaiLineNormal : Themes.thaiLineNoValid
        }
        let isPhoneValidColor = phoneTextField.rx.text
            .map { [weak self] (str) -> UIColor in
                guard let strongSelf = self, let acc = str else { return Themes.thaiLineNoValid  }
                if strongSelf.inputMode == .phone {
                    return RegexHelper.match(pattern:. phone, input: acc) ? Themes.thaiLineNormal : Themes.thaiLineNoValid
                }
                return RegexHelper.match(pattern: .phone, input: acc) ? Themes.thaiLineNormal : Themes.thaiLineNoValid
        }
        let isMailValidColor = mailTextField.rx.text
            .map { [weak self] (str) -> UIColor in
                guard let strongSelf = self, let acc = str else { return Themes.thaiLineNoValid }
                if strongSelf.inputMode == .phone {
                    return RegexHelper.match(pattern: .mail, input: acc) ? Themes.thaiLineNormal : Themes.thaiLineNoValid
                }
                return RegexHelper.match(pattern: .mail, input: acc) ? Themes.thaiLineNormal : Themes.thaiLineNoValid
        }

        isAccountValid.skip(1).bind(to: accountInvalidLabel.rx.alpha).disposed(by: dpg)
        isPasswordValid.skip(1).bind(to: passwordInvalidLabel.rx.alpha).disposed(by: dpg)
        isPhoneValid.skip(1).bind(to: phoneInvalidLabel.rx.alpha).disposed(by: dpg)
        isMailValid.skip(1).bind(to: mailInvalidLabel.rx.alpha).disposed(by: dpg)
        
        isAccountValidColor.skip(1).subscribeSuccess { (color) in
            (self.superview?.isKind(of: UIScrollView.self))! ? (self.superview as? UIScrollView)?.updateContentView() : nil
            isAccountValidColor.skip(1).bind(to: self.line1.rx.backgroundColor).disposed(by: self.dpg)
        }.disposed(by: dpg)
        isPasswordValidColor.skip(1).subscribeSuccess { (color) in
            (self.superview?.isKind(of: UIScrollView.self))! ? (self.superview as? UIScrollView)?.updateContentView() : nil
            isPasswordValidColor.skip(1).bind(to: self.line2.rx.backgroundColor).disposed(by: self.dpg)
        }.disposed(by: dpg)
        isPhoneValidColor.skip(1).subscribeSuccess { (color) in
            (self.superview?.isKind(of: UIScrollView.self))! ? (self.superview as? UIScrollView)?.updateContentView() : nil
            isPhoneValidColor.skip(1).bind(to: self.line3.rx.backgroundColor).disposed(by: self.dpg)
        }.disposed(by: dpg)
        isMailValidColor.skip(1).subscribeSuccess { (color) in
            (self.superview?.isKind(of: UIScrollView.self))! ? (self.superview as? UIScrollView)?.updateContentView() : nil
            isMailValidColor.skip(1).bind(to: self.line4.rx.backgroundColor).disposed(by: self.dpg)
        }.disposed(by: dpg)
//        isPasswordValidColor.skip(1).bind(to: line2.rx.backgroundColor).disposed(by: dpg)
//        isPhoneValidColor.skip(1).bind(to: line3.rx.backgroundColor).disposed(by: dpg)
//        isMailValidColor.skip(1).bind(to: line4.rx.backgroundColor).disposed(by: dpg)

//        Observable.combineLatest(isAccountValid, isPasswordValid)
//            .map { return ($0.0 == 1.0) && ($0.1 == 1.0) } //reget match result
//            .bind(to: accountCheckPassed)
//            .disposed(by: dpg)
        Observable.combineLatest(isLoginAccountValid, isLoginPasswordValid)
            .map { v in
                let final = (v.0 == 0.0) && (v.1 == 0.0)
                return self.isLogin ? final : true } //reget match result
              .bind(to: finalComfirmLabel.rx.isHidden)
              .disposed(by: dpg)
        Observable.combineLatest(isAccountValid, isPasswordValid , isPhoneValid , isMailValid)
            .map { v in
                let signupFinal = (v.0 == 0.0) && (v.1 == 0.0) && (v.2 == 0.0) && (v.3 == 0.0)
                let loginFinal = (v.0 == 0.0) && (v.1 == 0.0)
                return self.isLogin ? loginFinal : signupFinal  } //reget match result
              .bind(to: accountCheckPassed)
              .disposed(by: dpg)
        finalComfirmLabel.isHidden = true
    }
    
    func rxCheckPassed() -> Observable<Bool> {
        return accountCheckPassed.asObserver()
    }
    
    func cleanTextField() {
//        accountTextField.text = ""
//        passwordTextField.text = ""
        phoneTextField.text = ""
        mailTextField.text = ""
        accountInvalidLabel.alpha = 0.0
        passwordInvalidLabel.alpha = 0.0
        phoneInvalidLabel.alpha = 0.0
        mailInvalidLabel.alpha = 0.0
        line1.backgroundColor = Themes.thaiLineNormal
        line2.backgroundColor = Themes.thaiLineNormal
        line3.backgroundColor = Themes.thaiLineNormal
        line4.backgroundColor = Themes.thaiLineNormal
        finalComfirmLabel.isHidden = true
    }
    func createStackView(subviews:[UIView]) -> UIStackView {
            let stView = UIStackView(arrangedSubviews: subviews)
            stView.alignment = .fill
            stView.distribution = .fillProportionally
            stView.axis = .vertical
            stView.spacing = 0
            return stView
    }
    func createTitleLabel(withTitle:String) -> UILabel
    {
        let label = UILabel()
        label.text = withTitle
        label.font = Fonts.pingFangTCSemibold(18)
        label.textColor = #colorLiteral(red: 0.3242773414, green: 0.1374932826, blue: 0.2745029628, alpha: 1)
        return label

    }
    func createTextfield(_ leftString:String = "" ) -> UITextField
    {
        let tf = UITextField()
        tf.font = Fonts.pingFangTCRegular(17)
        tf.textColor = Themes.thaiLineText
        tf.borderStyle = .none
        if leftString.count != 0
        {
            tf.setLeftPaddingPoints(60)
            let label = UILabel()
            tf.addSubview(label)
            label.textAlignment = .left
            label.text = leftString
            label.textColor = #colorLiteral(red: 0.3617268801, green: 0.181427598, blue: 0.3047042787, alpha: 1)
            label.snp.makeConstraints { (make) in
                make.left.top.bottom.equalToSuperview()
                make.width.equalTo(width(60/414))
            }
        }
        return tf
    }
    func createLine() -> UIView{
        let botomLine = UIView()
        botomLine.backgroundColor = Themes.thaiLineNormal
        return botomLine
    }
    func createInvalidLabel() -> UILabel{
        let lb = UILabel()
        lb.font = Fonts.pingFangTCRegular(14)
        lb.textAlignment = .left
        lb.textColor = .red
//        lb.isHidden = true
        lb.alpha = 0.0
        lb.numberOfLines = 0
        lb.lineBreakMode = .byClipping
        return lb
    }
    func setup() {

        accountLabel = createTitleLabel(withTitle: "帳號".LocalizedString)
        passwordLabel = createTitleLabel(withTitle: "密碼".LocalizedString)
        phoneLabel = createTitleLabel(withTitle: "手機".LocalizedString)
        mailLabel = createTitleLabel(withTitle: "郵箱".LocalizedString)

        accountTextField = createTextfield()
        passwordTextField = createTextfield()
        phoneTextField = createTextfield()
        mailTextField = createTextfield()
        
        line1 = createLine()
        line2 = createLine()
        line3 = createLine()
        line4 = createLine()
        
        accountInvalidLabel = createInvalidLabel()
        passwordInvalidLabel = createInvalidLabel()
        phoneInvalidLabel = createInvalidLabel()
        mailInvalidLabel = createInvalidLabel()
        
        
        let accountStackView = createStackView(subviews: [accountLabel, accountTextField, line1,accountInvalidLabel])
        let passwordStackView = createStackView(subviews: [passwordLabel, passwordTextField, line2,passwordInvalidLabel])
        let phoneStackView = createStackView(subviews: [phoneLabel, phoneTextField, line3,phoneInvalidLabel])
        let mailStackView = createStackView(subviews: [mailLabel, mailTextField, line4,mailInvalidLabel])
        
        addSubview(accountStackView)
        addSubview(passwordStackView)
        addSubview(phoneStackView)
        addSubview(mailStackView)
//        addSubview(accountLabel)
//        addSubview(accountTextField)
//        addSubview(line1)
//        addSubview(accountInvalidLabel)
        
//        addSubview(passwordLabel)
//        addSubview(passwordTextField)
//        addSubview(line2)
//        addSubview(passwordInvalidLabel)
        addSubview(passwordRightButton)
        
//        addSubview(phoneLabel)
//        addSubview(phoneTextField)
//        addSubview(line3)
//        addSubview(phoneInvalidLabel)
//
//        addSubview(mailLabel)
//        addSubview(mailTextField)
//        addSubview(line4)
//        addSubview(mailInvalidLabel)
        
        addSubview(rememberPWCheckLabel)
        addSubview(rememberPWLabel)
        addSubview(forgetPWLabel)
        addSubview(finalComfirmLabel)
        accountTextField.delegate = self
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        passwordRightButton.tintColor = isLogin ? .white : Themes.grayLighter
        passwordRightButton.isHidden = true
        resetUI()
        let titleMulH = height(25/812)
        let textFieldMulH = height(35/812)
        let invalidH = height(25/812)

        
        accountStackView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        passwordStackView.snp.makeConstraints { (make) in
            make.top.equalTo(accountStackView.snp.bottom).offset(topOffset(10/812))
            make.left.right.equalToSuperview()
        }
        phoneStackView.snp.makeConstraints { (make) in
            make.top.equalTo(passwordStackView.snp.bottom).offset(topOffset(10/812))
            make.left.right.equalToSuperview()
        }
        mailStackView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneStackView.snp.bottom).offset(topOffset(10/812))
            make.left.right.equalToSuperview()
        }
        
        accountLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(titleMulH)
        }
        accountTextField.snp.makeConstraints { (make) in
            make.top.equalTo(accountLabel.snp.bottom).offset(2)
            make.left.right.equalToSuperview()
            make.height.equalTo(textFieldMulH)
        }
        line1.snp.makeConstraints { (make) in
            make.top.equalTo(accountTextField.snp.bottom)//.offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(height(2/818))
        }
        accountInvalidLabel.snp.makeConstraints { (make) in
            make.top.equalTo(line1.snp.bottom).offset(5)
            make.left.right.equalTo(line1)
            make.height.equalTo(invalidH)
            make.bottom.equalTo(accountStackView)
        }
        
        passwordLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(titleMulH)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(textFieldMulH)
        }
        line2.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom)//.offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(height(2/818))
        }
        passwordInvalidLabel.snp.makeConstraints { (make) in
            make.top.equalTo(line2.snp.bottom).offset(5)
            make.left.equalTo(line2)
            make.height.equalTo(invalidH)
            make.bottom.equalTo(passwordStackView)
        }
        
        phoneLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(titleMulH)
        }
        phoneTextField.snp.makeConstraints { (make) in
            make.top.equalTo(phoneLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(textFieldMulH)
        }
        line3.snp.makeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.bottom)//.offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(height(2/818))
        }
        phoneInvalidLabel.snp.makeConstraints { (make) in
            make.top.equalTo(line3.snp.bottom).offset(5)
            make.left.equalTo(line3)
            make.height.equalTo(invalidH)
            make.bottom.equalTo(phoneStackView)
        }
        
        mailLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(titleMulH)
        }
        mailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(mailLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(textFieldMulH)
        }
        line4.snp.makeConstraints { (make) in
            make.top.equalTo(mailTextField.snp.bottom)//.offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(height(2/818))
        }
        mailInvalidLabel.snp.makeConstraints { (make) in
            make.top.equalTo(line4.snp.bottom).offset(5)
            make.left.equalTo(line2)
            make.height.equalTo(invalidH)
            make.bottom.equalTo(mailStackView)
        }
        
        rememberPWCheckLabel.snp.makeConstraints { (make) in
            make.left.equalTo(line2)
            make.top.equalTo(passwordInvalidLabel.snp.bottom).offset(50)
            make.width.height.equalTo(width(24/414))
        }
        rememberPWCheckLabel.layer.cornerRadius = 5
        rememberPWCheckLabel.layer.borderColor = #colorLiteral(red: 0.9146220088, green: 0.9147503972, blue: 0.9145815969, alpha: 1).cgColor
        rememberPWCheckLabel.layer.borderWidth = 1
        rememberPWLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(rememberPWCheckLabel)
            make.left.equalTo(rememberPWCheckLabel.snp.right).offset(10)
            make.height.equalTo(width(24/414))
            make.width.equalTo(width(100/414))
        }
        forgetPWLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(rememberPWCheckLabel)
            make.right.equalTo(line2)
            make.height.equalTo(width(24/414))
            make.width.equalTo(width(100/414))
        }

        finalComfirmLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-invalidH)
            make.centerX.equalToSuperview()
            make.width.equalTo(Views.screenWidth * 0.8067)
            make.height.equalTo(invalidH)
        }
//        if isLogin {
//            accountTextField.setMaskView()
//            passwordTextField.setMaskView()
//        }
    }

    func setPasswordRightBtnTime(_ second: Int) {
        if second == 0 {
            passwordRightButton.setTitle("重发送", for: .normal)
            return
        }
        passwordRightButton.setTitle("重发送(\(second)s)", for: .normal)
    }
    
    func setPasswordRightBtnEnable(isEnable: Bool) {
         passwordRightButton.isEnabled = isEnable
    }
    
    func changeInputMode(mode: LoginMode , withClean : Bool = false) {
        inputMode = mode
        resetUI(clean: withClean)
    }
    
    private func resetUI(clean : Bool = false) {
        bindStyle()
        rememberPWCheckLabel.isHidden = !isLogin
        rememberPWLabel.isHidden = !isLogin
        forgetPWLabel.isHidden = !isLogin
        line3.isHidden = isLogin
        line4.isHidden = isLogin
        accountLabel.isHidden = isLogin
        passwordLabel.isHidden = isLogin
        phoneLabel.isHidden = isLogin
        mailLabel.isHidden = isLogin
        phoneTextField.isHidden = isLogin
        mailTextField.isHidden = isLogin
        isRemember = !KeychainManager.share.getRememberPW().isEmpty
        rememberPWCheckLabel.text = (isRemember ? "✓" : "")
        if clean == true
        {
            accountTextField.text = ""
            passwordTextField.text = ""
        }else
        {
            accountTextField.text = KeychainManager.share.getLastAccount()?.account
            passwordTextField.text = KeychainManager.share.getRememberPW()
        }
//        accountTextField.textColor = Themes.thaiLineText
//        passwordTextField.textColor = Themes.thaiLineText
//        phoneTextField.textColor = Themes.thaiLineText
//        mailTextField.textColor = Themes.thaiLineText
        if isLogin {
            accountInvalidLabel.text = "請輸入正確帳號".LocalizedString
            passwordInvalidLabel.text = "請輸入正確密碼".LocalizedString
            accountTextField.setPlaceholder(inputMode.accountPlacehloder(), with: Themes.thaiPink)
            passwordTextField.setPlaceholder(inputMode.pwdPlaceholder(), with: Themes.thaiPink)
            passwordRightButton.tintColor = .white
        } else {
            phoneTextField.keyboardType = .phonePad
            accountInvalidLabel.text = "請輸入5~15字符(A-Z ,a-z,0-9)".LocalizedString
            passwordInvalidLabel.text = "請輸入8~20字母或下劃線和數字、不含特殊符號".LocalizedString
            phoneInvalidLabel.text = "請輸入正確手機號碼".LocalizedString
            mailInvalidLabel.text = "請輸入正確郵箱".LocalizedString
            accountTextField.setPlaceholder(inputMode.signupAccountPlacehloder(), with: Themes.thaiPink)
            passwordTextField.setPlaceholder(inputMode.signupPwdPlaceholder(), with: Themes.thaiPink)
            phoneTextField.setPlaceholder(inputMode.signupPhonePlaceholder(), with: Themes.thaiPink)
            mailTextField.setPlaceholder(inputMode.signupMailPlaceholder(), with: Themes.thaiPink)
            passwordRightButton.tintColor = Themes.grayLight
        }
        
        switch inputMode {
            
        case .account:

            passwordRightButton.frame.size.width = 24
            passwordRightButton.setTitle(nil, for: .normal)
            passwordRightButton.setBackgroundImage(displayPwdImg, for: .normal)
            passwordTextField.isSecureTextEntry = true
            passwordRightButton.snp.remakeConstraints { (make) in
                make.right.equalToSuperview()
                make.centerY.equalTo(passwordTextField)
                make.width.height.equalTo(24)
            }
            
        case .phone:
            
            accountTextField.keyboardType = .phonePad
            accountInvalidLabel.text = "請輸入正確手機號碼".LocalizedString
            passwordInvalidLabel.text = "请输入6位数字验证码"
            passwordRightButton.titleLabel?.font = Fonts.pingFangTCRegular(14)
            passwordRightButton.setTitleColor(Themes.secondaryYellow, for: .normal)
            passwordRightButton.setTitle("  " + "發送驗證碼".LocalizedString + "  ", for: .normal)
            passwordRightButton.setBackgroundImage(nil, for: .normal)
            passwordTextField.isSecureTextEntry = false
            passwordRightButton.snp.remakeConstraints { (make) in
                make.right.equalToSuperview()
                make.centerY.equalTo(passwordTextField)
                make.height.equalTo(24)
            }
         case .thaiLuckPage:
            print("")
        }
    }
    
    private func pwdRightButtonPressed() {
        
        switch inputMode {
        case .account:
            passwordTextField.isSecureTextEntry = !(passwordTextField.isSecureTextEntry)
            passwordRightButton.setBackgroundImage(passwordTextField.isSecureTextEntry ? displayPwdImg : undisplayPwdImg , for: .normal)
        case .phone:
            onClick.onNext(accountTextField.text!)
        case .thaiLuckPage:
            print("")
        }
    }
    
    func rxVerifyCodeButtonClick() -> Observable<String> {
        return onClick.asObserver()
    }
}


extension AccountInputView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == phoneTextField
        {
            if textField.text!.count > 10
            {
                return false
            }else
            {
                return true
            }
        }else
        {
            return true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == phoneTextField
        {
            var result = false
            if let text = textField.text, let range = Range(range, in: text) {
                let newText = text.replacingCharacters(in: range, with: string)
                if newText.count < 11 {
                    result = true
                }
            }
            return result
        }else
        {
            return true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
