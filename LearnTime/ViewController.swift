import UIKit

extension UIViewController {
    func withTabBarItem(title: String, image: UIImage?, selectedImage: UIImage?) -> UIViewController {
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        self.tabBarItem = tabBarItem
        return self
    }
}

// 创建应用底部标签栏并且关联四个导航栏控制器
class ViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUserDefaults()
        
        let viewControllers = [
            UINavigationController(rootViewController: SuggestViewController().withTabBarItem(title: "推荐内容", image: UIImage(systemName: "book.pages"), selectedImage: UIImage(systemName: "book.pages.fill"))),
            UINavigationController(rootViewController: DiscussViewController().withTabBarItem(title: "发现更多", image: UIImage(systemName: "safari"), selectedImage: UIImage(systemName: "safari.fill"))),
            UINavigationController(rootViewController: MineViewController().withTabBarItem(title: "关于我的", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))),
            UINavigationController(rootViewController: SettingViewController().withTabBarItem(title: "软件设置", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill")))
        ]
        self.viewControllers = viewControllers
    }
    
}
