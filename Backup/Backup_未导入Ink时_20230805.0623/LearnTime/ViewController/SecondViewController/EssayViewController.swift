import UIKit

class EssayViewController: UIViewController {
    
    var tag: String?
    var a = ""
    var underlyView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "文章加载中", mode: .basic)
        
        // 创建URL对象
        guard let url = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/Essay/\(tag!)/body") else { return }
            
            // 创建URL请求
            let request = URLRequest(url: url)
            
            // 创建URLSession对象
            let session = URLSession.shared
            
            // 发送网络请求
            session.dataTask(with: request) { [self] (data, response, error) in
                if let data = data {
                    // 将网络请求得到的数据转换为字符串
                    
                    // 在主线程更新UI
                    DispatchQueue.main.async { [self] in
                        // 将字符串添加到UILabel中
                        // ...
                        
                        a = (String(data: data, encoding: .utf8) ?? "")
                        if a == "The content may contain violation information" {
                            a = """
此文章内容可能有违反Gitee平台规范的违规信息，请反馈到邮箱“lianjun.new@outlook.com“
如果你想坚持访问此文章，可以切换到Github平台的数据源（如果发现文章确实有违规信息，请联系我们。如果此数据源速度过慢或者无法访问请使用魔法🪄）
"""
                        }
                        underlyView = essayInterfaceBuild(a, self)
                    }
                }
            }.resume()
          
        
        // 在需要响应主题切换的地方添加观察者
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: changeThemeNotification, object: nil)
        
//        let fileURL = Bundle.main.path(forResource: "File", ofType: "")
//        let content = try! String(contentsOfFile: fileURL!, encoding: .utf8)
       
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // 记录当前滚动视图的偏移量
        var offset: CGPoint?
        for subview in view.subviews {
            if let scrollView = subview as? UIScrollView {
                offset = scrollView.contentOffset
                break
            }
        }
        
        // 屏幕旋转中触发的方法
        coordinator.animate { [self] _ in // 先进行一遍重新绘制充当过渡动画
            transitionAnimate(offset ?? CGPoint(x: 0, y: 0))
        } completion: { [self] _ in
            transitionAnimate(offset ?? CGPoint(x: 0, y: 0))
        }
    }
    
    func transitionAnimate(_ offset: CGPoint) {
        // 移除旧的滚动视图
        for subview in self.view.subviews {
            if subview is UIScrollView {
                subview.removeFromSuperview()
            }
        }
        
        // 重新构建界面
//        let fileURL = Bundle.main.path(forResource: "File", ofType: "")
//        let content = try! String(contentsOfFile: fileURL!, encoding: .utf8)
//        let scrollView = essayInterfaceBuild(content, self)
        self.viewDidLoad()

        // 将新的滚动视图的偏移量设置为之前记录的值
        var newOffset = offset
        if offset.y < -44 {
            newOffset.y = -(self.navigationController?.navigationBar.frame.height)!
        } else if offset.y == -44 {
            newOffset.y = -((self.navigationController?.navigationBar.frame.height)! + Screen.safeAreaInsets().top)
        }
        underlyView.setContentOffset(newOffset, animated: false)
    }

    // 实现观察者方法
    @objc func themeDidChange() {
        // 更新主题相关的设置

        // 记录当前滚动视图的偏移量
        var offset: CGPoint?
        for subview in view.subviews {
            if let scrollView = subview as? UIScrollView {
                offset = scrollView.contentOffset
                break
            }
        }

        // 移除旧的滚动视图
        for subview in view.subviews {
            if subview is UIScrollView {
                subview.removeFromSuperview()
            }
        }

        // 重新构建界面
//        let fileURL = Bundle.main.path(forResource: "File", ofType: "")
//        let content = try! String(contentsOfFile: fileURL!, encoding: .utf8)
//        let scrollView = essayInterfaceBuild(content, self)
        self.viewDidLoad()
        // 将新的滚动视图的偏移量设置为之前记录的值
        if let offset = offset {
            underlyView.setContentOffset(offset, animated: false)
        }
    }
}

