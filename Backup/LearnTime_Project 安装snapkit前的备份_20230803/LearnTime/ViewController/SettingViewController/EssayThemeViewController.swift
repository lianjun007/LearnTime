//
//  EssayThemeViewController.swift
//  Learn Time
//
//  Created by LianJun on 2023/7/29.
//
// 文章主题设置界面（高级阅读设置）
import UIKit

class EssayThemeViewController: UIViewController {
    
    /// 底层的滚动视图，最基础的界面
    let underlyView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "高级阅读设置", mode: .group)
        
        /// Y轴坐标原点，用来流式创建控件时定位
        var originY = CGFloat(0)
        // 添加底层视图
        underlyView.frame = Screen.bounds()
        view.addSubview(underlyView)
        
        // 模块0：搜索相关的筛选设置
        originY = module0(underlyView)
        
        // 模块1：搜索相关的筛选设置
        originY = module1(underlyView, originY: originY)
        
        // 模块2：搜索相关的筛选设置
        originY = module2(underlyView, originY: originY)
        
        // 配置底层视图的内容尺寸
        underlyView.contentSize = CGSize(width: Screen.width(), height: originY + Spaced.module())
    }
}

// 每一个模块内的代码都会整理到此扩展
extension EssayThemeViewController {
    /// 模块0控件创建
    func module0(_ superView: UIView) -> CGFloat {
        /// 自定义设置开关的设置控件（对应的字典）
        let ctrlDict = SettingControl.build(control: [.toggle],
                                            tips: "打开此开关可修改下列所有设置来增加阅读的个性化体验。关闭此开关则下列所有设置恢复默认（暂时没有保存预设功能），请谨慎操作！",
                                            label: ["自定义设置"])
        ctrlDict["view"]!.frame.origin = CGPoint(x: Spaced.screenAuto(), y: Spaced.navigation())
        underlyView.addSubview(ctrlDict["view"]!)
        
        return ctrlDict["view"]!.frame.maxY
    }
    /// 模块1控件创建
    func module1(_ superView: UIView, originY: CGFloat) -> CGFloat {
        /// 模块标题`1`：偏好设置
        let title = UIButton().moduleTitleMode("文本相关", originY: originY + Spaced.module(), mode: .basic)
        underlyView.addSubview(title)
        
        /// 偏好设置（模块`1`）的设置控件（对应的字典）
        let ctrlDict = SettingControl.build(control: [.toggle, .forward],
                                            caption: "设置文本在单词还是字符之间换行",
                                            label: ["单词不分行显示", "设置行间距"])
        ctrlDict["view"]!.frame.origin = CGPoint(x: Spaced.screenAuto(), y: title.frame.maxY + Spaced.control())
        underlyView.addSubview(ctrlDict["view"]!)
        (ctrlDict["control1"] as! UISwitch).isOn = (UserDefaults.SettingInfo.string(forKey: .essayTextRow)! == "true") ? true: false
        (ctrlDict["control1"] as! UISwitch).addTarget(self, action: #selector(module1Control1Row1Switch), for: .valueChanged)
        // 配置第二行关联的方法
        // (ctrlDict["control2"] as! UIButton).addTarget(self, action: #selector(module1ControlRow2Jumps), for: .touchUpInside)
        
        return ctrlDict["view"]!.frame.maxY
    }
    /// 模块2控件创建
    func module2(_ superView: UIView, originY: CGFloat) -> CGFloat {
        /// 模块标题`1`：代码块
        let title = UIButton().moduleTitleMode("代码块相关", originY: originY + Spaced.module(), mode: .basic)
        underlyView.addSubview(title)
        
        /// 代码块（模块`1`）的设置控件`1`（对应的字典）
        let ctrl1Dict = SettingControl.build(control: [.toggle, .toggle, .forward, .toggle],
                                             caption: "设置“代码块”的序号条",
                                             label: ["序号条", "自动隐藏", "最大显示位数", "位数补全"])
        ctrl1Dict["view"]!.frame.origin = CGPoint(x: Spaced.screenAuto(), y: title.frame.maxY + Spaced.control())
        underlyView.addSubview(ctrl1Dict["view"]!)
        // 配置每一行关联的方法
        (ctrl1Dict["control1"] as! UISwitch).isOn = (UserDefaults.SettingInfo.string(forKey: .essayCodeNumber)! == "true") ? true: false
        (ctrl1Dict["control1"] as! UISwitch).addTarget(self, action: #selector(module2Control1Row1Switch), for: .valueChanged)
        
        /// 代码块（模块`1`）的设置控件`2`（对应的字典）
        let ctrl2Dict = SettingControl.build(control: [.toggle, .toggle, .toggle, .forward],
                                             label: ["去除前后空行", "自动换行", "语法高亮", "自定义高亮"])
        ctrl2Dict["view"]!.frame.origin = CGPoint(x: Spaced.screenAuto(), y: ctrl1Dict["view"]!.frame.maxY + Spaced.setting())
        underlyView.addSubview(ctrl2Dict["view"]!)
        // 配置每一行关联的方法
        (ctrl2Dict["control1"] as! UISwitch).isOn = (UserDefaults.SettingInfo.string(forKey: .essayCodeFristAndList)! == "true") ? true: false
        (ctrl2Dict["control1"] as! UISwitch).addTarget(self, action: #selector(module2Control2Row1Switch), for: .valueChanged)
        
        return ctrl2Dict["view"]!.frame.maxY
    }
}

//
extension EssayThemeViewController {
    @objc func module2Control1Row1Switch(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.SettingInfo.set(value: "true", forKey: .essayCodeNumber)
        } else {
            UserDefaults.SettingInfo.set(value: "false", forKey: .essayCodeNumber)
        }
        // 切换主题相关设置，发送通知
        NotificationCenter.default.post(name: changeThemeNotification, object: nil)
    }
    @objc func module2Control2Row1Switch(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.SettingInfo.set(value: "true", forKey: .essayCodeFristAndList)
        } else {
            UserDefaults.SettingInfo.set(value: "false", forKey: .essayCodeFristAndList)
        }
        // 切换主题相关设置，发送通知
        NotificationCenter.default.post(name: changeThemeNotification, object: nil)
    }
    @objc func module1Control1Row1Switch(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.SettingInfo.set(value: "true", forKey: .essayTextRow)
        } else {
            UserDefaults.SettingInfo.set(value: "false", forKey: .essayTextRow)
        }
        // 切换主题相关设置，发送通知
        NotificationCenter.default.post(name: changeThemeNotification, object: nil)
    }
}

// 扩展，放置界面显示效果修改后执行的所有方法
extension EssayThemeViewController {
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

