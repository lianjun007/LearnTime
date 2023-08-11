//
//  SignViewController.swift
//  LearnTime
//
//  Created by LianJun on 2023/8/10.
//

import UIKit
import LeanCloud

class SignViewController: UIViewController {

    let userNameBox = UITextField()
    let passwordBox = UITextField()
    let emailBox = UITextField()
    let phoneBox = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "注册", mode: .basic)
        
        userNameBox.borderStyle = .roundedRect
        userNameBox.placeholder = "请输入用户名"
        view.addSubview(userNameBox)
        userNameBox.snp.makeConstraints { make in
            make.top.equalTo(Spaced.navigation())
            make.left.equalTo(view.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-Spaced.screen())
            make.height.equalTo(44)
        }
        
        passwordBox.borderStyle = .roundedRect
        passwordBox.placeholder = "请输入密码"
        view.addSubview(passwordBox)
        passwordBox.snp.makeConstraints { make in
            make.top.equalTo(userNameBox.snp.bottom).offset(Spaced.control())
            make.left.equalTo(view.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-Spaced.screen())
            make.height.equalTo(44)
        }
        
        emailBox.borderStyle = .roundedRect
        emailBox.placeholder = "请输入邮箱"
        view.addSubview(emailBox)
        emailBox.snp.makeConstraints { make in
            make.top.equalTo(passwordBox.snp.bottom).offset(Spaced.control())
            make.left.equalTo(view.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-Spaced.screen())
            make.height.equalTo(44)
        }
        
        phoneBox.borderStyle = .roundedRect
        phoneBox.placeholder = "请输入手机号"
        view.addSubview(phoneBox)
        phoneBox.snp.makeConstraints { make in
            make.top.equalTo(emailBox.snp.bottom).offset(Spaced.control())
            make.left.equalTo(view.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-Spaced.screen())
            make.height.equalTo(44)
        }
        
        let signButton = UIButton()
        signButton.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        signButton.layer.cornerRadius = 15
        view.addSubview(signButton)
        signButton.snp.makeConstraints { make in
            make.top.equalTo(phoneBox.snp.bottom).offset(Spaced.control())
            make.left.equalTo(view.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-Spaced.screen())
            make.height.equalTo(44)
        }
        signButton.addTarget(self, action: #selector(clickedSignButton), for: .touchUpInside)
        
        let signInButton = UIButton()
        signInButton.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
        signInButton.layer.cornerRadius = 15
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(signButton.snp.bottom).offset(Spaced.control())
            make.left.equalTo(view.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-Spaced.screen())
            make.height.equalTo(44)
        }
        signInButton.addTarget(self, action: #selector(clickedSignInButton), for: .touchUpInside)
    }
    
    @objc func clickedSignButton() {
        guard let username = userNameBox.text, let password = passwordBox.text, let email = emailBox.text, let phone = phoneBox.text else {
            // 处理用户名或密码为nil的情况
            return
        }
        
        do {
            // 创建实例
            let user = LCUser()

            // 等同于 user.set("username", value: "Tom")
            user.username = LCString(username)
            user.password = LCString(password)

            // 可选
            user.email = LCString(email)
            user.mobilePhoneNumber = LCString(phone)

            // 设置其他属性的方法跟 LCObject 一样
            try user.set("gender", value: "secret")

            _ = user.signUp { (result) in
                switch result {
                case .success:
                    break
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    @objc func clickedSignInButton() {
        guard let username = userNameBox.text, let password = passwordBox.text else {
            // 处理用户名或密码为nil的情况
            return
        }
        
        _ = LCUser.logIn(username: username, password: password) { result in
            switch result {
            case .success(object: let user):
                print(user)
                NotificationCenter.default.post(name: changeAccountNotification, object: nil)
            case .failure(error: let error):
                print(error)
            }
        }
    }

}
