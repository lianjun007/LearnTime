import UIKit
import SnapKit
import LeanCloud

import SwiftUI

@available(iOS 13.0, *)
struct Login_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            UINavigationController(rootViewController: AccountViewController())
        }
    }
}

struct ViewControllerPreview: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController
    
    let viewControllerBuilder: () -> UIViewControllerType
 
    init(_ viewControllerBuilder: @escaping () -> UIViewControllerType) {
        self.viewControllerBuilder = viewControllerBuilder
    }
    
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController {
        viewControllerBuilder()
    }
 
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}


/// 账户详细界面的声明内容
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
}

// ♻️控制器的生命周期方法
extension AccountViewController: UIScrollViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, mode: .group)
        navigationItem.largeTitleDisplayMode = .never
        // 获取当前用户并赋值到user上
        // user = LCApplication.default.currentUser!
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
        // 模块1：头像和用户名
        snpTop = module0()
        // 模块2：邮箱地址
        snpTop = module1(snpTop)

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
        keyboardHideButton.tintColor = JunColor.learnTime0()
        navigationItem.rightBarButtonItem = keyboardHideButton
        
        /// 收起此界面的按钮
        let dismissVCButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(dismissVC))
        dismissVCButton.tintColor = JunColor.learnTime0()
        navigationItem.leftBarButtonItem = dismissVCButton
    }
    
    /// 创建模块0的方法
    func module0() -> ConstraintRelatableTarget {
        /// 账户封面（头像）显示的容器
        userCoverBox = UIImageView(image: UIImage(named: "loading"))
        userCoverBox.layer.cornerRadius = 15
        userCoverBox.layer.masksToBounds = true
        userCoverBox.contentMode = .scaleAspectFill
        containerView.addSubview(userCoverBox)
        userCoverBox.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.width.height.equalTo(JunScreen.nativeHeight() / 4)
            make.top.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.navigation())
        }
        
//        /// 用户名标题
//        let title = UIButton().moduleTitleMode("\(user.username?.stringValue ?? "用户名")", mode: .basic)
//        containerView.addSubview(title)
//        title.snp.makeConstraints { make in
//            make.top.equalTo(userCover.snp.bottom).offset(JunSpaced.control())
//            make.height.equalTo(title)
//            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
//            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
//        }
        
        return userCoverBox.snp.bottom
    }
    /// 👷创建模块1的方法（我的创作模块）
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
        emailInputLabel.layer.borderColor = JunColor.learnTime0().cgColor
        emailInputLabel.backgroundColor = UIColor.white
        emailInputLabel.layer.cornerRadius = 15
        emailInputLabel.tintColor = UIColor.black.withAlphaComponent(0.6)
        emailInputLabel.font = JunFont.title2()
        emailInputLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        emailInputLabel.placeholder = user.email?.stringValue ?? "未绑定邮箱地址"
        containerView.addSubview(emailInputLabel)
        emailInputLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.height.equalTo(44)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen() - 70)
        }
        
        let emailChange = UIButton()
        var emailStatusLabel = UILabel()
        
        if user.email?.stringValue != nil {
            emailChange.setTitle("绑定", for: .normal)
            emailChange.backgroundColor = JunColor.learnTime0()
            emailChange.setTitleColor(UIColor.black, for: .normal)
            emailChange.titleLabel?.font = JunFont.title3()
            emailChange.layer.cornerRadius = 15
            emailChange.tag = 0
            containerView.addSubview(emailChange)
            emailChange.snp.makeConstraints { make in
                make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
                make.height.equalTo(emailInputLabel)
                make.left.equalTo(emailInputLabel.snp.right).offset(JunSpaced.control())
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
                make.bottom.equalToSuperview().offset(-JunSpaced.module())
            }
            emailChange.addTarget(self, action: #selector(emailAdd), for: .touchUpInside)
            
            return emailChange.snp.bottom
        } else {
            emailChange.setTitle("修改", for: .normal)
            emailChange.backgroundColor = JunColor.learnTime0()
            emailChange.setTitleColor(UIColor.black, for: .normal)
            emailChange.titleLabel?.font = JunFont.title3()
            emailChange.layer.cornerRadius = 15
            emailChange.tag = 1
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
            emailVerified.backgroundColor = JunColor.learnTime0()
            emailVerified.setTitleColor(UIColor.black, for: .normal)
            emailVerified.titleLabel?.font = JunFont.title3()
            emailVerified.layer.cornerRadius = 10
            containerView.addSubview(emailVerified)
            emailVerified.snp.makeConstraints { make in
                make.top.equalTo(emailInputLabel.snp.bottom).offset(JunSpaced.control())
                make.height.equalTo(emailStatusLabel)
                make.left.equalTo(emailStatusLabel.snp.right).offset(JunSpaced.control())
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
                make.bottom.equalToSuperview().offset(-JunSpaced.module() * 100)
            }
            emailVerified.addTarget(self, action: #selector(emailVerifly), for: .touchUpInside)
            
            return emailStatusLabel.snp.bottom
        }
    }
}

extension AccountViewController {
    /// 退出当前视图控制器
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
    
    @objc func emailVerifly() {
        guard let userEmail = user.email?.stringValue else { return }
        _ = LCUser.requestVerificationMail(email: userEmail) { [self] result in
            switch result {
            case .success:
                view.makeToast("验证邮件已发送至 \(userEmail)\n可以在验证后刷新本界面查看当前邮箱验证状态", duration: 3, position: .top)
            case .failure(error: let error):
                switch error.code {
                case 1:
                    view.makeToast("请不要往同一邮箱地址发送过多邮件", duration: 2, position: .top)
                default:
                    view.makeToast("错误码\(error.code)\n描述：\(error.description)", duration: 2, position: .top)
                }
            }
        }
    }
    
    @objc func emailAdd(_ sender: UIButton) {
        // 绑定邮箱操作
        guard let Email = emailInputLabel.text else {
            view.makeToast("邮箱地址不能为空", duration: 2, position: .top)
            return
        }
        user.email = LCString(Email)
        _ = user.save { [self] result in
            switch result {
            case .success:
                view.makeToast("绑定邮箱地址 \(Email) 成功", duration: 1.5, position: .top)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                    view.makeToast("验证邮件已发送至 \(Email)\n验证后可以重新登录刷新当前邮箱验证状态的显示", duration: 2.5, position: .top)
                }
            case .failure(error: let error):
                view.makeToast("错误码\(error.code)\n描述：\(error.description)", duration: 2, position: .top)
            }
        }
        overloadViewDidLoad()
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
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == userNameInputBox {
//            passwordInputBox.becomeFirstResponder()
//        } else if textField == passwordInputBox {
//            emailInputBox.becomeFirstResponder()
//        } else if textField == emailInputBox {
//            phoneInputBox.becomeFirstResponder()
//        } else {
//            phoneInputBox.resignFirstResponder()
//        }
//        return true
//    }
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
