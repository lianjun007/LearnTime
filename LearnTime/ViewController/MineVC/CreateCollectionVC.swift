import UIKit
import LeanCloud
import SnapKit

/// 创建合集界面的声明内容
class CreateCollectionViewController: UIViewController, UINavigationControllerDelegate {
    /// 底层的滚动视图，最基础的界面
    let underlyView = UIScrollView()
    /// 底层滚动视图的内容视图
    let containerView = UIView()
    
    /// 自动布局顶部参考，用来流式创建控件时定位
    var snpTop: ConstraintRelatableTarget!
    
    /// 用户封面图的载体
    var collectionCoverBox = UIButton()
    /// 合集标题输入框
    let titieInputBox = InsetTextField()
    /// 密码输入框
    let passwordInputBox = InsetTextField()
    /// 邮箱地址输入框
    let emailInputBox = InsetTextField()
    /// 手机号输入框
    let phoneInputBox = InsetTextField()
}

// ♻️控制器的生命周期方法
extension CreateCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "创建合集", mode: .group)
        // 设置输入框的代理（UITextFieldDelegate）
        titieInputBox.delegate = self
        passwordInputBox.delegate = self
        emailInputBox.delegate = self
        phoneInputBox.delegate = self
        
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
        
        // 导航栏：导航栏按钮
        moduleNav()
        snpTop = module0()
        // 模块1：输入合集标题
        snpTop = module1(snpTop)
//        // 模块2：输入密码
//        snpTop = module2(snpTop)
//        // 模块3：输入邮箱地址
//        snpTop = module3(snpTop)
//        // 模块4：输入手机号
//        snpTop = module4(snpTop)
//        // 模块5：注册并且登录按钮
        module5(snpTop)
        
        // 键盘显示和隐藏时触发相关通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// 📦分模块封装控件创建的方法
extension CreateCollectionViewController {
    /// 创建导航栏按钮的方法
    func moduleNav() {
        /// 收起键盘的按钮
        let keyboardHideButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .plain, target: self, action: #selector(keyboardHide))
        keyboardHideButton.tintColor = JunColor.learnTime1()
        navigationItem.rightBarButtonItem = keyboardHideButton
        
        /// 收起此界面的按钮
        let dismissVCButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(dismissVC))
        dismissVCButton.tintColor = JunColor.learnTime1()
        navigationItem.leftBarButtonItem = dismissVCButton
    }
    
    /// 创建模块0的方法
    func module0() -> ConstraintRelatableTarget {
        /// 账户封面（头像）显示的容器
        collectionCoverBox.setBackgroundImage(UIImage(named: "aaa"), for: .normal)
        collectionCoverBox.layer.cornerRadius = 15
        collectionCoverBox.layer.masksToBounds = true
        collectionCoverBox.contentMode = .scaleAspectFit
        containerView.addSubview(collectionCoverBox)
        collectionCoverBox.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.width.height.equalTo(JunScreen.nativeHeight() / 3.5)
            make.top.equalTo(JunSpaced.navigation())
        }
        collectionCoverBox.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        
        /// 控件显示内容部分的高斯模糊
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        collectionCoverBox.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.height.equalTo(44)
            make.bottom.equalTo(collectionCoverBox).offset(0)
        }
        blurView.isUserInteractionEnabled = false
        
        /// 用户名标题
        let title = UILabel().fontAdaptive("点击设置封面", font: JunFont.title2())
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.center.equalTo(blurView)
        }
        
        return collectionCoverBox.snp.bottom
    }
    
    /// 创建模块1的方法
    func module1(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题
        let title = UIButton().moduleTitleMode("合集标题", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        // 配置用户名输入框
        titieInputBox.layer.borderWidth = 3
        titieInputBox.layer.borderColor = JunColor.learnTime1().cgColor
        titieInputBox.backgroundColor = UIColor.white
        titieInputBox.layer.cornerRadius = 15
        titieInputBox.tintColor = UIColor.black.withAlphaComponent(0.6)
        titieInputBox.font = JunFont.title2()
        titieInputBox.textColor = UIColor.black.withAlphaComponent(0.6)
        titieInputBox.placeholder = "必填"
        containerView.addSubview(titieInputBox)
        titieInputBox.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(44)
        }
        
        /// 用户名输入框下方的提示控件的提示图标1
        let tipsIcon1 = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon1.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon1)
        tipsIcon1.snp.makeConstraints { make in
            make.top.equalTo(titieInputBox.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 用户名输入框下方的提示控件的提示内容1
        let tipsLabel1 = UILabel().fontAdaptive("合集标题的长度、内容、复杂度、字符类型不作限制，但是不建议过于奇怪。", font: JunFont.tips())
            tipsLabel1.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel1)
            tipsLabel1.snp.makeConstraints { make in
                make.top.equalTo(titieInputBox.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(tipsIcon1.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        return tipsLabel1.snp.bottom
    }
    
    /// 创建模块5的方法
    func module5(_ snpTop: ConstraintRelatableTarget) {
        /// 注册并且登录的按钮
        let createButton = UIButton()
        createButton.backgroundColor = JunColor.learnTime1()
        createButton.layer.cornerRadius = 20
        createButton.setTitle("创建合集", for: .normal)
        createButton.titleLabel?.font = JunFont.title2()
        createButton.setTitleColor(UIColor.black, for: .normal)
        containerView.addSubview(createButton)
        createButton.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-JunSpaced.module())
        }
        createButton.addTarget(self, action: #selector(clickedCreateCollectionButton), for: .touchUpInside)
    }
}

// 🫳界面中其他交互触发的方法
extension CreateCollectionViewController: UIImagePickerControllerDelegate {
    @objc func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            collectionCoverBox.setBackgroundImage(selectedImage, for: .normal)
            dismiss(animated: true, completion: nil)
        }
    }
    
    /// 退出当前模态视图
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 点击注册按钮后触发注册和登录相关的方法
    @objc func clickedCreateCollectionButton() {
        guard let coverImage = collectionCoverBox.backgroundImage(for: .normal) else { return }
        guard let coverData = coverImage.pngData() else { return }
        let coverFile = LCFile(payload: .data(data: coverData))
        var coverURL = LCFile(url: "")
        
        let coverLoad = DispatchGroup()
        
        coverLoad.enter()
        _ = coverFile.save { result in
            switch result {
            case .success:
                if let value = coverFile.url?.value {
                    coverURL = LCFile(url: value)
                    print("文件保存完成。URL: \(value)")
                    coverLoad.leave()
                }
            case .failure(error: let error): errorLeanCloud(error, view: self.view)
            }
        }
        
        guard let titleText = titieInputBox.text else { return }
        guard let userObjectId = LCApplication.default.currentUser?.objectId?.stringValue else { return }
        
        coverLoad.notify(queue: .main) {
            do {
                // 构建对象
                let todo = LCObject(className: "Collection")
                
                // 为属性赋值
                try todo.set("title", value: titleText)
                try todo.set("cover", value: coverURL)
                try todo.set("authorObjectId", value: userObjectId)
                
                // 将对象保存到云端
                _ = todo.save { [self] result in
                    switch result {
                    case .success:
                        view.makeToast("合集 \(titleText) 创建成功", duration: 1.5, position: .top)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                            dismiss(animated: true, completion: nil)
                        }
                    case .failure(error: let error): errorLeanCloud(error, view: view)
                    }
                }
            } catch {
                self.view.makeToast("\(error)\n建议截图前往“软件设置 > 反馈问题 > 特殊错误”处反馈", duration: 5, position: .top)
            }
        }
    }
}

// ⌨️输入框键盘相关方法
extension CreateCollectionViewController: UITextFieldDelegate {
    /// 键盘弹出时调用
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        underlyView.contentInset = contentInsets
        underlyView.scrollIndicatorInsets = contentInsets
        var aRect = self.view.frame
        aRect.size.height -= keyboardFrame.size.height
    }
    
    /// 键盘隐藏时调用
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        underlyView.contentInset = contentInsets
        underlyView.scrollIndicatorInsets = contentInsets
    }
    
    /// 收起键盘的方法
    @objc func keyboardHide() {
        view.endEditing(true)
    }
    
    /// 回车自动切换输入框的方法
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == userNameInputBox {
//            passwordInputBox.becomeFirstResponder()
//        } else if textField == passwordInputBox {
//            emailInputBox.becomeFirstResponder()
//        } else if textField == emailInputBox {
//            phoneInputBox.becomeFirstResponder()
//        } else {
//            phoneInputBox.resignFirstResponder()
//        }
//        return true
//    }
}