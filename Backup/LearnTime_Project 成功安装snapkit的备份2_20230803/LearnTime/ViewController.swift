import UIKit

// 拓展UIViewController方法以方便创建导航栏对应的UITabBarItem
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
            UINavigationController(rootViewController: CollectionViewController().withTabBarItem(title: "用户与收藏", image: UIImage(systemName: "star.square.on.square"), selectedImage: UIImage(systemName: "star.square.on.square.fill"))),
            UINavigationController(rootViewController: SearchViewController().withTabBarItem(title: "搜索和设置", image: UIImage(systemName: "rectangle.and.hand.point.up.left"), selectedImage: UIImage(systemName: "rectangle.and.hand.point.up.left.fill")))
        ]
        self.viewControllers = viewControllers
    }
    
}
