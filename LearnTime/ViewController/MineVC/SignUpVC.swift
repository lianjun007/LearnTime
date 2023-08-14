import UIKit
import LeanCloud
import SnapKit

/// 账户注册界面的声明内容
class SignUpViewController: UIViewController {
    /// 底层的滚动视图，最基础的界面
    let underlyView = UIScrollView()
    /// 底层滚动视图的内容视图
    let containerView = UIView()
    
    /// 自动布局顶部参考，用来流式创建控件时定位
    var snpTop: ConstraintRelatableTarget!
    
    /// 用户名输入框
    let userNameInputBox = InsetTextField()
    /// 密码输入框
    let passwordInputBox = InsetTextField()
    /// 邮箱地址输入框
    let emailInputBox = InsetTextField()
    /// 手机号输入框
    let phoneInputBox = InsetTextField()
}

// ♻️控制器的生命周期方法
extension SignUpViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "注册账户", mode: .group)
        // 设置输入框的代理（UITextFieldDelegate）
        userNameInputBox.delegate = self
        passwordInputBox.delegate = self
        emailInputBox.delegate = self
        phoneInputBox.delegate = self
        
        // 设置底层视图和它的容器视图的自动布局
        view.addSubview(underlyView)
        underlyView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        underlyView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(underlyView)
            make.width.equalTo(underlyView)
        }
        
        // 导航栏：导航栏按钮
        moduleNav()
        // 模块1：输入用户名
        snpTop = module1()
        // 模块2：输入密码
        snpTop = module2(snpTop)
        // 模块3：输入邮箱地址
        snpTop = module3(snpTop)
        // 模块4：输入手机号
        snpTop = module4(snpTop)
        // 模块5：注册并且登录按钮
        module5(snpTop)
        
        // 键盘显示和隐藏时触发相关通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// 📦分模块封装控件创建的方法
extension SignUpViewController {
    /// 创建导航栏按钮的方法
    func moduleNav() {
        /// 收起键盘的按钮
        let keyboardHideButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .plain, target: self, action: #selector(keyboardHide))
        keyboardHideButton.tintColor = JunColor.learnTime1()
        navigationItem.rightBarButtonItem = keyboardHideButton
        
        /// 收起此界面的按钮
        let dismissVCButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(dismissVC))
        dismissVCButton.tintColor = JunColor.learnTime1()
        navigationItem.leftBarButtonItem = dismissVCButton
    }
    
    /// 创建模块1的方法
    func module1() -> ConstraintRelatableTarget {
        /// 模块标题
        let title = UIButton().moduleTitleMode("用户名", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(JunSpaced.navigation())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        // 配置用户名输入框
        userNameInputBox.layer.borderWidth = 3
        userNameInputBox.layer.borderColor = JunColor.learnTime1().cgColor
        userNameInputBox.backgroundColor = UIColor.white
        userNameInputBox.layer.cornerRadius = 15
        userNameInputBox.tintColor = UIColor.black.withAlphaComponent(0.6)
        userNameInputBox.font = JunFont.title2()
        userNameInputBox.textColor = UIColor.black.withAlphaComponent(0.6)
        userNameInputBox.placeholder = "必填"
        containerView.addSubview(userNameInputBox)
        userNameInputBox.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(44)
        }
        
        /// 用户名输入框下方的提示控件的提示图标1
        let tipsIcon1 = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon1.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon1)
        tipsIcon1.snp.makeConstraints { make in
            make.top.equalTo(userNameInputBox.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 用户名输入框下方的提示控件的提示内容1
        let tipsLabel1 = UILabel().fontAdaptive("用户名的长度、内容、复杂度、字符类型不作限制，但是不建议过于奇怪。", font: JunFont.tips())
            tipsLabel1.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel1)
            tipsLabel1.snp.makeConstraints { make in
                make.top.equalTo(userNameInputBox.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(tipsIcon1.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        /// 用户名输入框下方的提示控件的提示图标2
        let tipsIcon2 = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon2.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon2)
        tipsIcon2.snp.makeConstraints { make in
            make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 用户名输入框下方的提示控件的提示内容
        let tipsLabel2 = UILabel().fontAdaptive("账户注册成功后用户名不可更改，所有账户的用户名都不可重复，未来将增加用户昵称功能。", font: JunFont.tips())
            tipsLabel2.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel2)
            tipsLabel2.snp.makeConstraints { make in
                make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(tipsIcon2.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        return tipsLabel2.snp.bottom
    }
    
    /// 创建模块1的方法
    func module2(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题
        let title = UIButton().moduleTitleMode("密码", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        // 配置密码输入框
        passwordInputBox.layer.borderWidth = 3
        passwordInputBox.layer.borderColor = JunColor.learnTime1().cgColor
        passwordInputBox.backgroundColor = UIColor.white
        passwordInputBox.layer.cornerRadius = 15
        passwordInputBox.tintColor = UIColor.black.withAlphaComponent(0.6)
        passwordInputBox.font = JunFont.title2()
        passwordInputBox.textColor = UIColor.black.withAlphaComponent(0.6)
        passwordInputBox.placeholder = "必填"
        containerView.addSubview(passwordInputBox)
        passwordInputBox.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(44)
        }
        
        /// 密码输入框下方的提示控件的提示图标1
        let tipsIcon1 = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon1.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon1)
        tipsIcon1.snp.makeConstraints { make in
            make.top.equalTo(passwordInputBox.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 密码输入框下方的提示控件的提示内容1
        let tipsLabel1 = UILabel().fontAdaptive("密码的长度、内容、复杂度、字符类型不作限制，但是不建议过于简单或奇怪。", font: JunFont.tips())
            tipsLabel1.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel1)
            tipsLabel1.snp.makeConstraints { make in
                make.top.equalTo(passwordInputBox.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(tipsIcon1.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        /// 密码输入框下方的提示控件的提示图标2
        let tipsIcon2 = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon2.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon2)
        tipsIcon2.snp.makeConstraints { make in
            make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 密码输入框下方的提示控件的提示内容2
        let tipsLabel2 = UILabel().fontAdaptive("密码是以明文方式通过 HTTPS 加密传输给云端，云端会以密文存储密码。换言之，用户的密码只可能用户本人知道，开发者是无法获取的。详情请查阅 LeanCloud（docs.leancloud.cn）官方技术文档。", font: JunFont.tips())
            tipsLabel2.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel2)
            tipsLabel2.snp.makeConstraints { make in
                make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(tipsIcon2.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        return tipsLabel2.snp.bottom
    }
    
    /// 创建模块3的方法
    func module3(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题
        let title = UIButton().moduleTitleMode("邮箱地址", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        // 配置邮箱地址输入框
        emailInputBox.layer.borderWidth = 3
        emailInputBox.layer.borderColor = JunColor.learnTime1().cgColor
        emailInputBox.backgroundColor = UIColor.white
        emailInputBox.layer.cornerRadius = 15
        emailInputBox.tintColor = UIColor.black.withAlphaComponent(0.6)
        emailInputBox.font = JunFont.title2()
        emailInputBox.textColor = UIColor.black.withAlphaComponent(0.6)
        emailInputBox.placeholder = "选填"
        containerView.addSubview(emailInputBox)
        emailInputBox.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(44)
        }
        
        /// 邮箱输入框下方的提示控件的提示图标
        let tipsIcon1 = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon1.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon1)
        tipsIcon1.snp.makeConstraints { make in
            make.top.equalTo(emailInputBox.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 邮箱输入框下方的提示控件的提示内容
        let tipsLabel1 = UILabel().fontAdaptive("账户绑定邮箱地址时会收到一封验证邮件，验证成功后可以使用邮箱地址和密码组合登录、邮件验证重置密码等功能。", font: JunFont.tips())
            tipsLabel1.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel1)
            tipsLabel1.snp.makeConstraints { make in
                make.top.equalTo(emailInputBox.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(tipsIcon1.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        /// 邮箱地址输入框下方的提示控件的提示图标
        let tipsIcon2 = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon2.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon2)
        tipsIcon2.snp.makeConstraints { make in
            make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 邮箱地址输入框下方的提示控件的提示内容
        let tipsLabel2 = UILabel().fontAdaptive("除此之外，邮箱地址还可以在“关于我的 > 用户名 > 邮箱地址”处进行绑定和验证操作。", font: JunFont.tips())
            tipsLabel2.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel2)
            tipsLabel2.snp.makeConstraints { make in
                make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(tipsIcon2.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        return tipsLabel2.snp.bottom
    }
    
    /// 创建模块4的方法
    func module4(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题
        let title = UIButton().moduleTitleMode("手机号", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        // 配置手机号输入框
        phoneInputBox.layer.borderWidth = 3
        phoneInputBox.layer.borderColor = JunColor.learnTime1().cgColor
        phoneInputBox.backgroundColor = UIColor.white
        phoneInputBox.layer.cornerRadius = 15
        phoneInputBox.tintColor = UIColor.black.withAlphaComponent(0.6)
        phoneInputBox.font = JunFont.title2()
        phoneInputBox.textColor = UIColor.black.withAlphaComponent(0.6)
        phoneInputBox.placeholder = "选填"
        containerView.addSubview(phoneInputBox)
        phoneInputBox.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(44)
        }
        
        /// 手机号输入框下方的提示控件的提示图标1
        let tipsIcon1 = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon1.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon1)
        tipsIcon1.snp.makeConstraints { make in
            make.top.equalTo(phoneInputBox.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 用户名输入框下方的提示控件的提示内容1
        let tipsLabel1 = UILabel().fontAdaptive("账户绑定手机号时会收到一条短信验证码，可以在“关于我的 > 用户名 > 手机号”处进行验证，验证成功后可以使用手机号和密码组合登录、短信验证登录、短信验证重置密码等功能。", font: JunFont.tips())
            tipsLabel1.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel1)
            tipsLabel1.snp.makeConstraints { make in
                make.top.equalTo(phoneInputBox.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(tipsIcon1.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        /// 手机号输入框下方的提示控件的提示图标2
        let tipsIcon2 = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon2.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon2)
        tipsIcon2.snp.makeConstraints { make in
            make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 手机号输入框下方的提示控件的提示内容2
        let tipsLabel2 = UILabel().fontAdaptive("除此之外，手机号还可以在“关于我的 > 用户名 > 手机号”处进行绑定和验证操作。", font: JunFont.tips())
            tipsLabel2.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel2)
            tipsLabel2.snp.makeConstraints { make in
                make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(tipsIcon2.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        return tipsLabel2.snp.bottom
    }
    
    /// 创建模块5的方法
    func module5(_ snpTop: ConstraintRelatableTarget) {
        /// 注册并且登录的按钮
        let signButton = UIButton()
        signButton.backgroundColor = JunColor.learnTime1()
        signButton.layer.cornerRadius = 20
        signButton.setTitle("注册并且登录", for: .normal)
        signButton.titleLabel?.font = JunFont.title2()
        signButton.setTitleColor(UIColor.black, for: .normal)
        containerView.addSubview(signButton)
        signButton.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-JunSpaced.module())
        }
        signButton.addTarget(self, action: #selector(clickedSignUpButton), for: .touchUpInside)
    }
}

// 🫳界面中其他交互触发的方法
extension SignUpViewController {
    /// 退出当前模态视图
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 点击注册按钮后触发注册和登录相关的方法
    @objc func clickedSignUpButton() {
        guard let userNameText = userNameInputBox.text, let passwordText = passwordInputBox.text else { return }
        do {
            /// 创建用户对象
            let user = LCUser()
            user.username = LCString(userNameText)
            user.password = LCString(passwordText)
            if emailInputBox.text != "" { user.email = LCString(emailInputBox.text!) }
            else if phoneInputBox.text != "" { user.mobilePhoneNumber = LCString(phoneInputBox.text!) }
            try user.set("gender", value: "secret")
            
            // 执行注册操作
            _ = user.signUp { [self] result in
                switch result {
                case .success:
                    // 根据输入项目的不同弹出不同的提示
                    if emailInputBox.text != "", phoneInputBox.text != "" {
                        view.makeToast("用户\(userNameText)注册成功\n验证邮件已发送至 \(emailInputBox.text!)\n测试阶段短信验证功能暂未开启，敬请期待", duration: 2, position: .top)
                    } else if emailInputBox.text != "" {
                        view.makeToast("用户\(userNameText)注册成功\n验证邮件已发送至 \(emailInputBox.text!)", duration: 2, position: .top)
                    } else if phoneInputBox.text != "" {
                        view.makeToast("用户\(userNameText)注册成功\n短信验证码已发送至 \(phoneInputBox.text!)", duration: 2, position: .top)
                    } else {
                        view.makeToast("用户 \(userNameText) 注册成功", duration: 2, position: .top)
                    }
                    // 注册完执行登录操作
                    _ = LCUser.logIn(username: userNameText, password: passwordText) { [self] result in
                        switch result {
                        case .success(object: _):
                            NotificationCenter.default.post(name: accountStatusChangeNotification, object: nil)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                                view.makeToast("用户 \(userNameText) 登录成功", duration: 1, position: .top)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                                    dismiss(animated: true, completion: nil)
                                }
                            }
                        case .failure(error: let error): errorLeanCloud(error, view: view)
                        }
                    }
                case .failure(error: let error):
                    if error.code == 605 {
                        view.makeToast("用户 \(userNameText) 注册成功\n测试阶段短信验证功能暂未开启，敬请期待", duration: 2, position: .top)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                            dismiss(animated: true, completion: nil)
                        }
                    } else { errorLeanCloud(error, view: view) }
                }
            }
        } catch {
            view.makeToast("\(error)\n建议截图前往“软件设置 > 反馈问题 > 特殊错误”处反馈", duration: 5, position: .top)
        }
    }
}

// ⌨️输入框键盘相关方法
extension SignUpViewController: UITextFieldDelegate {
    /// 键盘弹出时调用
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        underlyView.contentInset = contentInsets
        underlyView.scrollIndicatorInsets = contentInsets
        var aRect = self.view.frame
        aRect.size.height -= keyboardFrame.size.height
    }
    
    /// 键盘隐藏时调用
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        underlyView.contentInset = contentInsets
        underlyView.scrollIndicatorInsets = contentInsets
    }
    
    /// 收起键盘的方法
    @objc func keyboardHide() {
        view.endEditing(true)
    }
    
    /// 回车自动切换输入框的方法
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameInputBox {
            passwordInputBox.becomeFirstResponder()
        } else if textField == passwordInputBox {
            emailInputBox.becomeFirstResponder()
        } else if textField == emailInputBox {
            phoneInputBox.becomeFirstResponder()
        } else {
            phoneInputBox.resignFirstResponder()
        }
        return true
    }
}
