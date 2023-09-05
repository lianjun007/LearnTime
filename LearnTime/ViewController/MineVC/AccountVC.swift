// 账户详细界面
import UIKit
import SnapKit
import LeanCloud

/// 界面的声明内容
class AccountViewController: UIViewController {
    /// 初始化用户对象，接收当前设备登录用户
    var user = LCUser()
    
    /// 底层的滚动视图，最基础的界面
    let underlyView = UIScrollView()
    /// 底层滚动视图的内容视图
    let containerView = UIView()
    
    /// 自动布局顶部参考，用来流式创建控件时定位
    var snpTop: ConstraintRelatableTarget!
    
    /// 用户封面图的载体
    var userCoverBox = UIImageView()
    /// 邮箱地址输入和显示标签
    let emailInputLabel = InsetTextField()
    /// 手机号输入和显示标签
    let phoneInputLabel = InsetTextField()
    /// 手机号验证码输入框
    let phoneVerifyInputBoxArray: [InsetTextField] = [InsetTextField(), InsetTextField(), InsetTextField(), InsetTextField(), InsetTextField(), InsetTextField()]
}

// ♻️控制器的生命周期方法
extension AccountViewController: UIScrollViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, mode: .group)
        navigationItem.largeTitleDisplayMode = .never
        // 获取当前用户并赋值到user上
        user = LCApplication.default.currentUser!
        // 设置输入框的代理（UITextFieldDelegate）
        emailInputLabel.delegate = self
        // 设置底层视图的代理（UIScrollViewDelegate）
        underlyView.delegate = self
        
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
        // 模块0：头像和用户名
        snpTop = module0()
        // 模块1：邮箱地址
        snpTop = module1(snpTop)
        // 模块2：手机号
        snpTop = module2(snpTop)
        // 模块3：密码
        snpTop = module3(snpTop)
        // 模块4：退出登录按钮
        module4(snpTop)

        // 键盘显示和隐藏时触发相关通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// 📦👷封装界面中各个模块创建的方法
extension AccountViewController {
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
    
    /// 创建模块0的方法
    func module0() -> ConstraintRelatableTarget {
        /// 账户封面（头像）显示的容器
        userCoverBox = UIImageView(image: UIImage(named: "LearnTime"))
        userCoverBox.layer.cornerRadius = 15
        userCoverBox.layer.masksToBounds = true
        userCoverBox.contentMode = .scaleAspectFill
        containerView.addSubview(userCoverBox)
        userCoverBox.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.width.height.equalTo(JunScreen.nativeHeight() / 3.5)
            make.top.equalTo(JunSpaced.navigation())
        }
        
        /// 控件显示内容部分的高斯模糊
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        userCoverBox.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.height.equalTo(44)
            make.bottom.equalTo(userCoverBox).offset(0)
        }
        blurView.isUserInteractionEnabled = false
        
        /// 用户名标题
        let title = UILabel().fontAdaptive("\(user.username?.stringValue ?? "用户名")", font: JunFont.title2())
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.center.equalTo(blurView)
        }
        
        return userCoverBox.snp.bottom
    }
    
    /// 创建模块1的方法
    func module1(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        let title = UIButton().moduleTitleMode("邮箱地址", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        emailInputLabel.layer.borderWidth = 3
        emailInputLabel.layer.borderColor = JunColor.LearnTime0().cgColor
        emailInputLabel.backgroundColor = UIColor.white
        emailInputLabel.layer.cornerRadius = 15
        emailInputLabel.tintColor = UIColor.black.withAlphaComponent(0.6)
        emailInputLabel.font = JunFont.title2()
        emailInputLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        if (user.email?.stringValue ?? "").isEmpty {
            emailInputLabel.placeholder = "未绑定邮箱地址"
        } else {
            emailInputLabel.placeholder = user.email?.stringValue
        }
        containerView.addSubview(emailInputLabel)
        emailInputLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.height.equalTo(44)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen() - 70)
        }
        
        let emailChange = UIButton()
        var emailStatusLabel = UILabel()
        
        if user.email?.stringValue == nil || user.email?.stringValue?.count == 0 {
            emailChange.setTitle("绑定", for: .normal)
            emailChange.backgroundColor = JunColor.LearnTime0()
            emailChange.setTitleColor(UIColor.black, for: .normal)
            emailChange.titleLabel?.font = JunFont.title3()
            emailChange.layer.cornerRadius = 15
            containerView.addSubview(emailChange)
            emailChange.snp.makeConstraints { make in
                make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
                make.height.equalTo(emailInputLabel)
                make.left.equalTo(emailInputLabel.snp.right).offset(JunSpaced.control())
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            }
            emailChange.addTarget(self, action: #selector(emailAdd), for: .touchUpInside)
            
            /// 邮箱输入框下方的提示控件的提示图标
            let tipsIcon1 = UIImageView(image: UIImage(systemName: "info.circle"))
            tipsIcon1.tintColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsIcon1)
            tipsIcon1.snp.makeConstraints { make in
                make.top.equalTo(emailChange.snp.bottom).offset(JunSpaced.control() - 0.7)
                make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
                make.height.width.equalTo(15)
            }
            
            /// 邮箱输入框下方的提示控件的提示内容
            let tipsLabel1 = UILabel().fontAdaptive("绑定、修改、发送验证邮件操作都会向你（新绑定）的邮箱地址发送一封验证邮件。", font: JunFont.tips())
                tipsLabel1.textColor = UIColor.black.withAlphaComponent(0.6)
                containerView.addSubview(tipsLabel1)
                tipsLabel1.snp.makeConstraints { make in
                    make.top.equalTo(emailChange.snp.bottom).offset(JunSpaced.control())
                    make.left.equalTo(tipsIcon1.snp.right).offset(6)
                    make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            }
            
            /// 邮箱输入框下方的提示控件的提示图标
            let tipsIcon2 = UIImageView(image: UIImage(systemName: "info.circle"))
            tipsIcon2.tintColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsIcon2)
            tipsIcon2.snp.makeConstraints { make in
                make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control() - 0.7)
                make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
                make.height.width.equalTo(15)
            }
            
            /// 邮箱输入框下方的提示控件的提示内容
            let tipsLabel2 = UILabel().fontAdaptive("由于一些技术限制，验证成功后可能需要重新登录来刷新本设备上显示的邮箱地址验证状态（不影响云端的验证状态）。", font: JunFont.tips())
            tipsLabel2.textColor = UIColor.black.withAlphaComponent(0.6)
                containerView.addSubview(tipsLabel2)
            tipsLabel2.snp.makeConstraints { make in
                    make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control())
                    make.left.equalTo(tipsIcon2.snp.right).offset(6)
                    make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            }
            
            return tipsLabel2.snp.bottom
        } else {
            emailChange.setTitle("修改", for: .normal)
            emailChange.backgroundColor = JunColor.LearnTime0()
            emailChange.setTitleColor(UIColor.black, for: .normal)
            emailChange.titleLabel?.font = JunFont.title3()
            emailChange.layer.cornerRadius = 15
            containerView.addSubview(emailChange)
            emailChange.snp.makeConstraints { make in
                make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
                make.height.equalTo(emailInputLabel)
                make.left.equalTo(emailInputLabel.snp.right).offset(JunSpaced.control())
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            }
            emailChange.addTarget(self, action: #selector(emailAdd), for: .touchUpInside)
            
            if user.emailVerified?.boolValue ?? false {
                emailStatusLabel = UILabel().fontAdaptive("邮箱地址验证状态：已验证", font: JunFont.text(.bold))
            } else {
                emailStatusLabel = UILabel().fontAdaptive("邮箱地址验证状态：未验证", font: JunFont.text(.bold))
            }
            containerView.addSubview(emailStatusLabel)
            emailStatusLabel.snp.makeConstraints { make in
                make.top.equalTo(emailInputLabel.snp.bottom).offset(JunSpaced.control())
                make.height.equalTo(emailStatusLabel)
                make.width.equalTo(emailStatusLabel)
                make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            }
            
            let emailVerified = UIButton()
            emailVerified.setTitle(" 发送验证邮件 ", for: .normal)
            emailVerified.backgroundColor = JunColor.LearnTime0()
            emailVerified.setTitleColor(UIColor.black, for: .normal)
            emailVerified.titleLabel?.font = JunFont.title3()
            emailVerified.layer.cornerRadius = 12
            containerView.addSubview(emailVerified)
            emailVerified.snp.makeConstraints { make in
                make.top.equalTo(emailInputLabel.snp.bottom).offset(JunSpaced.control())
                make.height.equalTo(emailStatusLabel)
                make.left.equalTo(emailStatusLabel.snp.right).offset(JunSpaced.control())
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            }
            emailVerified.addTarget(self, action: #selector(emailVerify), for: .touchUpInside)
            
            /// 邮箱输入框下方的提示控件的提示图标
            let tipsIcon1 = UIImageView(image: UIImage(systemName: "info.circle"))
            tipsIcon1.tintColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsIcon1)
            tipsIcon1.snp.makeConstraints { make in
                make.top.equalTo(emailVerified.snp.bottom).offset(JunSpaced.control() - 0.7)
                make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
                make.height.width.equalTo(15)
            }
            
            /// 邮箱输入框下方的提示控件的提示内容
            let tipsLabel1 = UILabel().fontAdaptive("绑定、修改、发送验证邮件操作都会向你（新绑定）的邮箱地址发送一封验证邮件。", font: JunFont.tips())
                tipsLabel1.textColor = UIColor.black.withAlphaComponent(0.6)
                containerView.addSubview(tipsLabel1)
                tipsLabel1.snp.makeConstraints { make in
                    make.top.equalTo(emailVerified.snp.bottom).offset(JunSpaced.control())
                    make.left.equalTo(tipsIcon1.snp.right).offset(6)
                    make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            }
            
            /// 邮箱输入框下方的提示控件的提示图标
            let tipsIcon2 = UIImageView(image: UIImage(systemName: "info.circle"))
            tipsIcon2.tintColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsIcon2)
            tipsIcon2.snp.makeConstraints { make in
                make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control() - 0.7)
                make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
                make.height.width.equalTo(15)
            }
            
            /// 邮箱输入框下方的提示控件的提示内容
            let tipsLabel2 = UILabel().fontAdaptive("由于一些技术限制，验证成功后可能需要重新登录来刷新本设备上显示的邮箱地址验证状态（不影响云端的验证状态）。", font: JunFont.tips())
            tipsLabel2.textColor = UIColor.black.withAlphaComponent(0.6)
                containerView.addSubview(tipsLabel2)
            tipsLabel2.snp.makeConstraints { make in
                    make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control())
                    make.left.equalTo(tipsIcon2.snp.right).offset(6)
                    make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            }
            
            return tipsLabel2.snp.bottom
        }
    }
    
    /// 创建模块2的方法
    func module2(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题
        let title = UIButton().moduleTitleMode("手机号", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        phoneInputLabel.layer.borderWidth = 3
        phoneInputLabel.layer.borderColor = JunColor.LearnTime0().cgColor
        phoneInputLabel.backgroundColor = UIColor.white
        phoneInputLabel.layer.cornerRadius = 15
        phoneInputLabel.tintColor = UIColor.black.withAlphaComponent(0.6)
        phoneInputLabel.font = JunFont.title2()
        phoneInputLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        if (user.mobilePhoneNumber?.stringValue ?? "").isEmpty {
            phoneInputLabel.placeholder = "未绑定手机号"
        } else {
            phoneInputLabel.placeholder = user.mobilePhoneNumber?.stringValue
        }
        containerView.addSubview(phoneInputLabel)
        phoneInputLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.height.equalTo(44)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen() - 70)
        }
        
        let phoneChange = UIButton()
        var phoneStatusLabel = UILabel()
        let phoneVerifyButton = UIButton()
        
        if user.mobilePhoneNumber?.stringValue == nil || user.mobilePhoneNumber?.stringValue?.count == 0 {
            phoneChange.setTitle("绑定", for: .normal)
            phoneChange.backgroundColor = JunColor.LearnTime0()
            phoneChange.setTitleColor(UIColor.black, for: .normal)
            phoneChange.titleLabel?.font = JunFont.title3()
            phoneChange.layer.cornerRadius = 15
            containerView.addSubview(phoneChange)
            phoneChange.snp.makeConstraints { make in
                make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
                make.height.equalTo(emailInputLabel)
                make.left.equalTo(emailInputLabel.snp.right).offset(JunSpaced.control())
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            }
            phoneChange.addTarget(self, action: #selector(phoneAdd), for: .touchUpInside)
            
            /// 手机号输入框下方的提示控件的提示图标1
            let tipsIcon1 = UIImageView(image: UIImage(systemName: "info.circle"))
            tipsIcon1.tintColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsIcon1)
            tipsIcon1.snp.makeConstraints { make in
                make.top.equalTo(phoneChange.snp.bottom).offset(JunSpaced.control() - 0.7)
                make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
                make.height.width.equalTo(15)
            }
            
            /// 手机号输入框下方的提示控件的提示内容1
            let tipsLabel1 = UILabel().fontAdaptive("绑定、修改、发送短信验证码操作都会向你（新绑定）的手机号发送一条短信。", font: JunFont.tips())
                tipsLabel1.textColor = UIColor.black.withAlphaComponent(0.6)
                containerView.addSubview(tipsLabel1)
                tipsLabel1.snp.makeConstraints { make in
                    make.top.equalTo(phoneChange.snp.bottom).offset(JunSpaced.control())
                    make.left.equalTo(tipsIcon1.snp.right).offset(6)
                    make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            }
            
            /// 手机号输入框下方的提示控件的提示图标2
            let tipsIcon2 = UIImageView(image: UIImage(systemName: "info.circle"))
            tipsIcon2.tintColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsIcon2)
            tipsIcon2.snp.makeConstraints { make in
                make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control() - 0.7)
                make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
                make.height.width.equalTo(15)
            }
            
            /// 手机号输入框下方的提示控件的提示内容2
            let tipsLabel2 = UILabel().fontAdaptive("由于一些技术限制，验证成功后可能需要重新登录来刷新本设备上显示的手机号验证状态（不影响云端的验证状态）。", font: JunFont.tips())
            tipsLabel2.textColor = UIColor.black.withAlphaComponent(0.6)
                containerView.addSubview(tipsLabel2)
            tipsLabel2.snp.makeConstraints { make in
                    make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control())
                    make.left.equalTo(tipsIcon2.snp.right).offset(6)
                    make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            }
            
            return tipsLabel2.snp.bottom
        } else {
            phoneChange.setTitle("修改", for: .normal)
            phoneChange.backgroundColor = JunColor.LearnTime0()
            phoneChange.setTitleColor(UIColor.black, for: .normal)
            phoneChange.titleLabel?.font = JunFont.title3()
            phoneChange.layer.cornerRadius = 15
            containerView.addSubview(phoneChange)
            phoneChange.snp.makeConstraints { make in
                make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
                make.height.equalTo(emailInputLabel)
                make.left.equalTo(emailInputLabel.snp.right).offset(JunSpaced.control())
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            }
            phoneChange.addTarget(self, action: #selector(phoneAdd), for: .touchUpInside)
            
            if user.mobilePhoneNumber?.boolValue ?? false { phoneStatusLabel = UILabel().fontAdaptive("手机号验证状态：已验证", font: JunFont.text(.bold)) } else { phoneStatusLabel = UILabel().fontAdaptive("手机号验证状态：未验证", font: JunFont.text(.bold)) }
            containerView.addSubview(phoneStatusLabel)
            phoneStatusLabel.snp.makeConstraints { make in
                make.top.equalTo(phoneChange.snp.bottom).offset(JunSpaced.control())
                make.height.equalTo(phoneStatusLabel)
                make.width.equalTo(phoneStatusLabel)
                make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            }
            
            let phoneVerified = UIButton()
            phoneVerified.setTitle("  发送验证短信  ", for: .normal)
            phoneVerified.backgroundColor = JunColor.LearnTime0()
            phoneVerified.setTitleColor(UIColor.black, for: .normal)
            phoneVerified.titleLabel?.font = JunFont.title3()
            phoneVerified.layer.cornerRadius = 12
            containerView.addSubview(phoneVerified)
            phoneVerified.snp.makeConstraints { make in
                make.top.equalTo(phoneChange.snp.bottom).offset(JunSpaced.control())
                make.height.equalTo(phoneStatusLabel)
                make.left.equalTo(phoneStatusLabel.snp.right).offset(JunSpaced.control())
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            }
            phoneVerified.addTarget(self, action: #selector(phoneVerify), for: .touchUpInside)
            
            for i in 0 ... 5 {
                phoneVerifyInputBoxArray[i].layer.borderWidth = 3
                phoneVerifyInputBoxArray[i].layer.borderColor = JunColor.LearnTime0().cgColor
                phoneVerifyInputBoxArray[i].backgroundColor = UIColor.white
                phoneVerifyInputBoxArray[i].layer.cornerRadius = 12
                phoneVerifyInputBoxArray[i].tintColor = UIColor.black.withAlphaComponent(0.6)
                phoneVerifyInputBoxArray[i].font = JunFont.title2()
                phoneVerifyInputBoxArray[i].textColor = UIColor.black.withAlphaComponent(0.6)
                containerView.addSubview( phoneVerifyInputBoxArray[i])
                phoneVerifyInputBoxArray[i].snp.makeConstraints { make in
                    make.top.equalTo(phoneVerified.snp.bottom).offset(JunSpaced.control())
                    make.height.equalTo(36)
                    make.width.equalTo(42)
                    make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen() + CGFloat(i) * (48))
                }
            }
            
            phoneVerifyButton.setTitle("验证", for: .normal)
            phoneVerifyButton.backgroundColor = JunColor.LearnTime0()
            phoneVerifyButton.setTitleColor(UIColor.black, for: .normal)
            phoneVerifyButton.titleLabel?.font = JunFont.title3()
            phoneVerifyButton.layer.cornerRadius = 12
            containerView.addSubview(phoneVerifyButton)
            phoneVerifyButton.snp.makeConstraints { make in
                make.top.equalTo(phoneVerifyInputBoxArray[0])
                make.height.equalTo(phoneVerifyInputBoxArray[0])
                make.left.equalTo(phoneVerifyInputBoxArray[5].snp.right).offset(JunSpaced.control())
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            }
            phoneVerifyButton.addTarget(self, action: #selector(phoneVerifyCode), for: .touchUpInside)
            
            /// 手机号输入框下方的提示控件的提示图标1
            let tipsIcon1 = UIImageView(image: UIImage(systemName: "info.circle"))
            tipsIcon1.tintColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsIcon1)
            tipsIcon1.snp.makeConstraints { make in
                make.top.equalTo(phoneVerifyInputBoxArray[0].snp.bottom).offset(JunSpaced.control() - 0.7)
                make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
                make.height.width.equalTo(15)
            }
            
            /// 手机号输入框下方的提示控件的提示内容1
            let tipsLabel1 = UILabel().fontAdaptive("绑定、修改、发送短信验证码操作都会向你（新绑定）的手机号发送一条短信。", font: JunFont.tips())
                tipsLabel1.textColor = UIColor.black.withAlphaComponent(0.6)
                containerView.addSubview(tipsLabel1)
                tipsLabel1.snp.makeConstraints { make in
                    make.top.equalTo(phoneVerifyInputBoxArray[0].snp.bottom).offset(JunSpaced.control())
                    make.left.equalTo(tipsIcon1.snp.right).offset(6)
                    make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            }
            
            /// 手机号输入框下方的提示控件的提示图标2
            let tipsIcon2 = UIImageView(image: UIImage(systemName: "info.circle"))
            tipsIcon2.tintColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsIcon2)
            tipsIcon2.snp.makeConstraints { make in
                make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control() - 0.7)
                make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
                make.height.width.equalTo(15)
            }
            
            /// 手机号输入框下方的提示控件的提示内容2
            let tipsLabel2 = UILabel().fontAdaptive("由于一些技术限制，验证成功后可能需要重新登录来刷新本设备上显示的手机号验证状态（不影响云端的验证状态）。", font: JunFont.tips())
            tipsLabel2.textColor = UIColor.black.withAlphaComponent(0.6)
                containerView.addSubview(tipsLabel2)
            tipsLabel2.snp.makeConstraints { make in
                    make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control())
                    make.left.equalTo(tipsIcon2.snp.right).offset(6)
                    make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            }
            
            return tipsLabel2.snp.bottom
        }
    }
    
    /// 创建模块3的方法
    func module3(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        
        let title = UIButton().moduleTitleMode("重置密码", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        let emailChangePassword = UIButton()
        let phoneChangePassword = UIButton()
        
        emailChangePassword.backgroundColor = JunColor.LearnTime0()
        emailChangePassword.layer.cornerRadius = 12
        emailChangePassword.setTitle("邮件验证", for: .normal)
        emailChangePassword.titleLabel?.font = JunFont.title2()
        emailChangePassword.setTitleColor(UIColor.black, for: .normal)
        containerView.addSubview(emailChangePassword)
        emailChangePassword.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.width.equalTo(containerView.safeAreaLayoutGuide).multipliedBy(0.5).offset(-JunSpaced.screen() - JunSpaced.control() / 2)
            make.height.equalTo(36)
        }
        emailChangePassword.addTarget(self, action: #selector(emailPasswordChange), for: .touchUpInside)
        
        phoneChangePassword.backgroundColor = JunColor.LearnTime0()
        phoneChangePassword.layer.cornerRadius = 12
        phoneChangePassword.setTitle("短信验证", for: .normal)
        phoneChangePassword.titleLabel?.font = JunFont.title2()
        phoneChangePassword.setTitleColor(UIColor.black, for: .normal)
        containerView.addSubview(phoneChangePassword)
        phoneChangePassword.snp.makeConstraints { make in
            make.top.equalTo(emailChangePassword)
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.width.equalTo(containerView.safeAreaLayoutGuide).multipliedBy(0.5).offset(-JunSpaced.screen() - JunSpaced.control() / 2)
            make.height.equalTo(emailChangePassword)
        }
        phoneChangePassword.addTarget(self, action: #selector(phonePasswordChange), for: .touchUpInside)
        
        /// 手机号输入框下方的提示控件的提示图标1
        let tipsIcon1 = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon1.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon1)
        tipsIcon1.snp.makeConstraints { make in
            make.top.equalTo(phoneChangePassword.snp.bottom).offset(JunSpaced.control() - 0.7)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 手机号输入框下方的提示控件的提示内容1
        let tipsLabel1 = UILabel().fontAdaptive("邮件验证重置密码会往绑定的邮箱地址发送一封邮件，根据邮件提示完成重置密码即可。", font: JunFont.tips())
            tipsLabel1.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel1)
            tipsLabel1.snp.makeConstraints { make in
                make.top.equalTo(phoneChangePassword.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(tipsIcon1.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        /// 手机号输入框下方的提示控件的提示图标2
        let tipsIcon2 = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon2.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon2)
        tipsIcon2.snp.makeConstraints { make in
            make.top.equalTo(tipsLabel1.snp.bottom).offset(JunSpaced.control() - 0.7)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 手机号输入框下方的提示控件的提示内容2
        let tipsLabel2 = UILabel().fontAdaptive("短信验证重置密码会往绑定的手机号发送一条验证码，在短信验证重置密码界面输入新密码和验证码后确认即可重置密码。", font: JunFont.tips())
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
    func module4(_ snpTop: ConstraintRelatableTarget) {
        /// 注册并且登录的按钮
        let signOutButton = UIButton()
        signOutButton.backgroundColor = JunColor.LearnTime0()
        signOutButton.layer.cornerRadius = 20
        signOutButton.setTitle("退出登录", for: .normal)
        signOutButton.titleLabel?.font = JunFont.title2()
        signOutButton.setTitleColor(UIColor.black, for: .normal)
        containerView.addSubview(signOutButton)
        signOutButton.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-JunSpaced.module())
        }
        signOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }
}

extension AccountViewController {
    /// 退出当前模态视图
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 重新加载viewDidLoad方法以刷新界面
    @objc func overloadViewDidLoad() {
        // 移除旧的底层视图
        for subview in containerView.subviews {
            subview.removeFromSuperview()
        }
        self.viewDidLoad()
    }
    
    @objc func emailVerify() {
        guard let emailText = user.email?.stringValue else { return }
        _ = LCUser.requestVerificationMail(email: emailText) { [self] result in
            switch result {
            case .success:
                view.makeToast("验证邮件已发送至 \(emailText)", duration: 2, position: .top)
            case .failure(error: let error): errorLeanCloud(error, view: view)
            }
        }
    }
    
    @objc func emailAdd(_ sender: UIButton) {
        // 绑定邮箱操作
        guard let emailText = emailInputLabel.text else { return }
        if emailText.isEmpty {
            view.makeToast("邮箱地址不能为空", duration: 1.5, position: .top)
            return
        }
        
        user.email = LCString(emailText)
        _ = user.save { [self] result in
            switch result {
            case .success:
                view.makeToast("绑定邮箱地址 \(emailText) 成功", duration: 1.5, position: .top)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                    view.makeToast("验证邮件已发送至 \(emailText)", duration: 2, position: .top)
                }
            case .failure(error: let error): errorLeanCloud(error, view: view)
            }
        }
        overloadViewDidLoad()
    }
    
    @objc func phoneVerify() {
        guard let phoneText = user.mobilePhoneNumber?.stringValue else { return }
        _ = LCUser.requestVerificationCode(mobilePhoneNumber: phoneText) { [self] result in
            switch result {
            case .success:
                view.makeToast("短信验证码已发送至 \(phoneText)", duration: 2, position: .top)
            case .failure(error: let error): errorLeanCloud(error, view: view)
            }
        }
    }
    
    @objc func phoneVerifyCode() {
        guard let phoneText = user.mobilePhoneNumber?.stringValue,
              let code0 = phoneVerifyInputBoxArray[0].text,
              let code1 = phoneVerifyInputBoxArray[1].text,
              let code2 = phoneVerifyInputBoxArray[2].text,
              let code3 = phoneVerifyInputBoxArray[3].text,
              let code4 = phoneVerifyInputBoxArray[4].text,
              let code5 = phoneVerifyInputBoxArray[5].text
        else {
            view.makeToast("请绑定手机号后再试", duration: 1.5, position: .top)
            return
        }
        let verifyCode = "\(code0)\(code1)\(code2)\(code3)\(code4)\(code5)"
        if verifyCode.count < 6 {
            view.makeToast("请输入完整验证码", duration: 1.5, position: .top)
            return
        }
        _ = LCUser.verifyMobilePhoneNumber(phoneText, verificationCode: "\(code0)\(code1)\(code2)\(code3)\(code4)\(code5)") { [self] result in
            switch result {
            case .success:
                view.makeToast("\(phoneText) 验证成功", duration: 2, position: .top)
            case .failure(error: let error): errorLeanCloud(error, view: view)
            }
        }
    }
    
    @objc func phoneAdd(_ sender: UIButton) {
        // 绑定手机号操作
        guard let phoneText = phoneInputLabel.text else { return }
        if phoneText.isEmpty {
            view.makeToast("手机号不能为空", duration: 1.5, position: .top)
            return
        }
        
        user.mobilePhoneNumber = LCString(phoneText)
        _ = user.save { [self] result in
            switch result {
            case .success:
                view.makeToast("绑定手机号 \(phoneText) 成功", duration: 1.5, position: .top)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
//                    view.makeToast("短信验证码已发送至 \(phoneText)", duration: 2, position: .top)
//                }
            case .failure(error: let error): errorLeanCloud(error, view: view)
            }
        }
        overloadViewDidLoad()
    }
    
    @objc func emailPasswordChange(_ sender: UIButton) {
        if !(user.emailVerified?.boolValue ?? false) {
            view.makeToast("邮件重置密码功能需要邮箱地址已验证才可使用\n可能需要重新登录来刷新验证状态", duration: 3, position: .top)
            return
        }
        guard let emailText = user.email?.stringValue else { return }
        _ = LCUser.requestPasswordReset(email: emailText) { [self] result in
            switch result {
            case .success:
                view.makeToast("重置密码邮件已发送至\(emailText)", duration: 2, position: .top)
            case .failure(error: let error): errorLeanCloud(error, view: view)
            }
        }
    }
    
    @objc func phonePasswordChange(_ sender: UIButton) {
        if !(user.mobilePhoneVerified?.boolValue ?? false) {
            view.makeToast("短信验证重置密码功能需要手机号已验证才可使用\n可能需要重新登录来刷新验证状态", duration: 3, position: .top)
            return
        }
        view.makeToast("测试阶段短信验证重置密码功能暂未开启，敬请期待", duration: 2, position: .top)
    }
    
    @objc func logOut() {
        LCUser.logOut()
        NotificationCenter.default.post(name: accountStatusChangeNotification, object: nil)
        dismissVC()
    }
}

// ⌨️输入框键盘相关方法
extension AccountViewController: UITextFieldDelegate {
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
        if textField == emailInputLabel {
            phoneInputLabel.becomeFirstResponder()
        } else if textField == phoneInputLabel {
            phoneVerifyInputBoxArray[0].becomeFirstResponder()
        } else if textField == phoneVerifyInputBoxArray[0] {
            phoneVerifyInputBoxArray[1].becomeFirstResponder()
        } else if textField == phoneVerifyInputBoxArray[1] {
            phoneVerifyInputBoxArray[2].becomeFirstResponder()
        } else if textField == phoneVerifyInputBoxArray[2] {
            phoneVerifyInputBoxArray[3].becomeFirstResponder()
        } else if textField == phoneVerifyInputBoxArray[3] {
            phoneVerifyInputBoxArray[4].becomeFirstResponder()
        } else if textField == phoneVerifyInputBoxArray[4] {
            phoneVerifyInputBoxArray[5].becomeFirstResponder()
        } else {
            phoneVerifyInputBoxArray[5].resignFirstResponder()
        }
        return true
    }
    
    /// 滚动后显示标题
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let myViewFrame = userCoverBox.convert(userCoverBox.bounds, to: view)
        if myViewFrame.maxY < view.safeAreaLayoutGuide.layoutFrame.minY {
            // 当 myView 滑出界面时显示导航栏标题
            navigationItem.title = "\(user.username?.stringValue ?? "用户名")"
        } else {
            // 否则不显示导航栏标题
            navigationItem.title = ""
        }
    }
}
