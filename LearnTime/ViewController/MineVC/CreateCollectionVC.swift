import UIKit
import LeanCloud
import SnapKit

//import SwiftUI
//
//@available(iOS 13.0, *)
//struct Login_Preview: PreviewProvider {
//    static var previews: some View {
//        ViewControllerPreview {
//            UINavigationController(rootViewController: CreateCollectionViewController())
//        }
//    }
//}
//
//struct ViewControllerPreview: UIViewControllerRepresentable {
//
//    typealias UIViewControllerType = UIViewController
//
//    let viewControllerBuilder: () -> UIViewControllerType
//
//    init(_ viewControllerBuilder: @escaping () -> UIViewControllerType) {
//        self.viewControllerBuilder = viewControllerBuilder
//    }
//
//    @available(iOS 13.0.0, *)
//    func makeUIViewController(context: Context) -> UIViewController {
//        viewControllerBuilder()
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//    }
//}

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
    let titieInputBox = UICustomTextField()
    let partitionButton = UIButton()
    let tagButton = UIButton()
    /// 简介输入框
    let profileInputBox = UICustomTextView()
    
    let partitionGroup = DispatchGroup()
    
    var partitionName: String = "暂无"
    var partitionTag: String = ""
    var partitionTagArray: [String] = []
    
    var partitionArray: [LCObject] = []
    var tagObject: LCObject = LCObject()
    
    var partitionDict: [String: [String]] = [:]
}

// ♻️控制器的生命周期方法
extension CreateCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "创建合集", mode: .group)
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
        
        partitionGroup.enter()
        partitionInitialize()
        
        partitionGroup.notify(queue: .main) { [self] in
            // 导航栏：导航栏按钮
            moduleNav()
            snpTop = module0()
            // 模块1：输入合集标题
            snpTop = module1(snpTop)
            // 模块2：选择分区和类型
            snpTop = module2(snpTop)
            // 模块3：输入合集简介内容
            snpTop = module3(snpTop)
            //        // 模块4：输入手机号
            //        snpTop = module4(snpTop)
            //        // 模块5：注册并且登录按钮
            module4(snpTop)
        }
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
        keyboardHideButton.tintColor = JunColor.LearnTime1()
        navigationItem.rightBarButtonItem = keyboardHideButton
        
        /// 收起此界面的按钮
        let dismissVCButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(dismissVC))
        dismissVCButton.tintColor = JunColor.LearnTime1()
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
        titieInputBox.layer.borderColor = JunColor.LearnTime1().cgColor
        titieInputBox.backgroundColor = UIColor.white
        titieInputBox.layer.cornerRadius = 15
        titieInputBox.tintColor = UIColor.black.withAlphaComponent(0.6)
        titieInputBox.font = JunFont.title2()
        titieInputBox.textColor = UIColor.black.withAlphaComponent(0.6)
        titieInputBox.placeholder = "合集标题不可为空"
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
        let tipsLabel1 = UILabel().fontAdaptive("合集标题不可为空且不可全部由空格组成，可以包含汉字、字母、阿拉伯数字、部分符号。", font: JunFont.tips())
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
        partitionButton.layer.borderColor = JunColor.LearnTime1().cgColor
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
        let partitionQuery = LCQuery(className: "Partition")
        _ = partitionQuery.find { [self] result in
            switch result {
            case .success(objects: let item): partitionArray = item
            case .failure(error: let error): errorLeanCloud(error, view: view)
            }
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
        tagButton.layer.borderColor = JunColor.LearnTime1().cgColor
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
        let tipsLabel1 = UILabel().fontAdaptive("合集的分区和标签并不会影响合集内的文章的分区和标签。", font: JunFont.tips())
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
        let title = UIButton().moduleTitleMode("合集简介", mode: .basic)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
        
        // 配置用户名输入框
        profileInputBox.layer.borderWidth = 3
        profileInputBox.layer.borderColor = JunColor.LearnTime1().cgColor
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
    
    /// 创建模块4的方法
    func module4(_ snpTop: ConstraintRelatableTarget) {
        /// 注册并且登录的按钮
        let createButton = UIButton()
        createButton.backgroundColor = JunColor.LearnTime1()
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
            make.bottom.equalToSuperview().offset(-JunSpaced.screen())
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
    
    /// 初始化分区与标签相关信息
    func partitionInitialize() {
        let partitionQuery = LCQuery(className: "Partition")
        _ = partitionQuery.find { [self] result in
            switch result {
            case .success(objects: let partitionNameArray):
                let tagGroup = DispatchGroup()
                
                // 循环获取分区对应的标签数组并且添加到准备好的字典中
                for partitionName in partitionNameArray {
                    tagGroup.enter()
                    let tagQuery = LCQuery(className: "Partition")
                    tagQuery.whereKey("name", .equalTo(((partitionName.get("name") as! LCString).stringValue)!))
                    _ = tagQuery.find { [self] result in
                        switch result {
                        case .success(objects: let tagArray):
                            let element = (tagArray[0].get("tag") as! LCArray).arrayValue! as! [String]
                            partitionDict[(partitionName.get("name") as! LCString).stringValue!] = element
                            tagGroup.leave()
                        case .failure(error: let error): errorLeanCloud(error, view: view)
                        }
                    }
                }
                
                tagGroup.notify(queue: .main) {
                    self.partitionGroup.leave()
                }
            case .failure(error: let error): errorLeanCloud(error, view: view)
            }
        }
    }
    
    /// 退出当前模态视图
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 创建合集按钮关联的方法
    @objc func clickedCreateCollectionButton() {
        guard let coverImage = collectionCoverBox.backgroundImage(for: .normal) else { return }
        guard let coverData = coverImage.pngData() else { return }
        guard let titleText = titieInputBox.text else { return } // 获取输入框内的合集标题字符串
        guard let profileText = profileInputBox.text else { return } // 获取输入框内的合集简介字符串
        guard let userObjectId = LCApplication.default.currentUser?.objectId?.stringValue else { return } // 获取当前用户的ObjectID
        let coverFile = LCFile(payload: .data(data: coverData))
        
        if titleText == "" || partitionTag == "" || partitionTag == "请先选择分区" {
            self.view.makeToast("合集标题和分区标签不可为空", duration: 1.5, position: .top)
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
                
                if let value = coverFile.url?.value {
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
                    try myFile.set("profile", value: "合集<\(titleText)>的封面")
                    try myFile.set("authorObjectId", value: userObjectId)
                    _ = myFile.save { [self] result in
                        switch result {
                        case .success:
                            view.makeToast("合集 \(titleText) 创建成功", duration: 1.5, position: .top)
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
        
        // 将前置数据汇总创建合集
        coverLoad.notify(queue: .main) { [self] in
            do {
                let myCollection = LCObject(className: "Collection")
                try myCollection.set("title", value: titleText)
                try myCollection.set("cover", value: coverFile)
                try myCollection.set("tag", value: partitionTag)
                if profileText != "" { try myCollection.set("profile", value: profileText) }
                else { try myCollection.set("profile", value: "暂无简介") }
                try myCollection.set("authorObjectId", value: userObjectId)
                _ = myCollection.save { [self] result in
                    switch result {
                    case .success:
                        view.makeToast("合集 \(titleText) 创建成功", duration: 1.5, position: .top)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                            dismiss(animated: true, completion: nil)
                        }
                    case .failure(error: let error): errorLeanCloud(error, view: view)
                    }
                }
            } catch { self.view.makeToast("\(error)\n建议截图前往“软件设置 > 反馈问题 > 特殊错误”处反馈", duration: 5, position: .top) }
        }
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
        }
        else { partitionButton.addTarget(self, action: #selector(oldShowMenu), for: .touchUpInside) }
    }
    
    /// 标签菜单的创建方法
    func tagAddMenu() {
        if #available(iOS 14.0, *) {
            var actionArray: [UIAction] = []
            print("aaa")
            partitionTagArray = partitionDict[self.partitionName] ?? ["出现了一些问题"]
            for item in partitionTagArray {
                let action = UIAction(title: item, image: UIImage(systemName: "greetingcard"), identifier: nil, attributes: [], handler: { action in
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
    
    // 定义一个显示菜单的方法
    @objc func oldShowMenu(_ sender: UIButton) {
//        // 创建一个UIAlertController对象，设置样式为actionSheet
//        if sender.tag == 0 {
//            let alertController = UIAlertController(title: "选择合集的分区", message: nil, preferredStyle: .actionSheet)
//        }
//        // 创建两个UIAlertAction对象
//        for (index, item) in partitionArray.enumerated() {
//            let action1 = UIAlertAction(title: (item.get("name") as! LCString).stringValue, style: .default) { action in
//                print("You selected option 1")
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

    // 定义一个显示菜单的方法
    @objc func showMenu(_ sender: UIButton) {
        // 创建一个UIAlertController对象，设置样式为actionSheet
        print(partitionDict)
        if sender.tag == 0, #available(iOS 14.0, *) {
            var actionArray: [UIAction] = []
            for item in partitionDict {
                if item.key != "暂无" {
                    let action = UIAction(title: item.key, image: UIImage(systemName: "greetingcard"), identifier: nil, attributes: [], handler: { action in
                        self.partitionName = item.key
                    })
                    actionArray.append(action)
                }
            }
            let menu = UIMenu(title: "选择分区", children: actionArray)
            partitionButton.showsMenuAsPrimaryAction = true
            partitionButton.menu = menu
        } else if sender.tag == 1, #available(iOS 14.0, *) {
            var actionArray: [UIAction] = []
            partitionTagArray = partitionDict[self.partitionName] ?? ["出现了一些问题"]
            for item in partitionTagArray {
                let action = UIAction(title: item, image: UIImage(systemName: "greetingcard"), identifier: nil, attributes: [], handler: { action in
                })
                actionArray.append(action)
            }
            let menu = UIMenu(title: "选择标签", children: actionArray)
            tagButton.showsMenuAsPrimaryAction = true
            tagButton.menu = menu
        }
    }
}

// ⌨️输入框键盘相关方法
extension CreateCollectionViewController: UITextFieldDelegate, UITextViewDelegate {
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
