// 常用的标准化数据封装起来，方便调用和统一修改

import Foundation
import UIKit

/// 返回屏幕的基础尺寸数据
struct JunScreen {
    static func safeAreaInsets() -> UIEdgeInsets {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.safeAreaInsets ?? UIEdgeInsets.zero
    }
    static func nativeHeight() -> CGFloat {
        UIScreen.main.nativeBounds.height / UIScreen.main.nativeScale // 与设备屏幕高度一样宽(物理)
    }
    static func nativeWidth() -> CGFloat {
        UIScreen.main.nativeBounds.width / UIScreen.main.nativeScale // 与设备屏幕宽度一样宽(物理)
    }
    static func nativeBasicWidth() -> CGFloat {
        UIScreen.main.nativeBounds.width / UIScreen.main.nativeScale - JunSpaced.screen() * 2 // 与设备屏幕宽度一样宽(物理)
    }
    static func width() -> CGFloat {
        UIScreen.main.bounds.width // 与设备屏幕宽度一样宽
    }
    static func height() -> CGFloat {
        UIScreen.main.bounds.height // 与设备屏幕高度一样高
    }
    static func Size() -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) // 屏幕等大的尺寸
    }
    static func bounds() -> CGRect {
        CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) // 整个屏幕显示范围
    }
    static func superBounds() -> CGRect {
        CGRect(x: 0, y: 0, width: UIScreen.main.nativeBounds.height, height: UIScreen.main.nativeBounds.height) // 整个屏幕显示范围
    }
    static func basicWidth() -> CGFloat {
        UIScreen.main.bounds.width - JunSpaced.screenAuto() * 2 // 去掉外边距的标准宽度
    }
}

/// 选择间距相关的方法，返回CGFloat
struct JunSpaced {
    /// 屏幕边框与内容之间的间距
    static func screen() -> CGFloat {
        20
    }
    /// 屏幕边框与内容之间的间距，会根据安全区域自动调整
    static func screenAuto() -> CGFloat {
        20 + JunScreen.safeAreaInsets().left
    }
    /// 各个相邻的控件之间的间距，也用做二级标题和模块之间的间距/
    static func control() -> CGFloat {
        10
    }
    /// 各个模块之间的间距/
    static func module() -> CGFloat {
        30
    }
    /// 各个设置之间的间距
    static func setting() -> CGFloat {
        25
    }
    /// 导航栏与第一个模块之间的间距
    static func navigation() -> CGFloat {
        18
    }
    /// 代码块的代码行间距
    static func codeRow() -> CGFloat {
        4
    }
}

/// 通知：修改主题相关
let changeThemeNotification = Notification.Name(String())
/// 通知：账户状态改变
let accountStatusChangeNotification = Notification.Name(String())
/// 通知：邮箱验证状态改变
let emailVerifiedStatusChangeNotification = Notification.Name(String())

/// 通知：数据请求相关
let valueChangeNotification = Notification.Name(String())

/// 字体结构体，选择对应的方法返回对应的`UIFont`
/// # 使用方法
/// ```swift
/// JunFont.title()
/// ```
/// # 预设字体方法
/// - 大标题（类似`largeTitle`）
/// ```swift
/// title() -> UIFont
/// ```
/// - 一级标题，每个模块的标题，正文的一级标题
/// ```swift
/// title1() -> UIFont
/// ```
/// - 二级标题，正文的二级标题
/// ```swift
/// title2() -> UIFont
/// ```
/// - 三级标题，正文的二级标题
/// ```swift
/// title3() -> UIFont
/// ```
/// - 正文字体（重载方法可自定义字重）
/// ```swift
/// text() -> UIFont
/// text(_ weight: UIFont.Weight)
/// ```
/// - 副文字体，比如表格等部分的显示字体
/// ```swift
/// smallText() -> UIFont
/// ```
/// - 设置界面的说明（`caption`）和提示（`tips`）
/// ```swift
/// tips() -> UIFont
/// ```
/// - 代码块显示字体
/// ```swift
/// code() -> UIFont
/// ```
struct JunFont {
    /// 大标题（类似`largeTitle`）
    static func title() -> UIFont {
        UIFont.boldSystemFont(ofSize: 34)
    }
    /// 一级标题，每个模块的标题，正文的一级标题
    static func title1() -> UIFont {
        UIFont.boldSystemFont(ofSize: 28)
    }
    /// 二级标题，正文的二级标题
    static func title2() -> UIFont {
        UIFont.systemFont(ofSize: 22, weight: .medium)
    }
    /// 三级标题，正文的二级标题
    static func title3() -> UIFont {
        UIFont.systemFont(ofSize: 20, weight: .medium)
    }
    /// 正文字体
    static func text() -> UIFont {
        UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    /// 自定义字重的正文字体
    static func text(_ weight: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: 17, weight: weight)
    }
    /// 副文字体，比如表格等部分的显示字体
    static func smallText() -> UIFont {
        UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    /// 设置界面的说明（`caption`）和提示（`tips`）
    static func tips() -> UIFont {
        UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    /// 代码块显示字体
    static func code() -> UIFont {
        UIFont(name: "Menlo", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
    }
}

/// 颜色结构体，选择对应的方法返回对应的`UIColor`
/// # 使用方法
/// ```swift
/// JunColor.title()
/// ```
/// # 预设字体方法
/// - 大标题（类似`largeTitle`）
/// ```swift
/// title() -> UIFont
/// ```
/// - 一级标题，每个模块的标题，正文的一级标题
/// ```swift
/// title1() -> UIFont
/// ```
/// - 二级标题，正文的二级标题
/// ```swift
/// title2() -> UIFont
/// ```
/// - 三级标题，正文的二级标题
/// ```swift
/// title3() -> UIFont
/// ```
/// - 正文字体（重载方法可自定义字重）
/// ```swift
/// text() -> UIFont
/// text(_ weight: UIFont.Weight)
/// ```
/// - 副文字体，比如表格等部分的显示字体
/// ```swift
/// smallText() -> UIFont
/// ```
/// - 设置界面的说明（`caption`）和提示（`tips`）
/// ```swift
/// tips() -> UIFont
/// ```
/// - 代码块显示字体
/// ```swift
/// code() -> UIFont
/// ```
struct JunColor {
    /// 标准界面的背景色
    static func background() -> UIColor {
        UIColor.white
    }
    /// 有默认分组控件界面的背景色（例如设置界面背景）
    static func groupBackground() -> UIColor {
        UIColor.systemGroupedBackground
    }
    /// 默认分组控件的主体色（例如设置界面控件）
    static func control() -> UIColor {
        UIColor.white
    }
    /// 设置控件的行间分隔线颜色
    static func segmentedLine() -> UIColor {
        UIColor.black.withAlphaComponent(0.2)
    }
    /// 主题色（紫）
    static func learnTime0() -> UIColor {
        UIColor(red: 165/255.0, green: 164/255.0, blue: 231/255.0, alpha: 1.000)
    }
    /// 主题色（红）
    static func learnTime1() -> UIColor {
        UIColor(red: 246/255.0, green: 169/255.0, blue: 173/255.0, alpha: 1.000)
    }
}



// 废弃⚠️
let featuredCollectionsDataArray = featuredCollectionsDataInitialize()
let ContentData = contentDataInitialize()
let essayData: Dictionary<String, Dictionary<String, Any>> = ContentData["essay"]!
let collectionData: Dictionary<String, Dictionary<String, Any>> = ContentData["collections"]!





//// 判断字符串是否超出UILabel的范围
//func isTruncated(_ label: UILabel) -> Bool {
//
//    let judgmentLabel = UILabel()
//    judgmentLabel.text = label.text
//    judgmentLabel.font = UIFont.systemFont(ofSize: CGFloat(titleFont3), weight: .bold)
//    judgmentLabel.sizeToFit()
//    return label.frame.width < judgmentLabel.frame.width
//
//}
//
//func navBar(_ navBar: UINavigationBar) -> CGFloat {
//    navBar.frame.height
//}

//func a(viewController: UIViewController) {
//    if viewController.traitCollection.userInterfaceStyle == .dark {
//        // User Interface is Dark
//    } else {
//        // User Interface is Light
//    }
//}


// 关于内容结构
// 收藏夹：可以包含任何形式的内容，不限作者
// 合集：可以包含文章，其中的文章必须为自己原创或者他人授权转载，所有的文章作者都需要标注在合集作者内
// 文章：可以转载可以原创，内容较为严谨，用于学习
// 杂谈：内容随意，可以用于提问、讨论、闲聊等用途；类似其他软件的动态功能
// 举报与反馈：类似杂谈模块的格式
// 官方公示：类似文章模块的格式，不过没有封面

// 关于封面
// 合集和头像的封面限制为1:1方形；收藏夹的封面限制为3:2长方形；文章的封面限制为4:3长方形；杂谈类型无封面，图片尺寸随意
