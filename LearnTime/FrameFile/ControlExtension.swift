// 常用控件的编写操作写成扩展，方便使用
import Foundation
import UIKit
import ObjectiveC

private var infoStringKey: UInt8 = 0
//private var coverDataKey: Data = Data()

extension UIButton {
    var infoString: [String]? {
        get {
            return objc_getAssociatedObject(self, &infoStringKey) as? [String]
        }
        set {
            objc_setAssociatedObject(self, &infoStringKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
//    var coverData: Data? {
//        get {
//            return objc_getAssociatedObject(self, &coverDataKey) as? Data
//        }
//        set {
//            objc_setAssociatedObject(self, &coverDataKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
}

// 扩展UILable的随字体大小自适应尺寸方法
extension UILabel {
    /// `UILabel`随字体大小和内容自适应自己的`frame.size`属性
    ///
    /// 只是省略部分常用代码
    ///
    /// # 省略的代码部分
    /// 只是省略部分常用代码
    /// ```swift
    /// let lable = UILabel()
    /// lable.text = text
    /// lable.font = font
    /// lable.sizeToFit()
    /// lable.numberOfLines = 0
    /// ```
    ///
    /// # 如何使用
    /// 用下列代码设置好文本本体后，还需要设置文本的原点（`origin`）。当然了，别忘了将它设置为目标视图的子视图
    /// ```swift
    /// let lable = UILabel().fontAdaptive(_ text: String, font: UIFont)
    /// ```
    ///
    /// - Parameter text: 内容
    /// - Parameter font: 字体大小
    func fontAdaptive(_ text: String, font: UIFont) -> UILabel {
        let lable = UILabel()
        lable.text = text
        lable.font = font
        lable.numberOfLines = 0
        lable.sizeToFit()
        return lable
    }
}

// 扩展UIButton的创建模块标题（一级标题）按钮方法
extension UIButton {
    /// 普通界面模块标题（一级标题）的显示模式
    enum moduleTitleType {
        /// 标准模式，没有跳转界面的指示箭头
        case basic
        /// 跳转模式，有跳转界面的指示箭头
        case arrow
    }
    /// 普通界面模块标题（一级标题）按钮的创建
    ///
    /// 该标题仅次于大标题，用于分割、指示和跳转界面上的每个模块
    ///
    /// # 如何使用
    /// 标题本体一行代码直接搞定，不用设置其他东西。但是如果你需要跳转界面，那就需要`addTarget()`方法的帮助了。当然了，别忘了将它设置为目标视图的子视图
    ///
    /// ## 示例代码
    /// 创建模块标题
    /// ```swift
    /// let moduleTitleOriginY = CGFloat()
    /// let moduleTitle = UIButton().moduleTitleMode("偏好设置", originY: moduleTitleOriginY, mode: .arrow)
    /// superView.addSubview(moduleTitle)
    /// ```
    /// 关联跳转方法
    /// ```swift
    /// moduleTitle.addTarget(self, action: #selector(clicked), for: .touchUpInside)
    /// ```
    /// 跳转界面的方法
    /// ```swift
    /// @objc func clicked() {
    ///     let VC = TargetViewController()
    ///     self.navigationController?.pushViewController(VC, animated: true)
    /// }
    /// ```
    ///
    /// - Parameter text: 标题内容
    /// - Parameter originY: Y轴坐标值
    /// - Parameter mode: 枚举值（`moduleTitleMode`），选择标题后是否跟随一个箭头（跳转界面指示）
    ///
    /// - note: 模块标题不需要换行，所以没有适配换行效果
    func moduleTitleMode(_ text: String, mode: moduleTitleType) -> UIButton {
        /// 普通界面模块标题（一级标题）按钮的主体
        let titleButton = UIButton()
            
        /// 普通界面模块标题（一级标题）按钮的标题
        let titleLable = UILabel(frame: CGRectZero)
        titleLable.text = text
        titleLable.font = Font.title1()
        titleLable.sizeToFit()
        titleButton.addSubview(titleLable)
        titleButton.frame.size.height = titleLable.frame.height
        
        // 主体适应标题的高度

        
        // 创建模块标题的箭头
        switch mode {
        case .arrow:
            let arrow = UIImageView(frame: CGRect(x: titleLable.frame.maxX + 5, y: 6, width: 15, height: titleLable.frame.size.height - 12))
            arrow.image = UIImage(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            arrow.tintColor = UIColor.black.withAlphaComponent(0.5)
            titleButton.addSubview(arrow)
        default: break
        }
        
        return titleButton
    }
}

