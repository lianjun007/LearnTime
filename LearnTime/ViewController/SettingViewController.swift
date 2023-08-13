// 搜索与设置界面
import UIKit
import SnapKit
import LeanCloud

class SettingViewController: UIViewController {
    /// 接收模块`1`（偏好设置模块）的主题切换按钮，目的是为了当主题切换后可以定位到具体按钮然后切换复选框
    var buttonArray: Array<UIButton> = []
    
    /// 底层的滚动视图，最基础的界面
    let underlyView = UIScrollView()
    let containerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "软件设置", mode: .group)
        
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
        
        // 模块1：搜索相关的筛选设置
        snpTop = module1()
        // 模块2：搜索相关的筛选设置
        module2(snpTop)
        
        NotificationCenter.default.addObserver(self, selector: #selector(accountChange), name: accountStatusChangeNotification, object: nil)
    }
}

// 每一个模块内的代码都会整理到此扩展
extension SettingViewController {
    /// 模块1控件创建
    func module1() -> ConstraintRelatableTarget {
        /// 模块标题`1`：偏好设置
        let title = UIButton().moduleTitleMode("偏好设置", mode: .arrow)
        containerView.addSubview(title)
        title.snp.makeConstraints { (mark) in
            mark.top.equalTo(JunSpaced.navigation())
            mark.height.equalTo(title)
            mark.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            mark.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        title.addTarget(self, action: #selector(moduleTitle2Jumps), for: .touchUpInside)
        
        /// 偏好设置（模块`1`）的设置控件（对应的字典）
        let ctrlDict = SettingControl.build(control: [.custom3, .forward, .forward],
                                                            caption: "设置阅读文章时的主题风格",
                                                            label: ["", "设置内容数据源", "高级阅读设置"])
        containerView.addSubview(ctrlDict["view"]!)
        ctrlDict["view"]!.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        // 第一行自定义设置的代码
        module1ControlRow1Custom(ctrlDict["control1"]!)
        // 配置第二行关联的方法
        (ctrlDict["control3"] as! UIButton).addTarget(self, action: #selector(module1ControlRow2Jumps), for: .touchUpInside)
        
        return ctrlDict["view"]!.snp.bottom
    }
    /// 模块2控件创建
    func module2(_ snpTop: ConstraintRelatableTarget) {
        /// 模块标题`2`：更多设置
        let title = UIButton().moduleTitleMode("更多设置", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { (mark) in
            mark.top.equalTo(snpTop).offset(JunSpaced.module())
            mark.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            mark.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        /// 更多设置（模块`2`）的设置控件`1`（对应的字典）
        let ctrl1Dict = SettingControl.build(control: [.forward, .forward, .forward, .forward],
                                                             tips: "版本日志记录所有的更新变动，开发手册展示开发历程和设计思路。",
                                             label: ["关于Forum", "用户手册与协议", "版本日志", "开发手册"],
                                             text: ["develop.20230730"])
        containerView.addSubview(ctrl1Dict["view"]!)
        ctrl1Dict["view"]!.snp.makeConstraints { (mark) in
            mark.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            mark.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            mark.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        /// 更多设置（模块`2`）的设置控件`2`（对应的字典）
        let ctrl2Dict = SettingControl.build(control: [.forward, .forward],
                                             label: ["关于作者", "反馈问题"],
                                             text: ["LianJun"])
        containerView.addSubview(ctrl2Dict["view"]!)
        ctrl2Dict["view"]!.snp.makeConstraints { (mark) in
            mark.top.equalTo(ctrl1Dict["view"]!.snp.bottom).offset(JunSpaced.setting())
            mark.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            mark.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        /// 更多设置（模块`2`）的设置控件`3`（对应的字典）
        let ctrl3Dict = SettingControl.build(control: [.toggle, .forward],
                                                             tips: "实验功能不稳定，谨慎开启",
                                                             label: ["实验功能", "设置实验功能"])
        containerView.addSubview(ctrl3Dict["view"]!)
        ctrl3Dict["view"]!.snp.makeConstraints { make in
            make.top.equalTo(ctrl2Dict["view"]!.snp.bottom).offset(JunSpaced.setting())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.bottom.equalToSuperview().offset(-JunSpaced.module())
        }
    }
}

// 扩展，放置所有界面切换的方法
extension SettingViewController {
    ///
    @objc func moduleTitle2Jumps() {
        let VC = PreferencesViewController()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    /// 搜索界面文章主题设置的高级阅读设置界面的跳转方法
    @objc func module1ControlRow2Jumps() {
        let VC = EssayThemeViewController()
        self.navigationController?.pushViewController(VC, animated: true)
    }

     // 实现观察者方法
    @objc func accountChange() {
        
//            // 记录当前滚动视图的偏移量
//            var offset: CGPoint?
//            for subview in view.subviews {
//                if let scrollView = subview as? UIScrollView {
//                    offset = scrollView.contentOffset
//                    break
//                }
//            }
    
            // 移除旧的滚动视图
            for subview in view.subviews {
                if subview is UIScrollView {
                    subview.removeFromSuperview()
                }
            }
    
            // 重新构建界面
            //        let fileURL = Bundle.main.path(forResource: "File", ofType: "")
            //        let content = try! String(contentsOfFile: fileURL!, encoding: .utf8)
            //        let scrollView = essayInterfaceBuild(content, self)
            self.viewDidLoad()
            // 将新的滚动视图的偏移量设置为之前记录的值
//            if let offset = offset {
//                underlyView.setContentOffset(offset, animated: false)
//            }
        }

}

// 扩展，放置设置控件对应的点击、切换等事件（非跳转界面事件）
extension SettingViewController {
    /// 搜索界面文章主题切换按钮对应的点击方法，作用是切换文章的阅读主题
    @objc func click(sender: UIButton) {
        // 根据点击的按钮来修改UserDefaults
        switch sender.tag {
        case 0: UserDefaults.SettingInfo.set(value: "texture", forKey: .essayTheme)
        case 1: UserDefaults.SettingInfo.set(value: "style", forKey: .essayTheme)
        case 2: UserDefaults.SettingInfo.set(value: "gorgeous", forKey: .essayTheme)
        default: break
        }
        // 循环来处理复选框点中后的显示效果
        for i in 0 ... 2 {
            if i == sender.tag {
                buttonArray[sender.tag].setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            } else {
                buttonArray[i].setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            }
        }
        // 在需要切换主题的地方发送通知
        NotificationCenter.default.post(name: changeThemeNotification, object: nil)
    }
    /// 登陆注册界面跳转
    @objc func signClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let VC = SignUpViewController()
            present(VC, animated: true)
        case 1:
            let VC = SignUpViewController()
            present(VC, animated: true)
        case 3:
            LCUser.logOut()
            // 在需要切换主题的地方发送通知
            NotificationCenter.default.post(name: accountStatusChangeNotification, object: nil)
        default: break
        }
    }
}

// 扩展，放置界面显示效果修改后执行的所有方法
extension SettingViewController {
}

// 自定义设置控件的代码封装
extension SettingViewController {
    func module1ControlRow1Custom(_ superView: UIView) {
        // 重载界面的时候清空数组防止元素索引值紊乱
        buttonArray = []
        
        /// 模块`1`控件的第一行设置（设置阅读主题行）的辅助X轴原点坐标值（确保三个图标平均分布）数组
        let module1Control1OriginXArray: Array<CGFloat> = [(JunScreen.basicWidth() - 180) / 4, (JunScreen.basicWidth() - 180) / 2 + 60, (JunScreen.basicWidth() - 180) / 4 * 3 + 120]
        // 自定义设置控件（阅读主题切换）
        for i in 0 ... 2 {
            /// 上方的图片按钮
            let imageButton = UIButton()
            imageButton.frame.size = CGSize(width: 60, height: 60)
            imageButton.frame.origin = CGPoint(x: module1Control1OriginXArray[i], y: 15)
            
            /// 下方的文字复选框按钮
            let button = UIButton()
            buttonArray.append(button)
            
            // 给按钮加上图片和图标
            switch i {
            case 0:
                imageButton.setBackgroundImage(UIImage(named: "theme.texture"), for: .normal)
                button.setTitle("质感", for: .normal)
            case 1:
                imageButton.setBackgroundImage(UIImage(named: "theme.style"), for: .normal)
                button.setTitle("格调", for: .normal)
            case 2:
                imageButton.setBackgroundImage(UIImage(named: "theme.gorgeous"), for: .normal)
                button.setTitle("绚烂", for: .normal)
            default: break
            }
            
            // 配置文字复选框按钮的基础参数
            button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            button.sizeToFit()
            button.frame.origin = CGPoint(x: module1Control1OriginXArray[i], y: imageButton.frame.maxY + 15)
            button.setTitleColor(UIColor.black, for: .normal)
            
            // 设置两个按钮的其他参数
            imageButton.tag = i
            imageButton.addTarget(self, action: #selector(click), for: .touchUpInside)
            superView.addSubview(imageButton)
            button.tag = i
            button.addTarget(self, action: #selector(click), for: .touchUpInside)
            superView.addSubview(button)
        }
        
        // 根据当前主题设置复选框样式
        switch UserDefaults.SettingInfo.string(forKey: .essayTheme) {
        case "texture": buttonArray[0].setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        case "style": buttonArray[1].setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        case "gorgeous": buttonArray[2].setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        default: break
        }
    }
    
    func signButton(_ superView: UIView) {
        if let user = LCApplication.default.currentUser {
            let userNameLabel = UILabel().fontAdaptive(user.username!.stringValue!, font: JunFont.text(.bold))
            superView.addSubview(userNameLabel)
            userNameLabel.snp.makeConstraints { make in
                make.top.equalTo(10)
                make.left.equalTo(20)
                make.right.equalTo(-20)
            }
            
            let button3 = UIButton()
            button3.backgroundColor = JunColor.learnTime0()
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
            button0.backgroundColor = JunColor.learnTime0()
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
            button1.backgroundColor = JunColor.learnTime1()
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
    
    func sign1Button(_ view: UIView) {
        for item in view.subviews {
            item.removeFromSuperview()
        }
        signButton(view)
    }
}
