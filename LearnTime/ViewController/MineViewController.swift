
import UIKit
import LeanCloud
import SnapKit

import SwiftUI

@available(iOS 13.0, *)
struct Login_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            SignUpViewController()
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
        // Do nothing
    }
}



class MineViewController: UIViewController {
    /// 底层的滚动视图，最基础的界面
    let underlyView = UIScrollView()
    /// 底层滚动视图的内容视图
    let containerView = UIView()
    
    /// 自动布局顶部参考，用来流式创建控件时定位
    var snpTop: ConstraintRelatableTarget!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "关于我的", mode: .group)
        
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

        // 模块0：搜索相关的筛选设置
        snpTop = module0()
        // 模块1：搜索相关的筛选设置
        snpTop = module1(snpTop)
        
        // 通知观察者关联方法（账号状态修改）
        NotificationCenter.default.addObserver(self, selector: #selector(overloadViewDidLoad), name: accountStatusChangeNotification, object: nil)
    }
}

// 📦👷封装界面中各个模块创建的方法
extension MineViewController {
    /// 👷创建模块0的方法（账户设置模块）
    func module0() -> ConstraintRelatableTarget {
        /// 账号相关的设置控件（对应的字典）
        let control = UIView()
        containerView.addSubview(control)
        control.snp.makeConstraints { make in
            make.top.equalTo(Spaced.navigation())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
            make.height.equalTo(80)
        }
        
        module0ButtonBuild(control)
        
        return control.snp.bottom
    }

    /// 👷创建模块1的方法（我的创作模块）
    func module1(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题`1`：偏好设置
        let title = UIButton().moduleTitleMode("我的创作", mode: .arrow)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(Spaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
        }
//        title.addTarget(self, action: #selector(moduleTitle2Jumps), for: .touchUpInside)
        
        /// 偏好设置（模块`1`）的设置控件（对应的字典）
        let ctrlDict = SettingControl.build(control: [.custom3, .custom4, .custom4, .custom4],
                                                            caption: "设置阅读文章时的主题风格",
                                            label: ["创建合集", "", "", ""])
        containerView.addSubview(ctrlDict["view"]!)
        ctrlDict["view"]!.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(Spaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
            make.bottom.equalToSuperview()
        }
        
        return ctrlDict["view"]!.snp.bottom
    }
}

// 📦🫳封装界面中交互触发的方法
extension MineViewController {
    /// 账户设置模块（模块0）相关的交互方法
    @objc func accountModuleCilcked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let VC = SignUpViewController()
            let NavC = UINavigationController(rootViewController: VC)
            present(NavC, animated: true)
        case 1:
            let VC = SignUpViewController()
            let NavC = UINavigationController(rootViewController: VC)
            present(NavC, animated: true)
        case 3:
            LCUser.logOut()
            NotificationCenter.default.post(name: accountStatusChangeNotification, object: nil)
        default: break
        }
    }
    
    /// 重新加载viewDidLoad方法以刷新界面
    @objc func overloadViewDidLoad() {
        // 移除旧的底层视图
        for subview in containerView.subviews {
            subview.removeFromSuperview()
        }
        self.viewDidLoad()
    }
}

// 📦🫳封装界面中自定义控件的方法
extension MineViewController {
    /// 👷创建模块0的自定义按钮的方法
    func module0ButtonBuild(_ superView: UIView) {
        // 判断当前设备上是否有已登录的账户
        if let user = LCApplication.default.currentUser {
            /// 显示当前账户用户名的标签
            let userNameLabel = UIButton().moduleTitleMode("用户 \(user.username!.stringValue!)", mode: .arrow)
            superView.addSubview(userNameLabel)
            userNameLabel.snp.makeConstraints { make in
                make.top.equalTo(0)
                make.height.equalTo(userNameLabel)
                make.right.left.equalTo(0)
            }
            
            /// 登出当前账户的按钮
            let signOutButton = UIButton()
            signOutButton.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.5)
            signOutButton.layer.cornerRadius = 15
            signOutButton.tag = 3
            signOutButton.setImage(UIImage(systemName: "person.badge.minus"), for: .normal)
            signOutButton.tintColor = UIColor.black
            signOutButton.setTitle("登出账户", for: .normal)
            signOutButton.setTitleColor(UIColor.black, for: .normal)
            superView.addSubview(signOutButton)
            signOutButton.snp.makeConstraints { make in
                make.top.equalTo(userNameLabel.snp.bottom).offset(Spaced.control())
                make.right.left.bottom.equalTo(0)
            }
            signOutButton.addTarget(self, action: #selector(accountModuleCilcked), for: .touchUpInside)
        } else {
            /// 登录账户的按钮
            let signInButton = UIButton()
            signInButton.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.5)
            signInButton.layer.cornerRadius = 15
            signInButton.tag = 0
            signInButton.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
            signInButton.tintColor = UIColor.black
            signInButton.setTitle("登录", for: .normal)
            signInButton.setTitleColor(UIColor.black, for: .normal)
            superView.addSubview(signInButton)
            signInButton.snp.makeConstraints { make in
                make.top.left.equalToSuperview().offset(0)
                make.bottom.equalToSuperview().offset(0)
            }
            signInButton.addTarget(self, action: #selector(accountModuleCilcked), for: .touchUpInside)
            
            /// 游客登录的按钮
            let temporaryAccountButton = UIButton()
            temporaryAccountButton.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
            temporaryAccountButton.layer.cornerRadius = 15
            temporaryAccountButton.tag = 2
            temporaryAccountButton.setImage(UIImage(systemName: "person"), for: .normal)
            temporaryAccountButton.tintColor = UIColor.black
            temporaryAccountButton.setTitle("游客", for: .normal)
            temporaryAccountButton.setTitleColor(UIColor.black, for: .normal)
            superView.addSubview(temporaryAccountButton)
            temporaryAccountButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(0)
                make.bottom.right.equalToSuperview().offset(0)
            }
            temporaryAccountButton.addTarget(self, action: #selector(accountModuleCilcked), for: .touchUpInside)
            
            /// 注册账户的按钮
            let signUpButton = UIButton()
            signUpButton.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            signUpButton.layer.cornerRadius = 15
            signUpButton.tag = 1
            signUpButton.setImage(UIImage(systemName: "person.badge.key"), for: .normal)
            signUpButton.tintColor = UIColor.black
            signUpButton.setTitle("注册", for: .normal)
            signUpButton.setTitleColor(UIColor.black, for: .normal)
            superView.addSubview(signUpButton)
            signUpButton.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().offset(0)
                make.left.equalTo(signInButton.snp.right).offset(20)
                make.right.equalTo(temporaryAccountButton.snp.left).offset(-20)
                make.width.equalTo(signInButton)
                make.width.equalTo(temporaryAccountButton)
            }
            signUpButton.addTarget(self, action: #selector(accountModuleCilcked), for: .touchUpInside)
        }
    }
}

// 📦🫳封装界面中的通用辅助方法
extension MineViewController {
    
}
