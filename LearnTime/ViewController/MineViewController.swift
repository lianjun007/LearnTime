
import UIKit
import LeanCloud
import SnapKit

class MineViewController: UIViewController {
    /// 底层的滚动视图，最基础的界面
    let underlyView = UIScrollView()
    let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "关于我的", mode: .group)
        
        /// Y轴坐标原点，用来流式创建控件时定位
        var snpTop: ConstraintRelatableTarget!
        /// 底层的滚动视图，最基础的界面
        view.addSubview(underlyView)
        underlyView.snp.makeConstraints { (make) in
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(accountChange), name: changeAccountNotification, object: nil)
    }
}

extension MineViewController {
    /// 模块0控件创建
    func module0() -> ConstraintRelatableTarget {
        /// 账号相关的设置控件（对应的字典）
        let ctrlDict = SettingControl.build(control: [.custom3],
                                            tips: "登录账号使用完整服务。\n若无账户，可注册账号或使用游客账户登录")
        containerView.addSubview(ctrlDict["view"]!)
        ctrlDict["view"]!.snp.makeConstraints { make in
            make.top.equalTo(Spaced.navigation())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
        }
        
        signButton(ctrlDict["control1"]!)
        
        return ctrlDict["view"]!.snp.bottom
    }

    /// 模块1控件创建
    func module1(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题`1`：偏好设置
        let title = UIButton().moduleTitleMode("我的创作", mode: .arrow)
        containerView.addSubview(title)
        title.snp.makeConstraints { (mark) in
            mark.top.equalTo(snpTop).offset(Spaced.module())
            mark.height.equalTo(title)
            mark.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            mark.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
        }
//        title.addTarget(self, action: #selector(moduleTitle2Jumps), for: .touchUpInside)
        
        /// 偏好设置（模块`1`）的设置控件（对应的字典）
        let ctrlDict = SettingControl.build(control: [.custom3],
                                                            caption: "设置阅读文章时的主题风格",
                                                            label: ["创建合集"])
        containerView.addSubview(ctrlDict["view"]!)
        ctrlDict["view"]!.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(Spaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
        }
        
        return ctrlDict["view"]!.snp.bottom
    }
}

extension MineViewController {
    /// 登陆注册界面跳转
    @objc func signClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let VC = SignViewController()
            present(VC, animated: true)
        case 1:
            let VC = SignViewController()
            present(VC, animated: true)
        case 3:
            LCUser.logOut()
            // 在需要切换主题的地方发送通知
            NotificationCenter.default.post(name: changeAccountNotification, object: nil)
        default: break
        }
    }
    // 实现观察者方法
    @objc func accountChange() {
        // 移除旧的滚动视图
        for subview in view.subviews {
            if subview is UIScrollView {
                subview.removeFromSuperview()
            }
        }
        self.viewDidLoad()
    }
    
    func signButton(_ superView: UIView) {
        if let user = LCApplication.default.currentUser {
            let userNameLabel = UILabel().fontAdaptive(user.username!.stringValue!, font: Font.text(.bold))
            superView.addSubview(userNameLabel)
            userNameLabel.snp.makeConstraints { make in
                make.top.equalTo(10)
                make.left.equalTo(20)
                make.right.equalTo(-20)
            }
            
            let button3 = UIButton()
            button3.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.5)
            button3.layer.cornerRadius = 10
            button3.tag = 3
            button3.setImage(UIImage(systemName: "person.badge.minusperson.badge.minus"), for: .normal)
            button3.tintColor = UIColor.black
            button3.setTitle("登出账户", for: .normal)
            button3.setTitleColor(UIColor.black, for: .normal)
            superView.addSubview(button3)
            button3.snp.makeConstraints { make in
                make.top.equalTo(88)
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.bottom.equalTo(-10)
            }
            button3.addTarget(self, action: #selector(signClicked), for: .touchUpInside)
        } else {
            let button0 = UIButton()
            button0.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.5)
            button0.layer.cornerRadius = 10
            button0.tag = 0
            button0.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
            button0.tintColor = UIColor.black
            button0.setTitle("登录", for: .normal)
            button0.setTitleColor(UIColor.black, for: .normal)
            superView.addSubview(button0)
            button0.snp.makeConstraints { make in
                make.top.left.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().offset(-20)
            }
            button0.addTarget(self, action: #selector(signClicked), for: .touchUpInside)
            
            let button2 = UIButton()
            button2.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
            button2.layer.cornerRadius = 10
            button2.tag = 2
            button2.setImage(UIImage(systemName: "person"), for: .normal)
            button2.tintColor = UIColor.black
            button2.setTitle("游客", for: .normal)
            button2.setTitleColor(UIColor.black, for: .normal)
            superView.addSubview(button2)
            button2.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.bottom.right.equalToSuperview().offset(-20)
            }
            button2.addTarget(self, action: #selector(signClicked), for: .touchUpInside)
            
            let button1 = UIButton()
            button1.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            button1.layer.cornerRadius = 10
            button1.tag = 1
            button1.setImage(UIImage(systemName: "person.badge.key"), for: .normal)
            button1.tintColor = UIColor.black
            button1.setTitle("注册", for: .normal)
            button1.setTitleColor(UIColor.black, for: .normal)
            superView.addSubview(button1)
            button1.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().offset(-20)
                make.left.equalTo(button0.snp.right).offset(20)
                make.right.equalTo(button2.snp.left).offset(-20)
                make.width.equalTo(button0)
                make.width.equalTo(button2)
            }
            button1.addTarget(self, action: #selector(signClicked), for: .touchUpInside)
        }
    }
}

