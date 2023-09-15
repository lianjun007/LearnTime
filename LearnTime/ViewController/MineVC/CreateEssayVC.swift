import UIKit
import LeanCloud
import SnapKit

import SwiftUI

@available(iOS 13.0, *)
struct Login_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            UINavigationController(rootViewController: CreateEssayViewController())
        }
    }
}

struct ViewControllerPreview: UIViewControllerRepresentable {

    typealias UIViewControllerType = UIViewController

    let viewControllerBuilder: () -> UIViewControllerType

    init(_ viewControllerBuilder: @escaping () -> UIViewControllerType) {
        self.viewControllerBuilder = viewControllerBuilder
    }

    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController {
        viewControllerBuilder()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

/// 创建文章界面的声明内容
class CreateEssayViewController: UIViewController, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    /// 底层的滚动视图，最基础的界面
    let underlyView = UIScrollView()
    /// 底层滚动视图的内容视图
    let containerView = UIView()
    
    /// 自动布局顶部参考，用来流式创建控件时定位
    var snpTop: ConstraintRelatableTarget!
    
    let mainGroup = DispatchGroup()
    
    var bodyContent: String = "暂无内容"
    
    /// 用户封面图的载体
    var collectionCoverBox = UIButton()
    /// 文章标题输入框
    let titieInputBox = UICustomTextField()
    let partitionButton = UIButton()
    let tagButton = UIButton()
    let collectionButton = UIButton()
    let permissionButton = UIButton()
    /// 简介输入框
    let profileInputBox = UICustomTextView()
    
    let userObjectId = LCApplication.default.currentUser?.objectId?.stringValue
    
    var partitionName: String = "暂无"
    var partitionTag: String = ""
    var partitionTagArray: [String] = []
    var tagObject: LCObject = LCObject()
    var partitionDict: [String: [String]] = [:]
    
    var collectionObjectId: String = "0"
    var essayPermission: Bool = true
    var collectionArray: [LCObject] = []
}

// ♻️控制器的生命周期方法
extension CreateEssayViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "创建文章", mode: .group)
        // 设置输入框的代理（UITextFieldDelegate）
        titieInputBox.delegate = self
        profileInputBox.delegate = self
        
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
        
        mainGroup.enter()
        mainGroup.enter()
        dataInitialize()
        
        mainGroup.notify(queue: .main) { [self] in
            // 导航栏：导航栏按钮
            moduleNav()
            snpTop = module0()
            // 模块1：输入文章标题
            snpTop = module1(snpTop)
            // 模块2：选择分区和类型
            snpTop = module2(snpTop)
            // 模块3：选择合集与权限
            snpTop = module3(snpTop)
            // 模块4：选择正文内容
            snpTop = module4(snpTop)
            // 模块5：输入文章简介内容
            snpTop = module5(snpTop)
            module6(snpTop)
        }
        // 键盘显示和隐藏时触发相关通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// 📦分模块封装控件创建的方法
extension CreateEssayViewController {
    /// 创建导航栏按钮的方法
    func moduleNav() {
        /// 收起键盘的按钮
        let keyboardHideButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .plain, target: self, action: #selector(keyboardHide))
        keyboardHideButton.tintColor = JunColor.LearnTime0()
        navigationItem.rightBarButtonItem = keyboardHideButton
        
        /// 收起此界面的按钮
        let dismissVCButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(dismissVC))
        dismissVCButton.tintColor = JunColor.LearnTime0()
        navigationItem.leftBarButtonItem = dismissVCButton
    }
    
    /// 创建模块0的方法
    func module0() -> ConstraintRelatableTarget {
        /// 账户封面（头像）显示的容器
        collectionCoverBox.setBackgroundImage(UIImage(named: "LearnTime"), for: .normal)
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
        blurView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
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
        let title = UIButton().moduleTitleMode("文章标题", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        // 配置用户名输入框
        titieInputBox.layer.borderWidth = 3
        titieInputBox.layer.borderColor = JunColor.LearnTime0().cgColor
        titieInputBox.backgroundColor = UIColor.white
        titieInputBox.layer.cornerRadius = 15
        titieInputBox.tintColor = UIColor.black.withAlphaComponent(0.6)
        titieInputBox.font = JunFont.title2()
        titieInputBox.textColor = UIColor.black.withAlphaComponent(0.6)
        titieInputBox.placeholder = "文章标题不可为空"
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
            make.top.equalTo(titieInputBox.snp.bottom).offset(JunSpaced.control() - 0.7)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 用户名输入框下方的提示控件的提示内容1
        let tipsLabel1 = UILabel().fontAdaptive("文章标题不可为空且不可全部由空格组成，可以包含汉字、字母、阿拉伯数字、部分符号。", font: JunFont.tips())
            tipsLabel1.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel1)
            tipsLabel1.snp.makeConstraints { make in
                make.top.equalTo(titieInputBox.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(tipsIcon1.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        return tipsLabel1.snp.bottom
    }
    
    /// 创建模块2的方法
    func module2(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题
        let title = UIButton().moduleTitleMode("分区和标签", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        let label1 = UILabel().fontAdaptive("分区", font: JunFont.title2())
        let label2 = UILabel().fontAdaptive("标签", font: JunFont.title2())
        
        containerView.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.equalTo(40)
            make.width.equalTo(50)
        }
        
        // 分区选择按钮
        partitionButton.layer.borderWidth = 3
        partitionButton.layer.borderColor = JunColor.LearnTime0().cgColor
        partitionButton.backgroundColor = UIColor.white
        partitionButton.layer.cornerRadius = 13
        partitionButton.tintColor = UIColor.black.withAlphaComponent(0.6)
        partitionButton.setTitle("点击选择", for: .normal)
        partitionButton.setTitleColor(UIColor.black, for: .normal)
        containerView.addSubview(partitionButton)
        partitionButton.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(label1.snp.right)
            make.width.equalTo(containerView.safeAreaLayoutGuide).multipliedBy(0.5).offset(-JunSpaced.screen() - JunSpaced.control() / 2 - 50)
            make.height.equalTo(label1)
        }
        partitionAddMenu()
        
        containerView.addSubview(label2)
        label2.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(partitionButton.snp.right).offset(JunSpaced.control())
            make.height.equalTo(label1)
            make.width.equalTo(label1)
        }
        
        // 标签选择按钮
        tagButton.layer.borderWidth = 3
        tagButton.layer.borderColor = JunColor.LearnTime0().cgColor
        tagButton.backgroundColor = UIColor.white
        tagButton.layer.cornerRadius = 13
        tagButton.tintColor = UIColor.black.withAlphaComponent(0.6)
        tagButton.setTitle("请先选择分区", for: .normal)
        tagButton.setTitleColor(UIColor.black, for: .normal)
        containerView.addSubview(tagButton)
        tagButton.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(label2.snp.right)
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(label1)
        }
        tagAddMenu()
        
        /// 用户名输入框下方的提示控件的提示图标1
        let tipsIcon1 = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon1.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon1)
        tipsIcon1.snp.makeConstraints { make in
            make.top.equalTo(partitionButton.snp.bottom).offset(JunSpaced.control() - 0.7)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 用户名输入框下方的提示控件的提示内容1
        let tipsLabel1 = UILabel().fontAdaptive("文章的分区和标签并不会影响文章内的文章的分区和标签。", font: JunFont.tips())
            tipsLabel1.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel1)
            tipsLabel1.snp.makeConstraints { make in
                make.top.equalTo(partitionButton.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(tipsIcon1.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        return tipsLabel1.snp.bottom
    }
    
    /// 创建模块3的方法
    func module3(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题
        let title = UIButton().moduleTitleMode("合集和权限", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        let label1 = UILabel().fontAdaptive("合集", font: JunFont.title2())
        let label2 = UILabel().fontAdaptive("权限", font: JunFont.title2())
        
        containerView.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.equalTo(40)
            make.width.equalTo(50)
        }
        
        // 分区选择按钮
        collectionButton.layer.borderWidth = 3
        collectionButton.layer.borderColor = JunColor.LearnTime0().cgColor
        collectionButton.backgroundColor = UIColor.white
        collectionButton.layer.cornerRadius = 13
        collectionButton.tintColor = UIColor.black.withAlphaComponent(0.6)
        collectionButton.setTitle("不选择合集", for: .normal)
        collectionButton.setTitleColor(UIColor.black, for: .normal)
        containerView.addSubview(collectionButton)
        collectionButton.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(label1.snp.right)
            make.width.equalTo(containerView.safeAreaLayoutGuide).multipliedBy(0.5).offset(-JunSpaced.screen() - JunSpaced.control() / 2 - 50)
            make.height.equalTo(label1)
        }
        collectionAddMenu()
        
        containerView.addSubview(label2)
        label2.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(collectionButton.snp.right).offset(JunSpaced.control())
            make.height.equalTo(label1)
            make.width.equalTo(label1)
        }
        
        // 标签选择按钮
        permissionButton.layer.borderWidth = 3
        permissionButton.layer.borderColor = JunColor.LearnTime0().cgColor
        permissionButton.backgroundColor = UIColor.white
        permissionButton.layer.cornerRadius = 13
        permissionButton.tintColor = UIColor.black.withAlphaComponent(0.6)
        permissionButton.setTitle("请先选择合集", for: .normal)
        permissionButton.setTitleColor(UIColor.black, for: .normal)
        containerView.addSubview(permissionButton)
        permissionButton.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(label2.snp.right)
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(label1)
        }
        permissionAddMenu()
        
        /// 用户名输入框下方的提示控件的提示图标1
        let tipsIcon1 = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon1.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon1)
        tipsIcon1.snp.makeConstraints { make in
            make.top.equalTo(collectionButton.snp.bottom).offset(JunSpaced.control() - 0.7)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 用户名输入框下方的提示控件的提示内容1
        let tipsLabel1 = UILabel().fontAdaptive("文章的分区和标签并不会影响文章内的文章的分区和标签。", font: JunFont.tips())
            tipsLabel1.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel1)
            tipsLabel1.snp.makeConstraints { make in
                make.top.equalTo(collectionButton.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(tipsIcon1.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        return tipsLabel1.snp.bottom
    }
    
    /// 创建模块4的方法
    func module4(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题
        let title = UIButton().moduleTitleMode("文章正文", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        /// 创建合集的按钮
        let titleButton = UIButton()
        titleButton.setImage(UIImage(systemName: "doc.badge.plus"), for: .normal)
        titleButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold), forImageIn: .normal)
        titleButton.imageView?.contentMode = .scaleAspectFit
        titleButton.tintColor = UIColor.black
        titleButton.imageView?.snp.makeConstraints { make in
            make.top.right.equalTo(0)
        }
        containerView.addSubview(titleButton)
        titleButton.snp.makeConstraints { make in
            make.top.right.bottom.equalTo(title)
            make.width.equalTo(38)
        }
        titleButton.addTarget(self, action: #selector(addBody), for: .touchUpInside)
        
        /// 用户名输入框下方的提示控件的提示图标1
        let tipsIcon1 = UIImageView(image: UIImage(systemName: "info.circle"))
        tipsIcon1.tintColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(tipsIcon1)
        tipsIcon1.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control() - 0.7)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.height.width.equalTo(15)
        }
        
        /// 用户名输入框下方的提示控件的提示内容1
        let tipsLabel1 = UILabel().fontAdaptive("选择文章正文。", font: JunFont.tips())
            tipsLabel1.textColor = UIColor.black.withAlphaComponent(0.6)
            containerView.addSubview(tipsLabel1)
            tipsLabel1.snp.makeConstraints { make in
                make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(tipsIcon1.snp.right).offset(6)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        return tipsLabel1.snp.bottom
    }
    
    /// 创建模块5的方法
    func module5(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题
        let title = UIButton().moduleTitleMode("文章简介", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        // 配置用户名输入框
        profileInputBox.layer.borderWidth = 3
        profileInputBox.layer.borderColor = JunColor.LearnTime0().cgColor
        profileInputBox.backgroundColor = UIColor.white
        profileInputBox.layer.cornerRadius = 15
        profileInputBox.tintColor = UIColor.black.withAlphaComponent(0.6)
        profileInputBox.font = JunFont.title2()
        profileInputBox.textColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(profileInputBox)
        profileInputBox.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(44)
        }
        
        return profileInputBox.snp.bottom
    }
    
    /// 创建模块6的方法
    func module6(_ snpTop: ConstraintRelatableTarget) {
        /// 注册并且登录的按钮
        let createButton = UIButton()
        createButton.backgroundColor = JunColor.LearnTime0()
        createButton.layer.cornerRadius = 20
        createButton.setTitle("创建文章", for: .normal)
        createButton.titleLabel?.font = JunFont.title2()
        createButton.setTitleColor(UIColor.black, for: .normal)
        containerView.addSubview(createButton)
        createButton.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-JunSpaced.screen())
        }
        createButton.addTarget(self, action: #selector(clickedCreateEssayButton), for: .touchUpInside)
    }
}

// 🫳界面中其他交互触发的方法
extension CreateEssayViewController: UIImagePickerControllerDelegate {
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
    
    /// 初始化分区与标签相关信息
    func dataInitialize() {
        let partitionQuery = LCQuery(className: "Partition")
        _ = partitionQuery.find { [self] result in
            switch result {
            case .success(objects: let partitionNameArray):
                let partitionGroup = DispatchGroup()
                // 循环获取分区对应的标签数组并且添加到准备好的字典中
                for partitionName in partitionNameArray {
                    partitionGroup.enter()
                    let tagQuery = LCQuery(className: "Partition")
                    tagQuery.whereKey("name", .equalTo(((partitionName.get("name") as! LCString).stringValue)!))
                    _ = tagQuery.find { [self] result in
                        switch result {
                        case .success(objects: let tagArray):
                            let element = (tagArray[0].get("tag") as! LCArray).arrayValue! as! [String]
                            partitionDict[(partitionName.get("name") as! LCString).stringValue!] = element
                            partitionGroup.leave()
                        case .failure(error: let error): errorLeanCloud(error, view: view)
                        }
                    }
                }
                
                partitionGroup.notify(queue: .main) { self.mainGroup.leave() }
            case .failure(error: let error): errorLeanCloud(error, view: view)
            }
        }
        
        let collectionQuery = LCQuery(className: "Collection")
        collectionQuery.whereKey("authorObjectId", .equalTo(userObjectId ?? "error"))
        _ = collectionQuery.find { [self] result in
            switch result {
            case .success(objects: let item):
                let collectionGroup = DispatchGroup()
                collectionGroup.enter()
                for element in item { collectionArray.append(element) }
                collectionGroup.leave()
                
                collectionGroup.notify(queue: .main) { self.mainGroup.leave() }
            case .failure(error: let error): errorLeanCloud(error, view: view)
            }
        }
       
    }
    
    /// 退出当前模态视图
    @objc func dismissVC() { dismiss(animated: true, completion: nil) }
    
    /// 创建文章按钮关联的方法
    @objc func clickedCreateEssayButton() {
        guard let coverImage = collectionCoverBox.backgroundImage(for: .normal) else { return }
        guard let coverData = coverImage.pngData() else { return }
        guard let titleText = titieInputBox.text else { return } // 获取输入框内的文章标题字符串
        guard let profileText = profileInputBox.text else { return } // 获取输入框内的文章简介字符串
        let coverFile = LCFile(payload: .data(data: coverData))
        
        if titleText == "" || partitionTag == "" || partitionTag == "请先选择分区" {
            self.view.makeToast("文章标题和分区标签不可为空", duration: 1.5, position: .top)
            return
        }
        
        let coverLoad = DispatchGroup()
        
        coverLoad.enter()
        coverLoad.enter()
        
        var coverURL = ""
        var coverURL2 = ""
        
        // 保存图片到服务器
        _ = coverFile.save { result in
            switch result {
            case .success:
                
                if coverFile.url?.value != nil {
                    // 获取文件的 object id
                    if let value = coverFile.url?.value {
                        coverURL = value
                        coverURL2 = coverFile.thumbnailURL(.size(width: 180, height: 180))!.absoluteString
                        self.view.makeToast("图片上传成功，可以前往“关于我的 > 我的文件”查看", duration: 1.5, position: .top)
                    } else {
                        coverURL = "errorURL"
                        self.view.makeToast("图片上传成功但关联文件失败，建议截图前往“软件设置 > 反馈问题 > 特殊错误”处反馈", duration: 1.5, position: .top)
                    }
                    coverLoad.leave()
                }
                
                // 将封面图片URL关联到我的文件中
                do {
                    let myFile = LCObject(className: "FileIndex")
                    try myFile.set("contentOrURL", value: coverURL)
                    try myFile.set("imageURL", value: coverURL2)
                    try myFile.set("type", value: "image")
                    try myFile.set("profile", value: "文章<\(titleText)>的封面")
                    try myFile.set("authorObjectId", value: self.userObjectId)
                    _ = myFile.save { [self] result in
                        switch result {
                        case .success:
                            view.makeToast("文章 \(titleText) 创建成功", duration: 1.5, position: .top)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                                dismiss(animated: true, completion: nil)
                            }
                        case .failure(error: let error): errorLeanCloud(error, view: view)
                        }
                    }
                    coverLoad.leave()
                } catch { self.view.makeToast("\(error)\n建议截图前往“软件设置 > 反馈问题 > 特殊错误”处反馈", duration: 5, position: .top) }
            case .failure(error: let error): errorLeanCloud(error, view: self.view)
            }
        }
        
        // 将前置数据汇总创建文章
        coverLoad.notify(queue: .main) { [self] in
            do {
                let myEssay = LCObject(className: "Essay")
                try myEssay.set("title", value: titleText)
                try myEssay.set("cover", value: coverFile)
                try myEssay.set("tag", value: partitionTag)
                try myEssay.set("permission", value: essayPermission)
                try myEssay.set("body", value: bodyContent)
                if collectionObjectId == "0" { try myEssay.set("collection", value: "不属于任何合集") }
                else { try myEssay.set("collection", value: collectionObjectId) }
                if profileText != "" { try myEssay.set("profile", value: profileText) }
                else { try myEssay.set("profile", value: "暂无简介") }
                try myEssay.set("authorObjectId", value: userObjectId)
                _ = myEssay.save { [self] result in
                    switch result {
                    case .success:
                        view.makeToast("文章 \(titleText) 创建成功", duration: 1.5, position: .top)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                            dismiss(animated: true, completion: nil)
                        }
                    case .failure(error: let error): errorLeanCloud(error, view: view)
                    }
                }
            } catch { self.view.makeToast("\(error)\n建议截图前往“软件设置 > 反馈问题 > 特殊错误”处反馈", duration: 5, position: .top) }
        }
    }
    
    @objc func addBody() {
        // 创建一个文档选择器控制器
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["net.daringfireball.markdown"], in: .import)
        
        // 设置代理
        documentPicker.delegate = self
        
        // 显示文档选择器控制器
        present(documentPicker, animated: true, completion: nil)
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else { return }
        do {
            bodyContent = try String(contentsOf: fileURL)
        } catch { self.view.makeToast("\(error)\n建议截图前往“软件设置 > 反馈问题 > 特殊错误”处反馈", duration: 5, position: .top) }
    }

    /// 分区菜单的创建方法
    func partitionAddMenu() {
        if #available(iOS 14.0, *) {
            var actionArray: [UIAction] = []
            for item in partitionDict {
                if item.key != "暂无" {
                    let action = UIAction(title: item.key, image: UIImage(systemName: "greetingcard"), identifier: nil, attributes: [], handler: { action in
                        self.partitionName = item.key
                        self.partitionButton.setTitle(self.partitionName, for: .normal)
                        self.tagButton.setTitle("点击选择", for: .normal)
                        self.partitionTag = ""
                        self.tagAddMenu()
                    })
                    actionArray.append(action)
                }
            }
            let menu = UIMenu(title: "选择分区", children: actionArray)
            partitionButton.showsMenuAsPrimaryAction = true
            partitionButton.menu = menu
        } else { partitionButton.addTarget(self, action: #selector(oldShowMenu), for: .touchUpInside) }
    }
    
    /// 标签菜单的创建方法
    func tagAddMenu() {
        if #available(iOS 14.0, *) {
            var actionArray: [UIAction] = []
            partitionTagArray = partitionDict[self.partitionName] ?? ["出现了一些问题"]
            for item in partitionTagArray {
                let action = UIAction(title: item, image: UIImage(systemName: "greetingcard"), identifier: nil, attributes: (self.partitionName != "暂无") ? []: .destructive, handler: { action in
                    self.tagButton.setTitle(item, for: .normal)
                    self.partitionTag = item
                })
                actionArray.append(action)
            }
            let menu = UIMenu(title: "选择标签", children: actionArray)
            tagButton.showsMenuAsPrimaryAction = true
            tagButton.menu = menu
        } else { tagButton.addTarget(self, action: #selector(oldShowMenu), for: .touchUpInside) }
    }

    /// 合集菜单的创建方法
    func collectionAddMenu() {
        if #available(iOS 14.0, *) {
            var actionArray: [UIAction] = []
            for item in collectionArray {
                let action = UIAction(title: (item.get("title") as! LCString).stringValue!, image: UIImage(systemName: "greetingcard"), identifier: nil, attributes: [], handler: { action in
                    self.collectionObjectId = (item.get("objectId") as! LCString).stringValue!
                    self.collectionButton.setTitle((item.get("title") as! LCString).stringValue!, for: .normal)
                    self.permissionButton.setTitle("禁止外部访问", for: .normal)
                    self.essayPermission = false
                    self.permissionAddMenu()
                })
                actionArray.append(action)
            }
            let action = UIAction(title: "不选择合集", image: UIImage(systemName: "greetingcard"), identifier: nil, attributes: .destructive, handler: { action in
                self.collectionObjectId = "0"
                self.collectionButton.setTitle("不选择合集", for: .normal)
                self.permissionButton.setTitle("请先选择合集", for: .normal)
                self.essayPermission = false
                self.permissionAddMenu()
            })
            actionArray.append(action)
            let menu = UIMenu(title: "选择合集", children: actionArray)
            collectionButton.showsMenuAsPrimaryAction = true
            collectionButton.menu = menu }
        else { collectionButton.addTarget(self, action: #selector(oldShowMenu), for: .touchUpInside) }
    }
    
    /// 权限菜单的创建¸方法
    func permissionAddMenu() {
        if #available(iOS 14.0, *) {
            if collectionObjectId == "0" {
                let action1 = UIAction(title: "请先选择合集", image: UIImage(systemName: "greetingcard"), identifier: nil, attributes: .destructive, handler: { [self] action in
                    permissionButton.setTitle("请先选择合集", for: .normal)
                    essayPermission = true
                })
                let menu = UIMenu(title: "设置权限", children: [action1])
                permissionButton.showsMenuAsPrimaryAction = true
                permissionButton.menu = menu
            } else {
                let action1 = UIAction(title: "可以外部访问", image: UIImage(systemName: "greetingcard"), identifier: nil, attributes: [], handler: { [self] action in
                    permissionButton.setTitle("可以外部访问", for: .normal)
                    essayPermission = true
                })
                let action2 = UIAction(title: "禁止外部访问", image: UIImage(systemName: "greetingcard"), identifier: nil, attributes: [], handler: { [self] action in
                    permissionButton.setTitle("禁止外部访问", for: .normal)
                    essayPermission = false
                })
                let menu = UIMenu(title: "设置权限", children: [action1, action2])
                permissionButton.showsMenuAsPrimaryAction = true
                permissionButton.menu = menu
            }
        } else { permissionButton.addTarget(self, action: #selector(oldShowMenu), for: .touchUpInside) }
    }
    
    /// 定义一个显示菜单的方法
    @objc func oldShowMenu(_ sender: UIButton) {
//        // 创建一个UIAlertController对象，设置样式为actionSheet
//        if sender.tag == 0 {
//            let alertController = UIAlertController(title: "选择文章的分区", message: nil, preferredStyle: .actionSheet)
//        }
//        // 创建两个UIAlertAction对象
//        for (index, item) in partitionArray.enumerated() {
//            let action1 = UIAlertAction(title: (item.get("name") as! LCString).stringValue, style: .default) { action in
//            }
//        }
//
//        // 将两个UIAlertAction对象添加到UIAlertController对象中
//        alertController.addAction(action1)
//        alertController.addAction(action2)
//
//        // 显示UIAlertController对象
//        self.present(alertController, animated: true, completion: nil)
    }
}

// ⌨️输入框键盘相关方法
extension CreateEssayViewController: UITextFieldDelegate, UITextViewDelegate {
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
    
    // 当textView的文本改变时，调用这个方法
    func textViewDidChange(_ textView: UITextView) {
        // 计算textView根据文本内容需要的实际高度
        let size = CGSize(width: profileInputBox.frame.width, height: .infinity)
        let actualHeight = profileInputBox.sizeThatFits(size).height
        
        // 更新textView的高度约束
        profileInputBox.snp.updateConstraints { make in
            make.height.equalTo(actualHeight)
        }
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
