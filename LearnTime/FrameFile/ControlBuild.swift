//
import UIKit
import SnapKit

/// ⌛️视图控制器初始化的方法：传入视图控制器（一般为`self`）、导航栏标题名
struct Initialize {
    enum viewMode {
        case basic, group, opaque
    }
    static func view(_ ViewController: UIViewController,_ navigaionTitle: String = "", mode: Initialize.viewMode) {
        // 设置界面背景色
        switch mode {
        case .basic: ViewController.view.backgroundColor = JunColor.background()
        case .group: ViewController.view.backgroundColor = JunColor.groupBackground()
        default: ViewController.view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0)
        }
        // 设置导航栏标题
        ViewController.title = navigaionTitle
//        if #available(iOS 17.0, *) {
//            ViewController.navigationItem.largeTitleDisplayMode = .inline
//        } else {
//            // Fallback on earlier versions
//        }
        // 开启导航栏大标题
        ViewController.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

/// 👷创建设置模块的单个控件的结构体
///
/// 单个设置的控件由说明、控件和提示组成，`Setting`依靠下面这个方法来生成设置控件
/// ```swift
/// controlBuild(caption: String, control: Array<controlMode>, tips: String) -> Array<UIView>
/// ```
///
/// - Note: `controlBuild(caption: String, control: Array<controlMode>, tips: String) -> Array<UIView>`有三个重载方法，分别可以省略`caption`、`tips`、`control`和`tips`
struct SettingControl {
    /// ⚙️判断设置行的基础类型的枚举值
    enum rowMode: Int {
        // 继承Int协议目的是让custom1、custom2、custom3、custom4分别有对应的rawValue来判断高度倍数，切记顺序不可打乱
        /// 占位置，让后面的`custom1、custom2、custom3、custom4`的原始值分别为1、2、3、4，不要使用
        case custom
        /// 自定义设置行（1倍高度），返回一个`UIView`用来自定义
        case custom1
        /// 自定义设置行（2倍高度），返回一个`UIView`用来自定义
        case custom2
        /// 自定义设置行（3倍高度），返回一个`UIView`用来自定义
        case custom3
        /// 自定义设置行（4倍高度），返回一个`UIView`用来自定义
        case custom4
        /// 跳转界面设置行，返回一个`UIButton`用来关联跳转界面的方法
        case forward
        /// 开关设置行，返回一个`UISwitch`用来关联开关对应的方法
        case toggle
    }
    
    /// ⚙️判断设置行前是否有图标的枚举值（⚠️未做）
    enum imageMode {
        /// 默认类型，行前没有图标（💡可以省略此参数）
        case basic
        /// 行前有图标的类型
        case image
    }
    
    /// 创建设置模块的单个控件的结构体的方法
    ///
    /// # 使用方法
    /// 暂无
    ///
    /// 通过引用其他方法来创建整个设置模块，需要传递一个该设置模块的标题以及若干个说明和提示
    /// - Parameter caption: `String`，说明，显示在控件的上方
    /// - Parameter control: `Array<controlMode>`，控件主体，数组内是一个枚举值，`forward`表示跳转类型设置，`toggle`表示开关设置（传出标准尺寸的开关设置行），`custom`表示自定义设置
    /// - Parameter tips: `String`，提示，显示在控件的下方
    ///
    /// - Note: 整个控件的主体部分的行数为`control`参数的元素数。返回值的数组的第`0`个元素为整个控件的`UIView`，其余按顺序为各行
    ///
    /// - Returns: `Array<UIView>`
    ///
    /// # 返回值介绍
    /// **整个控件**：`UIView`，一般在外界设置这个`UIView`的原点`UIView.frame.origin`
    ///
    /// **forward**：`UIButton`，标准尺寸跳转行的整行，一般调用`UIButton`的`setTitle()`方法添加内容，并且用`addTarget()`关联上跳转界面的方法
    ///
    /// **toggle**：`UIButton`，标准尺寸的开关设置行的整行，一般调用`UIButton`的`setTitle()`方法添加内容，然后遍历其子视图找到`UISwitch`并且关联上方法
    ///
    /// **custom**：`UIView`，自定义设置块的整个视图，在这个`UIView`上做手脚
    static func build(control: Array<rowMode>? = [.forward], caption: String? = nil, tips: String? = nil, mode: imageMode? = .basic, label: Array<String>? = nil, text: Array<String>? = nil) -> Dictionary<String, UIView> {
        // imageMode模式还没做
        /// 作为返回值的数组（`returnArray`），接收所有返回值
        var returnDictionary: Dictionary<String, UIView> = ["control0": UIView(), "0": UIView()]
        
        /// 设置控件最底层的`UIView`
        let settingControl = UIView()
        returnDictionary["view"] = settingControl
        
        /// 控件上方的说明（`caption`）部分
        let captionLabel = UILabel().fontAdaptive(caption ?? "", font: JunFont.tips())
        if caption != nil {
            captionLabel.textColor = UIColor.black.withAlphaComponent(0.6)
            settingControl.addSubview(captionLabel)
            captionLabel.snp.makeConstraints { make in
                make.top.equalTo(0)
                make.left.equalTo(16)
                make.right.equalTo(-16)
            }
        }
        
        /// 设置控件主体的`UIView`
        let settingTable = UIView()
        settingTable.backgroundColor = JunColor.control()
        settingTable.layer.cornerRadius = 12

        for (index, item) in control!.enumerated() {
            var row = UIView()
            switch item {
            case .forward:
                row = forward(text: text, index)[0] // 跳转界面类型的设置行
                let rowLabelRight = forward(text: text, index)[1] as! UILabel
                row.addSubview(rowLabelRight)
                rowLabelRight.snp.makeConstraints { make in
                    make.top.equalTo(12)
                    make.height.equalTo(rowLabelRight.frame.height)
                    make.left.equalTo(16)
                    make.right.equalTo(-30)
                }
                returnDictionary["text\(index + 1)"] = rowLabelRight
                returnDictionary["control\(index + 1)"] = row
            case .toggle:
                row = toggle()[0] // 开关类型的设置行
                let rowSwitch = toggle()[1]
                row.addSubview(rowSwitch)
                rowSwitch.snp.makeConstraints { make in
                    make.top.equalTo(6.5)
                    make.height.equalTo(rowSwitch.frame.height)
                    make.width.equalTo(rowSwitch.frame.width)
                    make.right.equalTo(-67 + rowSwitch.frame.width)
                }
                returnDictionary["control\(index + 1)"] = rowSwitch
            case .custom: break
            default:
                row = custom(item) // 自定义设置行
                returnDictionary["control\(index + 1)"] = row
            }
            // 配置这些行的通用参数
            settingTable.addSubview(row)
            returnDictionary["\(index + 1)"] = row
            returnDictionary["\(index + 1)"]!.snp.makeConstraints { (make) in
                if index == 0 {
                    make.top.equalTo(returnDictionary["\(index)"]!.frame.maxY)
                } else {
                    make.top.equalTo(returnDictionary["\(index)"]!.snp.bottom)
                }
                make.height.equalTo(row.frame.height)
                make.left.right.equalTo(0)
            }
            
            /// 每一行左侧的文本内容
            let rowLabelLeft = UILabel()
            rowLabelLeft.text = label?[index] ?? " "
            rowLabelLeft.font = JunFont.text(.regular)
            rowLabelLeft.textColor = UIColor.black
            rowLabelLeft.sizeToFit()
            row.addSubview(rowLabelLeft)
            rowLabelLeft.snp.makeConstraints { make in
                make.top.equalTo(12)
                make.height.equalTo(rowLabelLeft.frame.height)
                make.left.equalTo(16)
                make.right.equalTo(-70)
            }
            returnDictionary["label\(index + 1)"] = rowLabelLeft
        
            // 创建各个设置行之间的分割线
            if index != 0 {
                // 创建线条并且设置相关属性
                let segmentedLine = UIView()
                segmentedLine.backgroundColor = UIColor(cgColor: JunColor.segmentedLine().cgColor)
                settingTable.addSubview(segmentedLine)
                // 使用SnapKit来设置线条的约束
                segmentedLine.snp.makeConstraints { make in
                    make.left.equalTo(16)
                    make.right.equalToSuperview()
                    make.height.equalTo(0.5)
                    make.top.equalTo(returnDictionary["\(index)"]!.snp.bottom).offset(-0.25)
                }
            }

        }
        // 设置底层和主体视图的height
        settingControl.addSubview(settingTable)
        settingTable.snp.makeConstraints { make in
            if (caption == nil) {
                make.top.equalTo(0)
            } else {
                make.top.equalTo(captionLabel.snp.bottom).offset(6)
            }
            make.bottom.equalTo(returnDictionary["\(control!.count)"]!.snp.bottom)
            make.left.right.equalTo(0)
            if tips == nil {
                make.bottom.equalToSuperview()
            }
        }
        /// 控件下方的提示（`tips`）部分
        let tipsLabel = UILabel().fontAdaptive(tips ?? "", font: JunFont.tips())
        if tips != nil {
            tipsLabel.textColor = UIColor.black.withAlphaComponent(0.6)
            settingControl.addSubview(tipsLabel)
            tipsLabel.snp.makeConstraints { make in
                make.top.equalTo(settingTable.snp.bottom).offset(6)
                make.bottom.equalToSuperview()
                make.left.equalTo(16)
                make.right.equalTo(-16)
            }
        }
        
        return returnDictionary
    }
    
    /// 创建设置控件的单行（跳转界面类型）
    private static func forward(text: Array<String>? = nil, _ index: Int) -> Array<UIView> {
        /// 设置控件的单行
        let row = UIButton()
        row.frame.size.height = 44
        
        /// 设置控件跳转类型行的跳转箭头图标
        let rowIcon = UIImageView()
        rowIcon.image = UIImage(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        rowIcon.tintColor = UIColor.black.withAlphaComponent(0.5)
        row.addSubview(rowIcon)
        rowIcon.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.height.equalTo(16)
            make.width.equalTo(10)
            make.right.equalTo(-15)
        }
        
        /// 每一行右侧的文本内容
        let rowLabel = UILabel()
        var string: String = " "
        if text?.count ?? 0 > index {
            string = text![index]
        } // 处理空行或者数组数不够的情况
        rowLabel.text = string
        rowLabel.font = JunFont.text(.regular)
        rowLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        rowLabel.sizeToFit()
        rowLabel.textAlignment = .right
        
        return [row, rowLabel]
    }
    
    /// 创建设置控件的单行（跳转界面类型）
    private static func forward2(text: Array<String>? = nil, _ index: Int) -> Array<UIView> {
        /// 设置控件的单行
        let row = UIButton()
        row.frame.size.height = 66
        
        /// 设置控件跳转类型行的跳转箭头图标
        let rowIcon = UIImageView()
        rowIcon.image = UIImage(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        rowIcon.tintColor = UIColor.black.withAlphaComponent(0.5)
        row.addSubview(rowIcon)
        rowIcon.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.height.equalTo(16)
            make.width.equalTo(10)
            make.right.equalTo(-15)
        }
        
        /// 每一行右侧的文本内容
        let rowLabel = UILabel()
        var string: String = " "
        if text?.count ?? 0 > index {
            string = text![index]
        } // 处理空行或者数组数不够的情况
        rowLabel.text = string
        rowLabel.font = JunFont.text(.regular)
        rowLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        rowLabel.sizeToFit()
        rowLabel.textAlignment = .right
        
        return [row, rowLabel]
    }
    
    /// 创建设置控件的单行（开关类型）
    private static func toggle() -> Array<UIView> {
        /// 设置控件的单行
        let row = UIButton()
        row.frame.size.height = 44
        
        /// 设置控件开关类型行的开关
        let rowSwitch = UISwitch()
        
        return [row, rowSwitch]
    }
    private static func custom(_ sender: rowMode) -> UIView {
        /// 匹配`custom`的原始值来判断高度倍数
        let parameter: CGFloat = CGFloat(sender.rawValue)
        
        /// 设置控件的单行
        let row = UIView()
        row.frame.size.height = 44 * parameter
        
        return row
    }
}

/// ⛏️创建展示模块的单个控件的结构体
struct ShowcaseControl {
    enum coverPosition { // ⚠️未启用
        /// 默认类型，行前没有图标（💡可以省略此参数）
        case left
        /// 行前有图标的类型
        case right
    }
    
    // 初始化
    static let mediumControlImageWidth = CGFloat(120)
    
    /// 行控件：如同学习界面精选课程展示框；一侧放置4:3的长方形封面，另一侧放置简介信息(模糊蒙版)
    static func rowBuild(image: UIImage,
                         title: String,
                         text: String,
                         direction: Bool) -> [UIView] {
        let mediumControlSize = CGSize(width: JunScreen.basicWidth(), height: 90)

        /// 创建控件主体(一个UIButton)
        let control = UIButton()

        // 配置主体控件的基本属性
        control.layer.cornerRadius = 15
        control.layer.masksToBounds = true
        
        let cover = UIImageView(image: image)
        cover.contentMode = .scaleAspectFill
        control.addSubview(cover)
        cover.snp.makeConstraints { make in
            make.top.bottom.equalTo(0)
            if direction {
                make.left.equalTo(0)
            } else {
                make.right.equalTo(0)
            }
            make.width.equalTo(120)
        }
        
        let background = UIImageView(image: image)
        control.addSubview(background)
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(direction ?
                                                UIEdgeInsets(top: 0, left: 120, bottom: 0, right: 0):
                                                UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 120))
        }
        
        /// 控件显示内容部分的高斯模糊
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        control.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(direction ?
                                                UIEdgeInsets(top: 0, left: 120, bottom: 0, right: 0):
                                                UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 120))
        }
        blurView.isUserInteractionEnabled = false
        blurView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        
        /// 设置控件的标题
        let largeTitle = UILabel()
        largeTitle.text = title
        largeTitle.textColor = UIColor.black
        largeTitle.font = JunFont.title2()
        largeTitle.sizeToFit()
        largeTitle.isUserInteractionEnabled = false
        control.addSubview(largeTitle)
        largeTitle.snp.makeConstraints { make in
            make.height.equalTo(largeTitle.frame.height)
            make.top.equalTo(15)
            make.left.equalTo(direction ? 135: 15)
            make.right.equalTo(direction ? -15: -135)
        }
        
        // 设置控件的副标题(作者名)
        let smallTitle = UILabel(frame: CGRect(x: !direction ? JunSpaced.screen(): mediumControlImageWidth + JunSpaced.screen(), y: mediumControlSize.height / 5 * 3, width: 0, height: 0))
        smallTitle.text = text
        smallTitle.textColor = UIColor.black
        smallTitle.font = JunFont.text()
        smallTitle.sizeToFit()
        smallTitle.isUserInteractionEnabled = false
        control.addSubview(smallTitle)
        smallTitle.snp.makeConstraints { make in
            make.height.equalTo(smallTitle.frame.height)
            make.bottom.equalTo(-15)
            make.left.equalTo(direction ? 135: 15)
            make.right.equalTo(direction ? -15: -135)
        }
        // ⚠️这两个标题还有一个未解决的隐患：没有考虑标题字数太长的问题
        
        return [control, largeTitle, smallTitle, cover, background]
    }
    
    static let largeControlSize = CGSize(width: 270, height: 360)
    
    static func boxBuild(image: UIImage,
                         title: String,
                         text: String) -> [UIView] {

        // 创建控件主体(一个UIButton)
        let control = UIButton()
        control.layer.cornerRadius = 15
        control.layer.masksToBounds = true
        
        let cover = UIImageView(image: image)
        cover.contentMode = .scaleAspectFill
        control.addSubview(cover)
        cover.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(270)
        }
        
        let background = UIImageView(image: image)
        control.addSubview(background)
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 270, left: 0, bottom: 0, right: 0))
        }

        // 设置控件底部的高斯模糊
        /// 控件显示内容部分的高斯模糊
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        control.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 270, left: 0, bottom: 0, right: 0))
        }
        blurView.isUserInteractionEnabled = false
        blurView.backgroundColor = .black.withAlphaComponent(0.6)
        
        // 设置控件的标题
        let largeTitle = UILabel()
        largeTitle.text = title
        largeTitle.textColor = UIColor.white
        largeTitle.font = JunFont.title2()
        largeTitle.sizeToFit()
        largeTitle.isUserInteractionEnabled = false
        control.addSubview(largeTitle)
        largeTitle.snp.makeConstraints { make in
            make.height.equalTo(largeTitle.frame.height)
            make.top.equalTo(285)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        // 设置控件的副标题(作者名)
        let smallTitle = UILabel()
        smallTitle.text = text
        smallTitle.textColor = UIColor.white
        smallTitle.font = JunFont.text()
        smallTitle.sizeToFit()
        smallTitle.isUserInteractionEnabled = false
        control.addSubview(smallTitle)
        smallTitle.snp.makeConstraints { make in
            make.height.equalTo(largeTitle.frame.height)
            make.bottom.equalTo(-15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        // 这两个标题还有一个未解决的隐患：没有考虑标题字数太长的问题
        
        return [control, largeTitle, smallTitle, cover, background]
    }
}



// type: 类型(自定义: custom, 开关: switch, 跳转: forward)
// rowTitle:
// rowHeight: 行高(默认: default, 倍数)
// title
func settingControlBuild(title: String, tips: String, _ superView: UIView, _ pointY: CGFloat, parameter: Array<Dictionary<String, String>>) -> CGFloat {
    // 标题
    let settingModuleTitle = UILabel(frame: CGRect(x: JunSpaced.screenAuto() + 18, y: pointY, width: JunScreen.basicWidth(), height: 0))
    if !title.isEmpty {
        settingModuleTitle.text = title
        settingModuleTitle.numberOfLines = 0
        settingModuleTitle.font = JunFont.tips()
        settingModuleTitle.sizeToFit()
        settingModuleTitle.frame.size.width = JunScreen.basicWidth() - 36
        settingModuleTitle.textColor = UIColor.black.withAlphaComponent(0.6)
        superView.addSubview(settingModuleTitle)
    }
    
    var settingModuleHeight = CGFloat(0)
    for (index, item) in parameter.enumerated() {
        if index != 0 {
            settingModuleHeight += 1
        }
        switch item["rowHeight"] {
        case "default": settingModuleHeight += CGFloat(44)
        case "thrice": settingModuleHeight += CGFloat(44) * 3
        default:
            break
        }
    }
    
    // 设置主体框
    let settingModuleBox = UIView(frame: CGRect(x: JunSpaced.screenAuto(), y: settingModuleTitle.frame.maxY + 6, width: JunScreen.basicWidth(), height: settingModuleHeight))
    settingModuleBox.backgroundColor = UIColor.systemBackground
    settingModuleBox.layer.cornerRadius = 12
    settingModuleBox.clipsToBounds = true
    superView.addSubview(settingModuleBox)
    
    let settingModuleTips = UILabel(frame: CGRect(x: JunSpaced.screenAuto() + 18, y: settingModuleBox.frame.maxY + 6, width: JunScreen.basicWidth(), height: 0))
    if !tips.isEmpty {
        settingModuleTips.text = tips
        settingModuleTips.numberOfLines = 0
        settingModuleTips.font = JunFont.tips()
        settingModuleTips.sizeToFit()
        settingModuleTips.frame.size.width = settingModuleBox.frame.width - 36
        settingModuleTips.textColor = UIColor.black.withAlphaComponent(0.6)
        superView.addSubview(settingModuleTips)
    }
    
    for item in parameter {
        switch item["type"] {
        case "custom": break
        case "forward":
            let rowBox = UIButton()
            rowBox.frame.origin = CGPointZero
            rowBox.frame.size = settingModuleBox.frame.size
            settingModuleBox.addSubview(rowBox)
            
            let rowTitle = UILabel()
            rowTitle.frame.origin = CGPoint(x: 18, y: 13)
            rowTitle.text = item["rowTitle"]
            rowTitle.font = JunFont.text()
            rowTitle.textColor = UIColor.black
            rowTitle.sizeToFit()
            rowBox.addSubview(rowTitle)
            
            let rowIcon = UIImageView(frame: CGRect(x: settingModuleBox.frame.maxX - 45, y: 14, width: 10, height: 16))
            rowIcon.image = UIImage(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            rowIcon.tintColor = UIColor.black.withAlphaComponent(0.5)
            rowBox.addSubview(rowIcon)
        case "switch": break
        default:
            break
        }
    }
    return settingModuleTips.frame.maxY
}
