// 偏好设置界面
import UIKit

class SettingViewController: UIViewController {
    /// 接收模块`1`控件`1`（偏好设置模块）的主题切换按钮，目的是为了当主题切换后可以定位到具体按钮然后切换复选框
    var buttonArray: Array<UIButton> = []
    
    /// 底层的滚动视图，最基础的界面
    let underlyView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "偏好设置", mode: .group)
        
        // 添加底层视图
        underlyView.frame = Screen.bounds()
        view.addSubview(underlyView)
        
        /// 排序相关的设置控件（对应的字典）
        let module0ControlDictionary = SettingControl.build(control: [.forward])
        module0ControlDictionary["view"]!.frame.origin = CGPoint(x: Spaced.screenAuto(), y: Spaced.navigation())
        underlyView.addSubview(module0ControlDictionary["view"]!)
        // 配置左侧文本内容
        (module0ControlDictionary["label1"] as! UILabel).text = "调整设置项顺序"
        
        /// 模块标题`1`：显示与排版
        let moduleTitle1 = UIButton().moduleTitleMode("显示与排版", originY: module0ControlDictionary["view"]!.frame.maxY + Spaced.module(), mode: .basic)
        underlyView.addSubview(moduleTitle1)
        
        /// 显示与排版（模块`1`）的设置控件`1`（对应的字典）
        let module1Control1Dictionary = SettingControl.build(control: [.custom3, .forward], caption: "设置阅读文章时的主题风格")
        module1Control1Dictionary["view"]!.frame.origin = CGPoint(x: Spaced.screenAuto(), y: moduleTitle1.frame.maxY + Spaced.control())
        underlyView.addSubview(module1Control1Dictionary["view"]!)
        // 配置每一行的左侧文本内容
        (module1Control1Dictionary["label1"] as! UILabel).text = ""
        (module1Control1Dictionary["label2"] as! UILabel).text = "高级阅读设置"
        
        // 重载界面的时候清空数组防止元素索引值紊乱
        buttonArray = []
        
        /// 模块`1`控件`1`的第一行设置（设置阅读主题行）的辅助X轴原点坐标值（确保三个图标平均分布）数组
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
            module1Control1Dictionary["control1"]!.addSubview(imageButton)
            button.tag = i
            button.addTarget(self, action: #selector(click), for: .touchUpInside)
            module1Control1Dictionary["control1"]!.addSubview(button)
        }
        
        // 根据当前主题设置复选框样式
        switch UserDefaults.SettingInfo.string(forKey: .essayTheme) {
        case "texture": buttonArray[0].setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        case "style": buttonArray[1].setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        case "grogeous": buttonArray[2].setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        default: break
        }
        
        /// 显示与排版（模块`1`）的设置控件`2`（对应的字典）
        let module1Control2Dictionary = SettingControl.build(control: [.custom3, .toggle, .forward, .toggle])
        module1Control2Dictionary["view"]!.frame.origin = CGPoint(x: Spaced.screenAuto(), y: module1Control1Dictionary["view"]!.frame.maxY + Spaced.setting())
        underlyView.addSubview(module1Control2Dictionary["view"]!)
        // 配置每一行的左侧文本内容
        let module1Control2LabelArray = ["选择主题色", "深色模式跟随系统", "设置字体", "字体样式跟随系统"]
        for i in 1 ... module1Control2LabelArray.count {
            (module1Control2Dictionary["label\(i)"] as! UILabel).text = module1Control2LabelArray[i - 1]
        }
        
        /// 显示与排版（模块`1`）的设置控件`3`（对应的字典）
        let module1Control3Dictionary = SettingControl.build(control: [.toggle, .forward], caption: "界面显示方向设置", tips: "标准模式下阅读界面的方向跟随系统方向，其余界面保持竖向。")
        module1Control3Dictionary["view"]!.frame.origin = CGPoint(x: Spaced.screenAuto(), y: module1Control2Dictionary["view"]!.frame.maxY + Spaced.setting())
        underlyView.addSubview(module1Control3Dictionary["view"]!)
        // 配置每一行的左侧文本内容
        let module1Control3LabelArray = ["标准模式", "更多显示方向设置"]
        for i in 1 ... module1Control3LabelArray.count {
            (module1Control3Dictionary["label\(i)"] as! UILabel).text = module1Control3LabelArray[i - 1]
        }
        
        /// 模块标题`2`：通知与推荐
        let moduleTitle2 = UIButton().moduleTitleMode("通知与推送", originY: module1Control3Dictionary["view"]!.frame.maxY + Spaced.module(), mode: .basic)
        underlyView.addSubview(moduleTitle2)
        
        /// 通知与推送（模块`2`）的设置控件`1`（对应的字典）
        let module2Control1Dictionary = SettingControl.build(control: [.toggle, .forward], tips: "需要先在系统设置中打开消息通知总开关")
        module2Control1Dictionary["view"]!.frame.origin = CGPoint(x: Spaced.screenAuto(), y: moduleTitle2.frame.maxY + Spaced.control())
        underlyView.addSubview(module2Control1Dictionary["view"]!)
        // 配置每一行的左侧文本内容
        let module2Control1LabelArray = ["消息通知", "配置消息通知"]
        for i in 1 ... module2Control1LabelArray.count {
            (module2Control1Dictionary["label\(i)"] as! UILabel).text = module2Control1LabelArray[i - 1]
        }
        
        /// 通知与推送（模块`2`）的设置控件`2`（对应的字典）
        let module2Control2Dictionary = SettingControl.build(control: [.toggle, .forward, .toggle, .forward], tips: """
        打开个性化内容推送会不定期收到你可能感兴趣的内容推送，你也可以配置推送时间与内容范围
        需要先在系统设置中打开消息通知总开关
        """)
        module2Control2Dictionary["view"]!.frame.origin = CGPoint(x: Spaced.screenAuto(), y: module2Control1Dictionary["view"]!.frame.maxY + Spaced.setting())
        underlyView.addSubview(module2Control2Dictionary["view"]!)
        // 配置每一行的左侧文本内容
        let module2Control2LabelArray = ["个性化推荐", "配置个性化标识", "个性化内容推送", "配置推送内容"]
        for i in 1 ... module2Control2LabelArray.count {
            (module2Control2Dictionary["label\(i)"] as! UILabel).text = module2Control2LabelArray[i - 1]
        }
        
        /// 通知与推送（模块`2`）的设置控件`3`（对应的字典）
        let module2Control3Dictionary = SettingControl.build(control: [.toggle, .toggle, .forward])
        module2Control3Dictionary["view"]!.frame.origin = CGPoint(x: Spaced.screenAuto(), y: module2Control2Dictionary["view"]!.frame.maxY + Spaced.setting())
        underlyView.addSubview(module2Control3Dictionary["view"]!)
        // 配置每一行的左侧文本内容
        let module2Control3LabelArray = ["广告", "广告标识推荐", "配置广告显示"]
        for i in 1 ... module2Control3LabelArray.count {
            (module2Control3Dictionary["label\(i)"] as! UILabel).text = module2Control3LabelArray[i - 1]
        }
        
        // 配置底层视图的内容尺寸
        underlyView.contentSize = CGSize(width: Screen.width(), height: module2Control3Dictionary["view"]!.frame.maxY + Spaced.module())
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
