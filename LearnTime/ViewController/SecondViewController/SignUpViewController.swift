
import UIKit
import LeanCloud
import SnapKit

class SignUpViewController: UIViewController {

    let userNameBox = InsetTextField()
    let passwordBox = InsetTextField()
    let emailBox = InsetTextField()
    let phoneBox = InsetTextField()
    
    /// 底层的滚动视图，最基础的界面
    let underlyView = UIScrollView()
    /// 底层滚动视图的内容视图
    let containerView = UIView()
    
    /// 自动布局顶部参考，用来流式创建控件时定位
    var snpTop: ConstraintRelatableTarget!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "注册账户", mode: .group)
        userNameBox.delegate = self
        passwordBox.delegate = self
        emailBox.delegate = self
        phoneBox.delegate = self
        
        let button = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .plain, target: self, action: #selector(buttonTapped))
        button.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = button
        
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
        
        // 模块1：搜索相关的筛选设置
        snpTop = module1()
        // 模块2：搜索相关的筛选设置
        snpTop = module2(snpTop)
        snpTop = module3(snpTop)
        snpTop = module4(snpTop)
        module5(snpTop)

//        // 通知观察者关联方法（账号状态修改）
//        NotificationCenter.default.addObserver(self, selector: #selector(overloadViewDidLoad), name: emailVerifiedStatusChangeNotification, object: nil)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    /// 👷创建模块1的方法
    func module1() -> ConstraintRelatableTarget {
        /// 模块标题`1`：偏好设置
        let title = UIButton().moduleTitleMode("用户名", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(Spaced.navigation())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
        }
        
        userNameBox.layer.borderWidth = 3
        userNameBox.layer.borderColor = UIColor.red.withAlphaComponent(0.3).cgColor
        userNameBox.backgroundColor = UIColor.white
        userNameBox.layer.cornerRadius = 15
        userNameBox.tintColor = UIColor.black.withAlphaComponent(0.6)
        userNameBox.font = Font.title2()
        userNameBox.textColor = UIColor.black.withAlphaComponent(0.6)
        userNameBox.placeholder = "必填"
        containerView.addSubview(userNameBox)
        userNameBox.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(Spaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
            make.height.equalTo(44)
        }
        
        let tipsIcon = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon)
        tipsIcon.snp.makeConstraints { make in
            make.top.equalTo(userNameBox.snp.bottom).offset(Spaced.control() - 1)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 提示内容
        let tipsLabel = UILabel().fontAdaptive("用户名的长度、内容、复杂度、字符类型不作限制，但是不建议太过于奇怪。", font: Font.tips())
            tipsLabel.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel)
            tipsLabel.snp.makeConstraints { make in
                make.top.equalTo(userNameBox.snp.bottom).offset(Spaced.control())
                make.left.equalTo(tipsIcon.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
        }
        
        return tipsLabel.snp.bottom
    }
    /// 👷创建模块2的方法（输入密码模块）
    func module2(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题：密码
        let title = UIButton().moduleTitleMode("密码", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(Spaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
        }
        
        passwordBox.layer.borderWidth = 3
        passwordBox.layer.borderColor = UIColor.red.withAlphaComponent(0.3).cgColor
        passwordBox.backgroundColor = UIColor.white
        passwordBox.layer.cornerRadius = 15
        passwordBox.tintColor = UIColor.black.withAlphaComponent(0.6)
        passwordBox.font = Font.title2()
        passwordBox.textColor = UIColor.black.withAlphaComponent(0.6)
        passwordBox.placeholder = "必填"
        containerView.addSubview(passwordBox)
        passwordBox.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(Spaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
            make.height.equalTo(44)
        }
        
        let tipsIcon = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon)
        tipsIcon.snp.makeConstraints { make in
            make.top.equalTo(passwordBox.snp.bottom).offset(Spaced.control() - 1)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 提示内容
        let tipsLabel = UILabel().fontAdaptive("密码的长度、内容、复杂度、字符类型不作限制，但是不建议太过于奇怪。", font: Font.tips())
            tipsLabel.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel)
            tipsLabel.snp.makeConstraints { make in
                make.top.equalTo(passwordBox.snp.bottom).offset(Spaced.control())
                make.left.equalTo(tipsIcon.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
        }
        
        let tipsIcon2 = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon2.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon2)
        tipsIcon2.snp.makeConstraints { make in
            make.top.equalTo(tipsLabel.snp.bottom).offset(Spaced.control() - 1)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 提示内容
        let tipsLabel2 = UILabel().fontAdaptive("密码是以明文方式通过 HTTPS 加密传输给云端，云端会以密文存储密码。换言之，用户的密码只可能用户本人知道，开发者不论是通过控制台还是 API 都是无法获取。详情请查阅 LeanCloud（docs.leancloud.cn）官方技术文档。", font: Font.tips())
            tipsLabel2.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel2)
            tipsLabel2.snp.makeConstraints { make in
                make.top.equalTo(tipsLabel.snp.bottom).offset(Spaced.control())
                make.left.equalTo(tipsIcon2.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
        }
        return tipsLabel2.snp.bottom
    }
    
    /// 👷创建模块3的方法（输入邮箱）
    func module3(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题：邮箱
        let title = UIButton().moduleTitleMode("邮箱地址", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(Spaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
        }
        
        emailBox.layer.borderWidth = 3
        emailBox.layer.borderColor = UIColor.red.withAlphaComponent(0.3).cgColor
        emailBox.backgroundColor = UIColor.white
        emailBox.layer.cornerRadius = 15
        emailBox.tintColor = UIColor.black.withAlphaComponent(0.6)
        emailBox.font = Font.title2()
        emailBox.textColor = UIColor.black.withAlphaComponent(0.6)
        emailBox.placeholder = "选填"
        containerView.addSubview(emailBox)
        emailBox.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(Spaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
            make.height.equalTo(44)
        }
        
        let tipsIcon = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon)
        tipsIcon.snp.makeConstraints { make in
            make.top.equalTo(emailBox.snp.bottom).offset(Spaced.control() - 1)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 提示内容
        let tipsLabel = UILabel().fontAdaptive("如果输入了邮箱地址，在注册成功后此邮箱地址会收到一封验证邮件，验证成功后可以使用邮箱登录。你也可以在注册成功后再绑定账户的邮箱地址。", font: Font.tips())
            tipsLabel.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel)
            tipsLabel.snp.makeConstraints { make in
                make.top.equalTo(emailBox.snp.bottom).offset(Spaced.control())
                make.left.equalTo(tipsIcon.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
        }
        
        return tipsLabel.snp.bottom
    }
    /// 👷创建模块4的方法（输入手机号模块）
    func module4(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题`1`：偏好设置
        let title = UIButton().moduleTitleMode("手机号", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(Spaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
        }
        
        phoneBox.layer.borderWidth = 3
        phoneBox.layer.borderColor = UIColor.red.withAlphaComponent(0.3).cgColor
        phoneBox.backgroundColor = UIColor.white
        phoneBox.layer.cornerRadius = 15
        phoneBox.tintColor = UIColor.black.withAlphaComponent(0.6)
        phoneBox.font = Font.title2()
        phoneBox.textColor = UIColor.black.withAlphaComponent(0.6)
        phoneBox.placeholder = "选填"
        containerView.addSubview(phoneBox)
        phoneBox.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(Spaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
            make.height.equalTo(44)
        }
        
        let tipsIcon = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon)
        tipsIcon.snp.makeConstraints { make in
            make.top.equalTo(phoneBox.snp.bottom).offset(Spaced.control() - 1)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 提示内容
        let tipsLabel = UILabel().fontAdaptive("手机号可以在“关于我的 > 用户 你的用户名 > 验证手机号”处进行验证，验证成功后可以使用手机号短信登录。你也可以在注册成功后再绑定账户的手机号。", font: Font.tips())
            tipsLabel.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel)
            tipsLabel.snp.makeConstraints { make in
                make.top.equalTo(phoneBox.snp.bottom).offset(Spaced.control())
                make.left.equalTo(tipsIcon.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
        }
        
        return tipsLabel.snp.bottom
    }
    
    /// 👷创建模块5的方法
    func module5(_ snpTop: ConstraintRelatableTarget) {
        
        let signButton = UIButton()
        signButton.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        signButton.layer.cornerRadius = 20
        signButton.setTitle("确认注册", for: .normal)
        signButton.titleLabel?.font = Font.title2()
        signButton.setTitleColor(UIColor.black, for: .normal)
        containerView.addSubview(signButton)
        signButton.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(Spaced.module())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
            make.height.equalTo(60)
            make.bottom.equalToSuperview()
        }
        signButton.addTarget(self, action: #selector(clickedSignButton), for: .touchUpInside)
        
//        let signInButton = UIButton()
//        signInButton.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
//        signInButton.layer.cornerRadius = 15
//        containerView.addSubview(signInButton)
//        signInButton.snp.makeConstraints { make in
//            make.top.equalTo(signButton.snp.bottom).offset(Spaced.control())
//            make.left.equalTo(view.safeAreaLayoutGuide).offset(Spaced.screen())
//            make.right.equalTo(view.safeAreaLayoutGuide).offset(-Spaced.screen())
//            make.height.equalTo(44)
//        }
//        signInButton.addTarget(self, action: #selector(clickedSignInButton), for: .touchUpInside)
    }
    
//    /// 👷创建模块6的方法
//    func module6(_ snpTop: ConstraintRelatableTarget) {
//        
//        let verifyEmailButton = UIButton()
//        verifyEmailButton.backgroundColor = UIColor.red.withAlphaComponent(0.3)
//        verifyEmailButton.layer.cornerRadius = 15
//        verifyEmailButton.setTitle("发送验证邮件", for: .normal)
//        verifyEmailButton.setTitleColor(UIColor.black, for: .normal)
//        containerView.addSubview(verifyEmailButton)
//        verifyEmailButton.snp.makeConstraints { make in
//            make.top.equalTo(snpTop).offset(Spaced.module())
//            make.width.equalTo(containerView).multipliedBy(0.5).offset(-Spaced.screen())
//            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
//            make.height.equalTo(44)
//        }
//        verifyEmailButton.addTarget(self, action: #selector(verifyEmailClicked), for: .touchUpInside)
//        
//        /// 刷新当前邮箱验证状态的按钮
//        let refreshButton = UIButton()
//        refreshButton.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
//        refreshButton.imageView?.snp.makeConstraints { make in
//            make.top.left.equalTo(3)
//        }
//        refreshButton.tintColor = UIColor.black
//        refreshButton.layer.cornerRadius = 15
//        containerView.addSubview(refreshButton)
//        refreshButton.snp.makeConstraints { make in
//            make.top.equalTo(snpTop).offset(Spaced.control())
//            make.right.equalTo(verifyEmailButton.snp.left).offset(-Spaced.control())
//            make.height.width.equalTo(44)
//        }
//        
//        /// 当前邮箱验证状态的显示框
//        let statusView = UIButton()
//        statusView.layer.cornerRadius = 15
//        containerView.addSubview(statusView)
//        statusView.snp.makeConstraints { make in
//            make.top.equalTo(snpTop).offset(Spaced.control())
//            make.right.equalTo(refreshButton.snp.left).offset(-Spaced.control())
//            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
//            make.height.equalTo(44)
//        }
//
//        statusView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
//        statusView.setTitle("未验证", for: .normal)
//    }
}

extension SignUpViewController {
    
    @objc func buttonTapped() {
        view.endEditing(true)
    }
    
    @objc func clickedSignButton() {
        guard let username = userNameBox.text, let password = passwordBox.text else { return }
        
        do {
            // 创建实例
            let user = LCUser()

            // 等同于 user.set("username", value: "Tom")
            user.username = LCString(username)
            user.password = LCString(password)
            
            if emailBox.text != "" {
                print(emailBox.text)
                user.email = LCString(emailBox.text!)
            } else if phoneBox.text != "" {
                user.mobilePhoneNumber = LCString(phoneBox.text!)
            }

            // 设置其他属性的方法跟 LCObject 一样
            try user.set("gender", value: "secret")

            /// 初始化获取索引值的任务计数器
            let indexGroup = DispatchGroup()
            
            _ = user.signUp { (result) in
                switch result {
                case .success:
                    indexGroup.enter()
                    let alert = UIAlertController(title: "注册成功", message: "\(username)\n欢迎加入论坛（LearnTime）！", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "好的", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    indexGroup.leave()
                    
                    indexGroup.notify(queue: .main) {
                        // 注册完立即登陆
                        _ = LCUser.logIn(username: username, password: password) { result in
                            print("nihao")
                            switch result {
                            case .success(object: let user):
                                NotificationCenter.default.post(name: accountStatusChangeNotification, object: nil)
                            case .failure(error: let error):
                                print(error)
                            }
                        }
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                case .failure(error: let error):
                    switch error.code {
                    case 202:
                        let alert = UIAlertController(title: "用户名已被注册", message: "请修改后再试一次", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case 203:
                        let alert = UIAlertController(title: "邮箱已被注册", message: "请修改或删除后再试一次", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case 214:
                        let alert = UIAlertController(title: "手机号已被注册", message: "请修改或删除后再试一次", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case 218:
                        let alert = UIAlertController(title: "密码不能为空", message: "请输入后再试一次", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case 125:
                        let alert = UIAlertController(title: "邮箱地址无效", message: "请修改或删除后再试一次", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    default:
                        let alert = UIAlertController(title: "错误码\(error.code)", message: "描述：\(error.description)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
//    @objc func clickedSignInButton() {
//        guard let username = userNameBox.text, let password = passwordBox.text, let email = emailBox.text, let phone = phoneBox.text else {
//            // 处理用户名或密码为nil的情况
//            return
//        }
//        _ = LCUser.logIn(username: username, password: password) { result in
//            switch result {
//            case .success(object: let user):
//                print(user)
//                NotificationCenter.default.post(name: accountStatusChangeNotification, object: nil)
//            case .failure(error: let error):
//                print(error)
//            }
//        }
//    }
    
//    @objc func verifyEmailClicked() {
//        guard let email = emailBox.text else { return }
//        _ = LCUser.requestVerificationMail(email: email) { result in
//            switch result {
//            case .success: break
//            case .failure(error: let error): print(error)
//            }
//        }
//    }
    
//    @objc func refreshEmailVerifyStatusClicked() {
//        NotificationCenter.default.post(name: emailVerifiedStatusChangeNotification, object: nil)
//    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameBox {
            passwordBox.becomeFirstResponder()
        } else if textField == passwordBox {
            emailBox.becomeFirstResponder()
        } else if textField == emailBox {
            phoneBox.becomeFirstResponder()
        } else {
            phoneBox.resignFirstResponder()
        }
        return true
    }

}
