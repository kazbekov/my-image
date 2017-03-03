//
//  SignUpViewController.swift
//  myImage
//
//  Created by Damir Kazbekov on 3/3/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Foundation
import Cartography
import ActiveLabel
import ChameleonFramework
import KMPlaceholderTextView

class SignUpViewController: UIViewController {
    //MARK: -Properties
    var keyboardHeight: CGFloat = 0.0
    
    private lazy var closeButton: UIButton = {
        return UIButton().then {
            $0.setImage(#imageLiteral(resourceName: "exit-icon"), for: .normal)
            $0.sizeToFit()
            $0.setTitleColor(HexColor("684BE0"), for: .normal)
            $0.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        }
    }()
    
    private lazy var emailLabel: UILabel = {
        return UILabel().then {
            $0.text = "Почта"
            $0.textColor = HexColor("979797")
            $0.font = .systemFont(ofSize: 14.0, weight: 0.2)
        }
    }()
    
    private lazy var titleLabel: UILabel = {
        return UILabel().then {
            $0.text = "Введите адрес своей почты чтобы войти или зарегистрироваться"
            $0.textColor = HexColor("000000")
            $0.font = .systemFont(ofSize: 15.0, weight: 0)
            $0.numberOfLines = 0
        }
    }()
    
    private lazy var emailTextField = UITextField().then {
        $0.becomeFirstResponder()
        $0.keyboardType = .emailAddress
        $0.autocorrectionType = .no
        $0.placeholder = "example@example.com"
    }
    
    private lazy var submitButton: UIButton = {
        return UIButton().then {
            $0.setTitle("Войти / Регистрация", for: .normal)
            $0.setTitleColor(HexColor("7C67E6"), for: .normal)
            $0.setTitleColor(HexColor("979797"), for: .highlighted)
            $0.titleLabel?.font = .systemFont(ofSize: 14.0)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = HexColor("7C67E6")?.cgColor
            $0.layer.cornerRadius = 3
        }
    }()
    
    let termsOfPrivacyLabel = ActiveLabel()
    
    //MARK: -Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    override func viewDidLayoutSubviews() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = HexColor("979797")?.cgColor
        border.frame = CGRect(x: 0, y: emailTextField.frame.size.height - width, width:  emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        border.borderWidth = width
        emailTextField.layer.addSublayer(border)
        emailTextField.layer.masksToBounds = true
    }
    
    //MARK: - Setups
    func setUpViews(){
        let customType = ActiveType.custom(pattern: "\\sусловиями использования приложения\\b")
        termsOfPrivacyLabel.customize { termsOfPrivacyLabel in
            termsOfPrivacyLabel.text = "Продолжая вы соглашаетесь с условиями использования приложения."
            termsOfPrivacyLabel.numberOfLines = 0
            termsOfPrivacyLabel.textColor = HexColor("989898")
            termsOfPrivacyLabel.font = .systemFont(ofSize: 13.0)
            termsOfPrivacyLabel.textAlignment = .center
            termsOfPrivacyLabel.enabledTypes = [.mention, .hashtag, .url, customType]
            termsOfPrivacyLabel.customColor[customType] = HexColor("7C67E6")
            termsOfPrivacyLabel.customSelectedColor[customType] = HexColor("7C67E9")
        }
        termsOfPrivacyLabel.handleCustomTap(for: customType) { element in
            print("Custom type tapped: \(element)")
        }
        
        view.backgroundColor = .white
        [closeButton, emailTextField, termsOfPrivacyLabel, submitButton, emailLabel, titleLabel].forEach{
            view.addSubview($0)
        }
    }
    func setUpConstraints(){
        constrain(closeButton, emailTextField, termsOfPrivacyLabel, submitButton,view){ close, email, privacy, submit, view in
            close.top == view.top + 30
            close.leading == view.leading + 15
            
            email.bottom == submit.top * 0.8
            email.width == view.width * 0.8
            email.centerX == view.centerX
            email.height == 44
            
            
            privacy.centerX == view.centerX
            privacy.width == view.width * 0.8
            
            submit.bottom == privacy.top * 0.9
            submit.centerX == view.centerX
            submit.width == view.width * 0.5
            submit.height == 44
        }
        constrain(emailLabel, emailTextField, titleLabel, closeButton, view) {label, textField, title, close, view in
            label.bottom == textField.top
            label.leading == textField.leading
            
            title.leading == close.trailing + 10
            title.centerY == close.centerY
            title.trailing == view.trailing - 10
        }
    }
    //MARK: -Actions
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            constrain(termsOfPrivacyLabel, view) { privacy, view in
                privacy.bottom == view.bottom - keyboardHeight - 30
            }
        }
    }
}

