// 注册界面
import UIKit
import LeanCloud
import SnapKit

/// 界面的声明内容
class SignInViewController: UIViewController {
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
}

// ♻️控制器的生命周期方法
extension SignInViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "登录账户", mode: .group)
        // 设置输入框的代理（UITextFieldDelegate）
        userNameInputBox.delegate = self
        passwordInputBox.delegate = self
        
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
        // 模块3：登录按钮
        module3(snpTop)
        
        // 键盘显示和隐藏时触发相关通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// 📦分模块封装控件创建的方法
extension SignInViewController {
    /// 创建导航栏按钮的方法
    func moduleNav() {
        /// 收起键盘的按钮
        let keyboardHideButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .plain, target: self, action: #selector(keyboardHide))
        keyboardHideButton.tintColor = JunColor.LearnTime0()
        navigationItem.rightBarButtonItem = keyboardHideButton
        
        /// 收起此界面的按钮
        let dismissVCButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(dismissVC))
        dismissVCButton.tintColor = JunColor.LearnTime0()
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
        userNameInputBox.layer.borderColor = JunColor.LearnTime0().cgColor
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
        
        /// 用户名输入框下方的提示控件的提示图标
        let tipsIcon = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon)
        tipsIcon.snp.makeConstraints { make in
            make.top.equalTo(userNameInputBox.snp.bottom).offset(JunSpaced.control() - 0.7)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 用户名输入框下方的提示控件的提示内容
        let tipsLabel = UILabel().fontAdaptive("用户名即“关于我的 > 用户名”处显示的内容。", font: JunFont.tips())
            tipsLabel.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel)
            tipsLabel.snp.makeConstraints { make in
                make.top.equalTo(userNameInputBox.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(tipsIcon.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        return tipsLabel.snp.bottom
    }
    
    /// 创建模块2的方法
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
        passwordInputBox.layer.borderColor = JunColor.LearnTime0().cgColor
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
            make.top.equalTo(passwordInputBox.snp.bottom).offset(JunSpaced.control() - 0.7)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 密码输入框下方的提示控件的提示图标1
        let tipsLabel1 = UILabel().fontAdaptive("同一账户在15分钟内密码输入错误的次数大于6次，该账户将被暂时锁定15分钟。", font: JunFont.tips())
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
            make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control() - 0.7)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 密码输入框下方的提示控件的提示内容2
        let tipsLabel2 = UILabel().fontAdaptive("锁定将在最后一次密码输入错误的15分钟后自动解除。锁定期间，即使用户输入了正确的密码也不允许登录。", font: JunFont.tips())
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
    func module3(_ snpTop: ConstraintRelatableTarget) {
        /// 登录的按钮
        let signButton = UIButton()
        signButton.backgroundColor = JunColor.LearnTime0()
        signButton.layer.cornerRadius = 20
        signButton.setTitle("登录", for: .normal)
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
        signButton.addTarget(self, action: #selector(clickedSignInButton), for: .touchUpInside)
    }
}

// 🫳界面中其他交互触发的方法
extension SignInViewController {
    /// 退出当前模态视图
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    /// 点击登录按钮后触发登录相关的方法
    @objc func clickedSignInButton() {
        guard let userNameText = userNameInputBox.text, let passwordText = passwordInputBox.text else { return }
        // 执行登录操作
        _ = LCUser.logIn(username: userNameText, password: passwordText) { [self] result in
            switch result {
            case .success(object: _):
                view.makeToast("用户 \(userNameText) 登录成功", duration: 1.5, position: .top)
                NotificationCenter.default.post(name: accountStatusChangeNotification, object: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(error: let error): errorLeanCloud(error, view: view)
            }
        }
    }
}

// ⌨️输入框键盘相关方法
extension SignInViewController: UITextFieldDelegate {
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
        } else {
            passwordInputBox.resignFirstResponder()
        }
        return true
    }
}

