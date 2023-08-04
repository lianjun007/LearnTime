import UIKit

class SuggestViewController: UIViewController {
    
    // 发送精选课程的随机数据（废弃⚠️）
    var featuredCollectionsRandomDataArray = arrayRandom(number: 7, array: featuredCollectionsDataArray) as! Array<Dictionary<String, String>>
    
    var info: [[String: String]] = [[:]]
    var cover = [UIImage()]
    var cellViewArray: Array<UIButton> = []
    var titleArray: Array<UILabel> = []
    var textArray: Array<UILabel> = []
    
    /// 底层的滚动视图，最基础的界面
    let underlyView = UIScrollView()
    
    /// Y轴坐标原点，用来流式创建控件时定位
    var originY = CGFloat(0)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "推荐内容", mode: .basic)
        
        originY = 0
        
        /// 底层的滚动视图，最基础的界面
        underlyView.frame = UIScreen.main.bounds
        view.addSubview(underlyView)
        
        fetchData()
        
        // 模块1：精选合集
        originY = module1Build(underlyView)
        // 模块2：精选文章
        originY = module2Build(underlyView, originY: originY)
        
        // 配置底层视图的内容尺寸
        underlyView.contentSize = CGSize(width: Screen.width(), height: originY + Spaced.module())
    }
    
    
}

// 📦👷封装“推荐内容”界面中各个模块创建的方法
extension SuggestViewController {
    /// 👷创建模块1的方法
    func module1Build(_ superView: UIView) -> CGFloat {
        /// 模块标题：精选合集
        let title = UIButton().moduleTitleMode("精选合集", originY: Spaced.navigation(), mode: .arrow)
        underlyView.addSubview(title)
        // 关联跳转方法
        title.addTarget(self, action: #selector(clickModuleTitleControl), for: .touchUpInside)
        
        // 设置第一个模块的横向滚动视图，用来承载第一个模块“精选合集”（待修改⚠️）
        let moduleView = UIScrollView(frame: CGRect(x: 0, y: title.frame.maxY + Spaced.control(), width: Screen.width(), height: largeControlSize.height))
        moduleView.contentSize = CGSize(width: largeControlSize.width * 7 + Spaced.control() * 6 + Spaced.screenAuto() * 2, height: largeControlSize.height)
        moduleView.showsHorizontalScrollIndicator = false
        moduleView.clipsToBounds = false
        underlyView.addSubview(moduleView)
        // 创建7个精选合集框
        for i in 0 ... 6 {
            // 配置参数
            let moduleControlOrigin = CGPoint(x: Spaced.screen() + CGFloat(i) * (largeControlSize.width + Spaced.control()), y: 0)
            let featuredCourseBox = largeControlBuild(origin: moduleControlOrigin, imageName: featuredCollectionsRandomDataArray[i]["imageName"]!, title: featuredCollectionsRandomDataArray[i]["title"]!, title2: featuredCollectionsRandomDataArray[i]["author"]!)
            featuredCourseBox.tag = i
            featuredCourseBox.addTarget(self, action: #selector(clickCollectionControl), for: .touchUpInside)
            moduleView.addSubview(featuredCourseBox)
            let interaction = UIContextMenuInteraction(delegate: self)
            featuredCourseBox.addInteraction(interaction)
        }
        
        return moduleView.frame.maxY
    }
    
    /// 👷创建模块2的方法
    func module2Build(_ superView: UIView, originY: CGFloat) -> CGFloat {
        // 初始化
        cellViewArray = []
        textArray = []
        titleArray = []
        /// 模块标题：精选文章
        let title = UIButton().moduleTitleMode("精选文章", originY: originY + Spaced.module(), mode: .arrow)
        underlyView.addSubview(title)
        // 关联跳转方法
        title.addTarget(self, action: #selector(clickModuleTitleControl), for: .touchUpInside)
        
        
        for i in 0 ... 6 {
            var direction = Bool()
            if i == 2 || i == 3 || i == 4 {
                direction = false
            } else {
                direction = true
            }
            
            
            let returnArray = ShowcaseControl.rowBuild(origin: CGPoint(x: Spaced.screenAuto(), y: title.frame.maxY + Spaced.control() + CGFloat(i) * (Spaced.control() + 90)),
                                                    image: UIImage(named: "loading")!,
                                                    title: "数据加载中...",
                                                    text: "...",
                                                    direction: direction)
            
            let cellView = returnArray[0] as! UIButton
            
            cellView.addTarget(self, action: #selector(clickEssayControl), for: .touchUpInside)
            cellViewArray.append(cellView)
            titleArray.append(returnArray[1] as! UILabel)
            textArray.append(returnArray[2] as! UILabel)
            underlyView.addSubview(cellView)

            cellView.addInteraction(UIContextMenuInteraction(delegate: self))
        }
        
        return cellViewArray[6].frame.maxY
    }
}

// 📦🌐封装“推荐内容”界面中网络交互与数据处理的方法
extension SuggestViewController {
    /// 取随机数组
    func randomElements(from array: inout [[Int]], count: Int) -> [[Int]] {
        guard count <= array.count else {
            return []
        }
          
        let shuffledArray = Array(array.shuffled()) // 将数组随机打乱
        return Array(shuffledArray[..<shuffledArray.count].suffix(count)) // 返回前 count 个元素
    }
    
    func fetchData() {
        // 发送网络请求
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://gitee.com/lianjun007/learntime/raw/main/Content/List/story.plist")!)) { (data, response, error) in
            if let data = data {
                // 将网络请求得到的数据解析为字典对象
                do {
                    let decoder = PropertyListDecoder()
                    var result = try decoder.decode(Array<Array<Int>>.self, from: data)
                      
                    // 在主线程更新UI
                    DispatchQueue.main.async { [self] in
                        let randomNumbers = self.randomElements(from: &result, count: 7) // 随机取 7 个元素
                        var newArray: Array<Int> = []
                        for i in 0 ... 6 {
                            newArray.append(randomNumbers[i][0])
                        }
                        for (index, item) in newArray.enumerated() {
                            // 请求info
                            // 创建URL对象
                            guard let infoURL = URL(string: "https://gitee.com/lianjun007/learntime/raw/main/Content/Essay/\(item)/info.plist") else { return }
                            // 创建URL请求
                            let request0 = URLRequest(url: infoURL)
                            // 发送网络请求
                            URLSession.shared.dataTask(with: request0) { [self] (data0, response0, error0) in
                                if let data0 = data0 {
                                    // 处理网络请求得到的数据
                                    do {
                                        let dict = try PropertyListDecoder().decode([String: String].self, from: data0)
                                        info.append(dict)
                                        
                                        DispatchQueue.main.async { [self] in
                                            print("aaa")
                                            titleArray[index].text = dict["title"]!
                                            textArray[index].text = dict["author"]!
                                        }
                                    } catch {
                                        print(error0!)
                                    }
                                }
                            }.resume() // 发送网络请求
                            guard let coverURL = URL(string: "https://gitee.com/lianjun007/learntime/raw/main/Content/Essay/\(item)/cover.png") else { return }
                            // 创建URL请求
                            let request1 = URLRequest(url: coverURL)
                            // 发送网络请求
                            URLSession.shared.dataTask(with: request1) { [self] (data1, response1, error1) in
                                if let data1 = data1 {
                                    // 处理网络请求得到的数据
                                    let coverImage = UIImage(data: data1)
                                    cover.append(coverImage ?? UIImage(named: "loading")!)
                                    
                                    DispatchQueue.main.async { [self] in
                                        var direction = Bool()
                                        if index == 2 || index == 3 || index == 4 {
                                            direction = false
                                        } else {
                                            direction = true
                                        }
                                        
                                        cellViewArray[index].setImage(ShowcaseControl.spliceImage(coverImage ?? UIImage(named: "loading")!, direction: direction), for: .normal)
                                        cellViewArray[index].tag = item
                                    }
                                }
                            }.resume() // 发送网络请求
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume() // 发送网络请求
    }
}

// 📦➡️封装“推荐内容”界面中跳转界面的方法
extension SuggestViewController {
    ///
    @objc func clickEssayControl(_ sender: UIButton) {
        let VC = EssayViewController()
        VC.tag = "\(sender.tag)"
        self.navigationController?.pushViewController(VC, animated: true)
    }
    ///
    @objc func clickCollectionControl(_ sender: UIButton) {
        let VC = CourseViewController()
        VC.tag = "\(sender.tag)"
        self.navigationController?.pushViewController(VC, animated: true)
    }
    ///
    @objc func clickModuleTitleControl(_ sender: UIButton) {
        let VC = SelectedCollectionViewController()
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

// 📦🔄封装“推荐内容”界面中刷新重载功能（横竖屏和主题色切换）
extension SuggestViewController {
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
        for subview in self.underlyView.subviews {
            subview.removeFromSuperview()
        }
        
        // 重新构建界面
        viewDidLoad()

        // 将新的滚动视图的偏移量设置为之前记录的值
        var newOffset = offset
        if offset.y < -44 {
            newOffset.y = -(self.navigationController?.navigationBar.frame.height)!
        } else if offset.y == -44 {
            newOffset.y = -((self.navigationController?.navigationBar.frame.height)! + Screen.safeAreaInsets().top)
        }
        self.underlyView.setContentOffset(newOffset, animated: false)
    }
}

// 📦📒封装“推荐内容”界面中长按菜单内容的扩展
extension SuggestViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        var identifier = Int()
        if let button = interaction.view as? UIButton {
            identifier = button.tag
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: { [self] in
            
            let previewControllerInstance = UIViewController()
            if identifier < 7 {
                let image = UIImageView(frame: CGRect(x: Spaced.screen(), y: Spaced.screen(), width: previewControllerInstance.view.bounds.width - Spaced.screen() * 2, height: previewControllerInstance.view.bounds.width - Spaced.screen() * 2))
                image.layer.cornerRadius = 10
                image.clipsToBounds = true
                image.image = UIImage(named: featuredCollectionsRandomDataArray[identifier]["imageName"]!)
                previewControllerInstance.view.addSubview(image)
                
                // 设置精选课程的标题
                let courseLabel = UILabel(frame: CGRect(x: Spaced.screen(), y: image.frame.maxY + Spaced.screen(), width: 0, height: 0))
                courseLabel.text = featuredCollectionsRandomDataArray[identifier]["title"]
                courseLabel.font = Font.title1()
                courseLabel.sizeToFit()
                courseLabel.isUserInteractionEnabled = false
                previewControllerInstance.view.addSubview(courseLabel)
                
                // 设置精选课程的作者名
                let courseLabel2 = UILabel(frame: CGRect(x: Spaced.screen(), y: courseLabel.frame.maxY + Spaced.control(), width: 0, height: 0))
                courseLabel2.text = featuredCollectionsRandomDataArray[identifier]["author"]
                courseLabel2.font = Font.title2()
                courseLabel2.sizeToFit()
                courseLabel2.isUserInteractionEnabled = false
                previewControllerInstance.view.addSubview(courseLabel2)
                
                previewControllerInstance.preferredContentSize = CGSize(width: previewControllerInstance.view.bounds.width, height: courseLabel2.frame.maxY + Spaced.screen())
            } else {
                let image = UIImageView(frame: CGRect(x: Spaced.screen(), y: Spaced.screen(), width: previewControllerInstance.view.bounds.width - Spaced.screen() * 2, height: previewControllerInstance.view.bounds.width - Spaced.screen() * 2))
                image.layer.cornerRadius = 10
                image.clipsToBounds = true
                image.image = UIImage(named: featuredCollectionsRandomDataArray[identifier - 7]["imageName"]!)
                previewControllerInstance.view.addSubview(image)
                
                // 设置精选课程的标题
                let courseLabel = UILabel(frame: CGRect(x: Spaced.screen(), y: image.frame.maxY + Spaced.screen(), width: 0, height: 0))
                courseLabel.text = featuredCollectionsRandomDataArray[identifier - 7]["title"]
                courseLabel.font = Font.title1()
                courseLabel.sizeToFit()
                courseLabel.isUserInteractionEnabled = false
                previewControllerInstance.view.addSubview(courseLabel)
                
                // 设置精选课程的作者名
                let courseLabel2 = UILabel(frame: CGRect(x: Spaced.screen(), y: courseLabel.frame.maxY + Spaced.control(), width: 0, height: 0))
                courseLabel2.text = featuredCollectionsRandomDataArray[identifier - 7]["author"]
                courseLabel2.font = Font.title2()
                courseLabel2.sizeToFit()
                courseLabel2.isUserInteractionEnabled = false
                previewControllerInstance.view.addSubview(courseLabel2)
                
                previewControllerInstance.preferredContentSize = CGSize(width: previewControllerInstance.view.bounds.width, height: courseLabel2.frame.maxY + Spaced.screenAuto())
            }
            
            return previewControllerInstance
        }) { suggestedActions in
            let action2 = UIAction(title: "收藏至收藏夹", image: UIImage(systemName: "star")) { action in
            }
            let action3 = UIAction(title: "分享给朋友", image: UIImage(systemName: "square.and.arrow.up")) { action in
            }
            let menu1 = UIMenu(title: "",options: .displayInline, children: [action2, action3])
            let action4 = UIAction(title: "点赞课程", image: UIImage(systemName: "hand.thumbsup")) { action in
            }
            let action5 = UIAction(title: "打赏作者", image: UIImage(systemName: "dollarsign.circle")) { action in
            }
            let action6 = UIAction(title: "减少推荐", image: UIImage(systemName: "hand.thumbsdown")) { action in
            }
            let menu2 = UIMenu(title: "",options: .displayInline, children: [action4, action5, action6])
            let action7 = UIAction(title: "反馈问题", image: UIImage(systemName: "quote.bubble.rtl")) { action in
            }
            let action8 = UIAction(title: "举报不良信息", image: UIImage(systemName: "exclamationmark.bubble"), attributes: .destructive) { action in
            }
            let menu3 = UIMenu(title: "",options: .displayInline, children: [action7, action8])
            return UIMenu(title: "", children: [menu1, menu2, menu3])
        }
    }
}




//            // 根据字符串长度赋予不同行数,最多为两行
//            if isTruncated(essayLabel) {
//                essayLabel.numberOfLines += 1
//            }
//            essayLabel.sizeToFit()
//            essayLabel.frame.size.width = blurView.frame.width - Spaced.control() * 2
//            essayLabel.isUserInteractionEnabled = false
//            cellView.addSubview(essayLabel)
//
//            // 根据字符串行数判断动态坐标
//            if essayLabel.numberOfLines == 1 {
//                essayLabel.frame.origin.y = (blurView.frame.height - essayLabel.frame.height * 2 - essayLabel2.frame.height - Spaced.control()) / 2
//                essayLabel2.frame.origin = CGPoint(x: blurView.frame.origin.x + Spaced.control(), y: (blurView.frame.height - essayLabel.frame.height * 2 - essayLabel2.frame.height - Spaced.control()) / 2 + essayLabel.frame.height * 2 + Spaced.control())
//            } else {
//                essayLabel.frame.origin.y = (blurView.frame.height - essayLabel.frame.height - essayLabel2.frame.height - Spaced.control()) / 2
//                essayLabel2.frame.origin = CGPoint(x: blurView.frame.origin.x + Spaced.control(), y: (blurView.frame.height - essayLabel.frame.height - essayLabel2.frame.height - Spaced.control()) / 2 + essayLabel.frame.height + Spaced.control())
//            }
//
