// 常用控件的编写操作写成扩展，方便使用
import Foundation
import UIKit
import ObjectiveC
import LeanCloud

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
        titleLable.font = JunFont.title1()
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

class InsetTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 12, dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 12, dy: 10)
    }
}

func errorLeanCloud(_ error: LCError, view: UIView) {
    switch error.code {
    case 1:
        view.makeToast("\(error.description)", duration: 3, position: .top)
    case 119:
        view.makeToast("\(error.description)", duration: 3, position: .top)
    case 125:
        view.makeToast("邮箱地址无效", duration: 1.5, position: .top)
    case 127:
        view.makeToast("手机号无效", duration: 1.5, position: .top)
    case 201:
        view.makeToast("用户名和密码不匹配", duration: 1.5, position: .top)
    case 202:
        view.makeToast("用户名已被注册", duration: 1.5, position: .top)
    case 203:
        view.makeToast("邮箱地址已被注册", duration: 1.5, position: .top)
    case 206:
        view.makeToast("登录失效，请退出当前账户后重新登录", duration: 1.5, position: .top)
    case 211:
        view.makeToast("账户不存在", duration: 1.5, position: .top)
    case 214:
        view.makeToast("手机号已被注册", duration: 1.5, position: .top)
    case 217:
        view.makeToast("用户名不能为空", duration: 1.5, position: .top)
    case 218:
        view.makeToast("密码不能为空", duration: 1.5, position: .top)
    case 219:
        view.makeToast("此用户名对应的账户已被锁定，请稍后再试", duration: 1.5, position: .top)
    case 603:
        view.makeToast("短信验证码无效", duration: 1.5, position: .top)
    case 605:
        view.makeToast("测试阶段短信验证功能暂未开启，敬请期待", duration: 1.5, position: .top)
    default:
        view.makeToast("错误码\(error.code)\n描述：\(error.description)\n建议截图前往“软件设置 > 反馈问题 > 显示错误码”处反馈", duration: 4, position: .top)
    }
}
