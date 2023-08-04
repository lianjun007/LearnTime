// 偏好设置界面
import UIKit
import SnapKit

class SettingViewController: UIViewController {
    /// 接收模块`1`控件`1`（偏好设置模块）的主题切换按钮，目的是为了当主题切换后可以定位到具体按钮然后切换复选框
    var buttonArray: Array<UIButton> = []
    
    /// 底层的滚动视图，最基础的界面
    let underlyView = UIScrollView()
    let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "偏好设置", mode: .group)
        
        /// Y轴坐标原点，用来流式创建控件时定位
        var snpTop: ConstraintRelatableTarget!
        /// 底层的滚动视图，最基础的界面
        view.addSubview(underlyView)
        underlyView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        underlyView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(underlyView)
            make.left.right.equalTo(self.view)
        }
        
        // 模块0：搜索相关的筛选设置
        snpTop = module0()
        // 模块1：搜索相关的筛选设置
        snpTop = module1(snpTop)
        // 模块2：搜索相关的筛选设置
        module2(snpTop)
    }
}

extension SettingViewController {
    /// 模块0控件创建
    func module0() -> ConstraintRelatableTarget {
        /// 排序相关的设置控件（对应的字典）
        let ctrlDict = SettingControl.build(control: [.forward], text: ["调整设置项顺序"])
        containerView.addSubview(ctrlDict["view"]!)
        ctrlDict["view"]!.snp.makeConstraints { (mark) in
            mark.top.equalTo(Spaced.navigation())
            mark.left.equalTo(containerView.safeAreaLayoutGuide.snp.left).offset(Spaced.screen())
            mark.right.equalTo(containerView.safeAreaLayoutGuide.snp.right).offset(-Spaced.screen())
        }
        
        return ctrlDict["view"]!.snp.bottom
    }
    /// 模块1控件创建
    func module1(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题`1`：显示与排版
        let title = UIButton().moduleTitleMode("显示与排版", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { (mark) in
            mark.top.equalTo(snpTop).offset(Spaced.module())
            mark.height.equalTo(title.frame.height)
            mark.left.equalTo(containerView.safeAreaLayoutGuide.snp.left).offset(Spaced.screen())
            mark.right.equalTo(containerView.safeAreaLayoutGuide.snp.right).offset(-Spaced.screen())
        }
        
        /// 显示与排版（模块`1`）的设置控件`1`（对应的字典）
        let ctrl1Dict = SettingControl.build(control: [.custom3, .forward], caption: "设置阅读文章时的主题风格", label: ["", "高级阅读设置"])
        containerView.addSubview(ctrl1Dict["view"]!)
        ctrl1Dict["view"]!.snp.makeConstraints { (mark) in
            mark.top.equalTo(title.snp.bottom).offset(Spaced.control())
            mark.left.equalTo(containerView.safeAreaLayoutGuide.snp.left).offset(Spaced.screen())
            mark.right.equalTo(containerView.safeAreaLayoutGuide.snp.right).offset(-Spaced.screen())
        }
        // 第一行自定义设置的代码
        module1ControlRow1Custom(ctrl1Dict["control1"]!)
        
        /// 显示与排版（模块`1`）的设置控件`2`（对应的字典）
        let ctrl2Dict = SettingControl.build(control: [.custom3, .toggle, .forward, .toggle],
                                                             label: ["选择主题色", "深色模式跟随系统", "设置字体", "字体样式跟随系统"])
        containerView.addSubview(ctrl2Dict["view"]!)
        ctrl2Dict["view"]!.snp.makeConstraints { (mark) in
            mark.top.equalTo(ctrl1Dict["view"]!.snp.bottom).offset(Spaced.control())
            mark.left.equalTo(containerView.safeAreaLayoutGuide.snp.left).offset(Spaced.screen())
            mark.right.equalTo(containerView.safeAreaLayoutGuide.snp.right).offset(-Spaced.screen())
        }
        
        /// 显示与排版（模块`1`）的设置控件`3`（对应的字典）
        let ctrl3Dict = SettingControl.build(control: [.toggle, .forward], caption: "界面显示方向设置",
                                             tips: "标准模式下阅读界面的方向跟随系统方向，其余界面保持竖向。",
                                             label: ["标准模式", "更多显示方向设置"])
        containerView.addSubview(ctrl3Dict["view"]!)
        ctrl3Dict["view"]!.snp.makeConstraints { (mark) in
            mark.top.equalTo(ctrl1Dict["view"]!.snp.bottom).offset(Spaced.control())
            mark.left.equalTo(containerView.safeAreaLayoutGuide.snp.left).offset(Spaced.screen())
            mark.right.equalTo(containerView.safeAreaLayoutGuide.snp.right).offset(-Spaced.screen())
        }
        
        return ctrl3Dict["view"]!.snp.bottom
    }
    /// 模块2控件创建
    func module2(_ snpTop: ConstraintRelatableTarget) {
        /// 模块标题`2`：通知与推荐
        let title = UIButton().moduleTitleMode("通知与推送", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { (mark) in
            mark.top.equalTo(snpTop).offset(Spaced.module())
            mark.left.equalTo(containerView.safeAreaLayoutGuide.snp.left).offset(Spaced.screen())
            mark.right.equalTo(containerView.safeAreaLayoutGuide.snp.right).offset(-Spaced.screen())
        }
        
        /// 通知与推送（模块`2`）的设置控件`1`（对应的字典）
        let ctrl1Dict = SettingControl.build(control: [.toggle, .forward],
                                                             tips: "需要先在系统设置中打开消息通知总开关",
                                                             label: ["消息通知", "配置消息通知"])
        containerView.addSubview(ctrl1Dict["view"]!)
        ctrl1Dict["view"]!.snp.makeConstraints { (mark) in
            mark.top.equalTo(title.snp.bottom).offset(Spaced.control())
            mark.left.equalTo(containerView.safeAreaLayoutGuide.snp.left).offset(Spaced.screen())
            mark.right.equalTo(containerView.safeAreaLayoutGuide.snp.right).offset(-Spaced.screen())
        }
        
        /// 通知与推送（模块`2`）的设置控件`2`（对应的字典）
        let ctrl2Dict = SettingControl.build(control: [.toggle, .forward, .toggle, .forward],
                                             tips: """
        打开个性化内容推送会不定期收到你可能感兴趣的内容推送，你也可以配置推送时间与内容范围
        需要先在系统设置中打开消息通知总开关
        """,
                                             label: ["个性化推荐", "配置个性化标识", "个性化内容推送", "配置推送内容"])
        containerView.addSubview(ctrl2Dict["view"]!)
        ctrl2Dict["view"]!.snp.makeConstraints { (mark) in
            mark.top.equalTo(ctrl1Dict["view"]!.snp.bottom).offset(Spaced.setting())
            mark.left.equalTo(containerView.safeAreaLayoutGuide.snp.left).offset(Spaced.screen())
            mark.right.equalTo(containerView.safeAreaLayoutGuide.snp.right).offset(-Spaced.screen())
        }
        
        /// 通知与推送（模块`2`）的设置控件`3`（对应的字典）
        let ctrl3Dict = SettingControl.build(control: [.toggle, .toggle, .forward],
                                             label: ["广告", "广告标识推荐", "配置广告显示"])
        containerView.addSubview(ctrl3Dict["view"]!)
        ctrl3Dict["view"]!.snp.makeConstraints { make in
            make.top.equalTo(ctrl2Dict["view"]!.snp.bottom).offset(Spaced.setting())
            make.left.equalTo(containerView.safeAreaLayoutGuide.snp.left).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide.snp.right).offset(-Spaced.screen())
            make.bottom.equalToSuperview().offset(-Spaced.module())
        }
    }
}

// 扩展，放置设置控件对应的点击、切换等事件（非跳转界面事件）
extension SettingViewController {
    /// 搜索界面文章主题切换按钮对应的点击方法，作用是切换文章的阅读主题
    @objc func click(sender: UIButton) {
        switch sender.tag {
        case 0: UserDefaults.SettingInfo.set(value: "texture", forKey: .essayTheme)
        case 1: UserDefaults.SettingInfo.set(value: "style", forKey: .essayTheme)
        case 2: UserDefaults.SettingInfo.set(value: "gorgeous", forKey: .essayTheme)
        default: break
        }
        
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
}

// 扩展，放置界面显示效果修改后执行的所有方法
extension SettingViewController {
    /// 当屏幕旋转时触发的方法
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // 记录当前滚动视图的偏移量
        var offset: CGPoint?
        for subview in view.subviews {
            if let scrollView = subview as? UIScrollView {
                offset = scrollView.contentOffset
                break
            }
        }
        
        // 屏幕旋转中触发的方法
        coordinator.animate { [self] _ in // 先进行一遍重新绘制充当过渡动画
            transitionAnimate(offset ?? CGPoint(x: 0, y: 0))
        } completion: { [self] _ in
            transitionAnimate(offset ?? CGPoint(x: 0, y: 0))
        }
    }
    
    func transitionAnimate(_ offset: CGPoint) {
        // 移除旧的滚动视图
        for subview in self.underlyView.subviews {
            subview.removeFromSuperview()
        }
        
        // 重新构建界面
        viewDidLoad()

        // 将新的滚动视图的偏移量设置为之前记录的值
        var newOffset = offset
        if offset.y < -44 {
            newOffset.y = -(self.navigationController?.navigationBar.frame.height)!
        } else if offset.y == -44 {
            newOffset.y = -((self.navigationController?.navigationBar.frame.height)! + Screen.safeAreaInsets().top)
        }
        self.underlyView.setContentOffset(newOffset, animated: false)
    }
}

// 自定义设置控件的代码封装
extension SettingViewController {
    func module1ControlRow1Custom(_ superView: UIView) {
        // 重载界面的时候清空数组防止元素索引值紊乱
        buttonArray = []
        
        /// 模块`1`控件的第一行设置（设置阅读主题行）的辅助X轴原点坐标值（确保三个图标平均分布）数组
        let module1Control1OriginXArray: Array<CGFloat> = [(Screen.basicWidth() - 180) / 4, (Screen.basicWidth() - 180) / 2 + 60, (Screen.basicWidth() - 180) / 4 * 3 + 120]
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
}
