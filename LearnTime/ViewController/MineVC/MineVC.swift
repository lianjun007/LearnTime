// 关于我的界面
import UIKit
import LeanCloud
import SnapKit
import Toast
import UIView_Shimmer

//import SwiftUI
//
//@available(iOS 13.0, *)
//struct Login_Preview: PreviewProvider {
//    static var previews: some View {
//        ViewControllerPreview {
//            UINavigationController(rootViewController: MineViewController())
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


/// 界面的声明内容
class MineViewController: UIViewController {
    /// 底层的滚动视图，最基础的界面
    let underlyView = UIScrollView()
    /// 底层滚动视图的内容视图
    let containerView = UIView()
    
    ///
    var myCollection: [LCObject] = []
    ///
    var myCollectionBoxButtonArray: [UIButton] = []
    
    /// 自动布局顶部参考，用来流式创建控件时定位
    var snpTop: ConstraintRelatableTarget!
}

// ♻️控制器的生命周期方法
extension MineViewController {
    /// 初始化界面的枢纽
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "关于我的", mode: .basic)
        
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

        moduleRefresh()
        // 模块0：登录注册或用户信息模块
        snpTop = module0()
        // 模块1：我的合集模块
        snpTop = module1(snpTop)
        // 模块2：我的文章模块
        snpTop = module2(snpTop)
        // 模块3：我的文件模块
        module3(snpTop)
        
        if let sessionToken = LCApplication.default.currentUser?.sessionToken?.value {
            _ = LCUser.logIn(sessionToken: sessionToken) { (result) in
                if result.isSuccess {
                    // session token 有效
                } else {
                    self.view.makeToast("登录失效，请重新登录", duration: 1.5, position: .top)
                    LCUser.logOut()
                }
            }
        }
        
        // 账号登录状态修改时触发相关通知
        NotificationCenter.default.addObserver(self, selector: #selector(overloadViewDidLoad), name: accountStatusChangeNotification, object: nil)
    }
}

// 📦👷封装界面中各个模块创建的方法
extension MineViewController {
    func moduleRefresh () {
        // 将刷新控件添加到UIScrollView对象中
        underlyView.refreshControl = UIRefreshControl()
        underlyView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc func handleRefreshControl() {
        overloadViewDidLoad()
        // 更新内容...
        // 关闭刷新控件
        DispatchQueue.main.async {
            self.underlyView.refreshControl?.endRefreshing()
        }
    }

    /// 创建模块0的方法
    func module0() -> ConstraintRelatableTarget {
        /// 账号相关的设置控件（对应的字典）
        let control = UIView()
        containerView.addSubview(control)
        control.snp.makeConstraints { make in
            make.top.equalTo(JunSpaced.navigation())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(80)
        }
        
        module0ButtonBuild(control)
        
        return control.snp.bottom
    }

    /// 创建模块1的方法
    func module1(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        /// 模块标题
        let title = UIButton().moduleTitleMode("我的合集", mode: .arrow)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
//        title.addTarget(self, action: #selector(moduleTitle2Jumps), for: .touchUpInside)
        
        let collectionBox = UIScrollView()
        collectionBox.isPagingEnabled = true
        collectionBox.showsHorizontalScrollIndicator = false
        containerView.addSubview(collectionBox)
        collectionBox.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(180 + JunSpaced.control() * 2)
            make.bottom.equalToSuperview().offset(-1000)// ⚠️
        }
        
        let collectionBoxContentView = UIView()
        collectionBox.addSubview(collectionBoxContentView)
        collectionBoxContentView.snp.makeConstraints { make in
            make.edges.equalTo(collectionBox)
            make.height.equalTo(collectionBox)
        }
        
        let coverLoad = DispatchGroup()
        coverLoad.enter()
        guard let userObjectId = LCApplication.default.currentUser?.objectId?.stringValue else { return collectionBox.snp.bottom }
        let query = LCQuery(className: "Collection")
        query.whereKey("authorObjectId", .equalTo(userObjectId))
        _ = query.find { [self] result in
            switch result {
            case .success(objects: let item):
                myCollection = []
                myCollection = item
                coverLoad.leave()
            case .failure(error: let error): errorLeanCloud(error, view: view)
            }
        }
        
        myCollectionBoxButtonArray = []
        coverLoad.notify(queue: .main) { [self] in
            for index in 0 ..< myCollection.count {
                myCollectionBuild(index, superView: collectionBox, superViewContent: collectionBoxContentView)
            }
        }
        
        return collectionBox.snp.bottom
    }
    
    /// 创建模块2的方法
    func module2(_ snpTop: ConstraintRelatableTarget) -> ConstraintRelatableTarget  {
        /// 模块标题
        let title = UIButton().moduleTitleMode("我的文章", mode: .arrow)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
//        title.addTarget(self, action: #selector(moduleTitle2Jumps), for: .touchUpInside)
        
        let collectionBox = UIScrollView()
        collectionBox.isPagingEnabled = true
        collectionBox.showsHorizontalScrollIndicator = false
        containerView.addSubview(collectionBox)
        collectionBox.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(180 + JunSpaced.control() * 2)
        }
        
        let collectionBoxContentView = UIView()
        collectionBox.addSubview(collectionBoxContentView)
        collectionBoxContentView.snp.makeConstraints { make in
            make.edges.equalTo(collectionBox)
            make.height.equalTo(collectionBox)
        }
        
        let coverLoad = DispatchGroup()
        coverLoad.enter()
        guard let userObjectId = LCApplication.default.currentUser?.objectId?.stringValue else { return collectionBox.snp.bottom }
        let query = LCQuery(className: "Collection")
        query.whereKey("authorObjectId", .equalTo(userObjectId))
        _ = query.find { [self] result in
            switch result {
            case .success(objects: let item):
                myCollection = []
                myCollection = item
                coverLoad.leave()
            case .failure(error: let error): errorLeanCloud(error, view: view)
            }
        }
        
        myCollectionBoxButtonArray = []
        coverLoad.notify(queue: .main) { [self] in
            for index in 0 ..< myCollection.count {
                myCollectionBuild(index, superView: collectionBox, superViewContent: collectionBoxContentView)
            }
        }
        
        return collectionBox.snp.bottom
    }
    
    /// 创建模块3的方法
    func module3(_ snpTop: ConstraintRelatableTarget) {
        /// 模块标题
        let title = UIButton().moduleTitleMode("我的文件", mode: .arrow)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(JunSpaced.module())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
        }
//        title.addTarget(self, action: #selector(moduleTitle2Jumps), for: .touchUpInside)
        
        let collectionBox = UIScrollView()
        collectionBox.isPagingEnabled = true
        collectionBox.showsHorizontalScrollIndicator = false
        containerView.addSubview(collectionBox)
        collectionBox.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
            make.height.equalTo(180 + JunSpaced.control() * 2)
        }
        
        let collectionBoxContentView = UIView()
        collectionBox.addSubview(collectionBoxContentView)
        collectionBoxContentView.snp.makeConstraints { make in
            make.edges.equalTo(collectionBox)
            make.height.equalTo(collectionBox)
        }
        
        let coverLoad = DispatchGroup()
        coverLoad.enter()
        guard let userObjectId = LCApplication.default.currentUser?.objectId?.stringValue else { return }
        let query = LCQuery(className: "Collection")
        query.whereKey("authorObjectId", .equalTo(userObjectId))
        _ = query.find { [self] result in
            switch result {
            case .success(objects: let item):
                myCollection = []
                myCollection = item
                coverLoad.leave()
            case .failure(error: let error): errorLeanCloud(error, view: view)
            }
        }
        
        myCollectionBoxButtonArray = []
        coverLoad.notify(queue: .main) { [self] in
            for index in 0 ..< myCollection.count {
                myCollectionBuild(index, superView: collectionBox, superViewContent: collectionBoxContentView)
            }
        }
    }
}

// 📦🫳封装界面中交互触发的方法
extension MineViewController {
    /// 账户设置模块（模块0）相关的交互方法
    @objc func accountModuleCilcked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let VC = SignInViewController()
            let NavC = UINavigationController(rootViewController: VC)
            present(NavC, animated: true)
        case 1:
            let VC = SignUpViewController()
            let NavC = UINavigationController(rootViewController: VC)
            present(NavC, animated: true)
        case 3:
            LCUser.logOut()
            NotificationCenter.default.post(name: accountStatusChangeNotification, object: nil)
        default: break
        }
    }
    
    /// 跳转到用户详情页界面
    @objc func userNameTitleCilcked() {
        let VC = AccountViewController()
        let NavC = UINavigationController(rootViewController: VC)
        present(NavC, animated: true)
    }
    
    /// 重新加载viewDidLoad方法以刷新界面
    @objc func overloadViewDidLoad() {
        // 移除旧的底层视图
        for subview in containerView.subviews {
            subview.removeFromSuperview()
        }
        self.viewDidLoad()
    }
    
    /// 跳转到创建合集界面
    @objc func clickCreateCollection() {
        let VC = CreateCollectionViewController()
        let NavC = UINavigationController(rootViewController: VC)
        present(NavC, animated: true)
    }
}

// 📦🫳封装界面中自定义控件的方法
extension MineViewController {
    /// 👷创建模块0的自定义按钮的方法
    func module0ButtonBuild(_ superView: UIView) {
        // 判断当前设备上是否有已登录的账户
        if let user = LCApplication.default.currentUser {
            /// 显示当前账户用户名的标签
            let title = UIButton().moduleTitleMode("\(user.username!.stringValue!)", mode: .arrow)
            superView.addSubview(title)
            title.snp.makeConstraints { make in
                make.top.equalTo(0)
                make.height.equalTo(title)
                make.right.left.equalTo(0)
            }
            title.addTarget(self, action: #selector(userNameTitleCilcked), for: .touchUpInside)
            
            let createCollectionButton = UIButton()
            let createEssayButton = UIButton()
            
            createCollectionButton.backgroundColor = JunColor.learnTime1()
            createCollectionButton.layer.cornerRadius = 12
            createCollectionButton.setTitle("创建合集", for: .normal)
            createCollectionButton.titleLabel?.font = JunFont.title2()
            createCollectionButton.setTitleColor(UIColor.black, for: .normal)
            containerView.addSubview(createCollectionButton)
            createCollectionButton.snp.makeConstraints { make in
                make.top.equalTo(title.snp.bottom).offset(JunSpaced.control())
                make.left.equalTo(containerView.safeAreaLayoutGuide).offset(JunSpaced.screen())
                make.width.equalTo(containerView.safeAreaLayoutGuide).multipliedBy(0.5).offset(-JunSpaced.screen() - JunSpaced.control() / 2)
                make.height.equalTo(36)
            }
            createCollectionButton.addTarget(self, action: #selector(clickCreateCollection), for: .touchUpInside)
            
            createEssayButton.backgroundColor = JunColor.learnTime0()
            createEssayButton.layer.cornerRadius = 12
            createEssayButton.setTitle("创建文章", for: .normal)
            createEssayButton.titleLabel?.font = JunFont.title2()
            createEssayButton.setTitleColor(UIColor.black, for: .normal)
            containerView.addSubview(createEssayButton)
            createEssayButton.snp.makeConstraints { make in
                make.top.equalTo(createCollectionButton)
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-JunSpaced.screen())
                make.width.equalTo(containerView.safeAreaLayoutGuide).multipliedBy(0.5).offset(-JunSpaced.screen() - JunSpaced.control() / 2)
                make.height.equalTo(createCollectionButton)
            }
            
//            /// 登出当前账户的按钮
//            let signOutButton = UIButton()
//            signOutButton.backgroundColor = JunColor.learnTime0()
//            signOutButton.layer.cornerRadius = 10
//            signOutButton.tag = 3
//            signOutButton.setImage(UIImage(systemName: "person.badge.minus"), for: .normal)
//            signOutButton.tintColor = UIColor.black
//            signOutButton.setTitle("登出账户", for: .normal)
//            signOutButton.setTitleColor(UIColor.black, for: .normal)
//            superView.addSubview(signOutButton)
//            signOutButton.snp.makeConstraints { make in
//                make.top.equalTo(userNameLabel.snp.bottom).offset(JunSpaced.control())
//                make.right.left.bottom.equalTo(0)
//            }
//            signOutButton.addTarget(self, action: #selector(accountModuleCilcked), for: .touchUpInside)
        } else {
            /// 登录账户的按钮
            let signInButton = UIButton()
            signInButton.backgroundColor = JunColor.learnTime0()
            signInButton.layer.cornerRadius = 15
            signInButton.tag = 0
            signInButton.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
            signInButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold), forImageIn: .normal)
            signInButton.imageView?.contentMode = .scaleAspectFit
            signInButton.imageView?.snp.makeConstraints { make in
                make.top.equalTo(signInButton.titleLabel!)
                make.right.equalTo(signInButton.titleLabel!.snp.left).offset(-3)
                make.width.height.equalTo(25)
            }
            signInButton.tintColor = UIColor.black
            signInButton.setTitle("登录", for: .normal)
            signInButton.setTitleColor(UIColor.black, for: .normal)
            signInButton.setTitleColor(UIColor.black, for: .normal)
            signInButton.titleLabel?.font = JunFont.title2()
            superView.addSubview(signInButton)
            signInButton.snp.makeConstraints { make in
                make.top.left.equalToSuperview().offset(0)
                make.bottom.equalToSuperview().offset(0)
            }
            signInButton.addTarget(self, action: #selector(accountModuleCilcked), for: .touchUpInside)
            
            /// 游客登录的按钮
            let temporaryAccountButton = UIButton()
            temporaryAccountButton.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
            temporaryAccountButton.layer.cornerRadius = 15
            temporaryAccountButton.tag = 2
            temporaryAccountButton.setImage(UIImage(systemName: "person"), for: .normal)
            temporaryAccountButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold), forImageIn: .normal)
            temporaryAccountButton.imageView?.contentMode = .scaleAspectFit
            temporaryAccountButton.imageView?.snp.makeConstraints { make in
                make.top.equalTo(temporaryAccountButton.titleLabel!)
                make.right.equalTo(temporaryAccountButton.titleLabel!.snp.left).offset(-3)
                make.width.height.equalTo(25)
            }
            temporaryAccountButton.tintColor = UIColor.black
            temporaryAccountButton.setTitle("游客", for: .normal)
            temporaryAccountButton.setTitleColor(UIColor.black, for: .normal)
            temporaryAccountButton.titleLabel?.font = JunFont.title2()
            superView.addSubview(temporaryAccountButton)
            temporaryAccountButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(0)
                make.bottom.right.equalToSuperview().offset(0)
            }
            temporaryAccountButton.addTarget(self, action: #selector(accountModuleCilcked), for: .touchUpInside)
            
            /// 注册账户的按钮
            let signUpButton = UIButton()
            signUpButton.backgroundColor = JunColor.learnTime1()
            signUpButton.layer.cornerRadius = 15
            signUpButton.tag = 1
            signUpButton.setImage(UIImage(systemName: "person.badge.key"), for: .normal)
            signUpButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold), forImageIn: .normal)
            signUpButton.imageView?.contentMode = .scaleAspectFit
            signUpButton.imageView?.snp.makeConstraints { make in
                make.top.equalTo(signUpButton.titleLabel!)
                make.right.equalTo(signUpButton.titleLabel!.snp.left).offset(-3)
                make.width.height.equalTo(25)
            }
            signUpButton.tintColor = UIColor.black
            signUpButton.setTitle("注册", for: .normal)
            signUpButton.setTitleColor(UIColor.black, for: .normal)
            signUpButton.titleLabel?.font = JunFont.title2()
            superView.addSubview(signUpButton)
            signUpButton.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().offset(0)
                make.left.equalTo(signInButton.snp.right).offset(20)
                make.right.equalTo(temporaryAccountButton.snp.left).offset(-20)
                make.width.equalTo(signInButton)
                make.width.equalTo(temporaryAccountButton)
            }
            signUpButton.addTarget(self, action: #selector(accountModuleCilcked), for: .touchUpInside)
        }
    }
    
    func myCollectionBuild(_ index: Int, superView: UIView, superViewContent: UIView) {
        /// 装单个合集的框子
        let collectionBoxButton = UIButton()
        superViewContent.addSubview(collectionBoxButton)
        myCollectionBoxButtonArray.append(collectionBoxButton)
        collectionBoxButton.snp.makeConstraints { make in
            make.width.equalTo(superView).multipliedBy(0.5).offset(-JunSpaced.control() / 2)
            make.height.equalTo(60)
            if index > 2 {
                make.left.equalTo(myCollectionBoxButtonArray[index - 3].snp.right).offset(JunSpaced.control()) // ⚠️
                make.top.equalTo(myCollectionBoxButtonArray[index - 3].snp.top)
            } else {
                make.left.equalTo(0)
                make.top.equalTo(0).offset(index * (60 + Int(JunSpaced.control())))
            }
            if index == myCollection.count - 1 { make.right.equalToSuperview() }
        }
        
        let coverView = UIImageView()
        
        guard let coverURLString = (myCollection[index].get("cover") as! LCFile).thumbnailURL(.size(width: 180, height: 180))?.absoluteString else { return }
        
        guard let coverURL = URL(string: coverURLString) else { return }
        URLSession.shared.dataTask(with: URLRequest(url: coverURL)) { (data, response, error) in
            if let data = data {
                let coverImage = UIImage(data: data)
                DispatchQueue.main.async {
                    if let coverImage = coverImage {
                        coverView.image = coverImage
                    }
                }
            }
        }.resume()
        
        coverView.contentMode = .scaleAspectFill
        coverView.layer.cornerRadius = 5
        coverView.layer.masksToBounds = true
        collectionBoxButton.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.height.width.equalTo(60)
        }
        
        guard let collectionTitleText = myCollection[index].get("title")?.stringValue else { return }
        let collectionTitle = UILabel().fontAdaptive(collectionTitleText, font: JunFont.text(.bold))
        collectionBoxButton.addSubview(collectionTitle)
        collectionTitle.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.height.equalTo(collectionTitle)
            make.left.equalTo(coverView.snp.right).offset(JunSpaced.control())
            make.right.equalTo(0)
        }
    }
}
