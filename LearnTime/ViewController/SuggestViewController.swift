
import UIKit
import SnapKit

class SuggestViewController: UIViewController {
    // 发送精选课程的随机数据（废弃⚠️）
    var featuredCollectionsRandomDataArray = arrayRandom(number: 7, array: featuredCollectionsDataArray) as! Array<Dictionary<String, String>>
    
    //
    var essayRowArray: Array<UIButton> = []
    var essayRowtitleArray: Array<UILabel> = []
    var essayRowtextArray: Array<UILabel> = []
    var essayRowcoverArray: Array<UIImageView> = []
    var essayRowbackgroundArray: Array<UIImageView> = []
    
    var collectionBoxArray: Array<UIButton> = []
    var collectionBoxtitleArray: Array<UILabel> = []
    var collectionBoxtextArray: Array<UILabel> = []
    var collectionBoxcoverArray: Array<UIImageView> = []
    var collectionBoxbackgroundArray: Array<UIImageView> = []
    
    /// 底层的滚动视图，最基础的界面
    let underlyView = UIScrollView()
    let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "推荐内容", mode: .basic)
        
        /// Y轴坐标原点，用来流式创建控件时定位
        var snpTop: ConstraintRelatableTarget!
        /// 底层的滚动视图，最基础的界面
        view.addSubview(underlyView)
        underlyView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        underlyView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(underlyView)
            make.width.equalTo(underlyView)
        }
        
        fetchEssayData()
        fetchCollectionData()
        
        // 模块1：搜索相关的筛选设置
        snpTop = module1()
        // 模块2：搜索相关的筛选设置
        module2(snpTop)
    }
}

// 📦👷封装“推荐内容”界面中各个模块创建的方法
extension SuggestViewController {
    /// 👷创建模块1的方法
    func module1() -> ConstraintRelatableTarget {
        /// 模块标题：精选合集
        let title = UIButton().moduleTitleMode("精选合集", mode: .arrow)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(Spaced.navigation())
            make.height.equalTo(title)
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
        }
        // 关联跳转方法
        title.addTarget(self, action: #selector(clickModuleTitleControl), for: .touchUpInside)
        
        // 设置第一个模块的横向滚动视图，用来承载第一个模块“精选合集”（待修改⚠️）
        let moduleView = UIScrollView()
        moduleView.showsHorizontalScrollIndicator = false
        moduleView.clipsToBounds = false
        containerView.addSubview(moduleView)
        moduleView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(Spaced.control())
            make.left.right.equalTo(0)
            make.height.equalTo(360)
        }
        let moduleContainerView = UIView()
        moduleView.addSubview(moduleContainerView)
        moduleContainerView.snp.makeConstraints { make in
            make.edges.equalTo(moduleView)
            make.height.equalTo(moduleView)
        }
        moduleView.contentSize = CGSize(width: (360 + Spaced.control()) * 7, height: 360)
        
        // 创建7个精选合集框
        for i in 0 ... 6 {
            // 配置参数
            let returnArray = ShowcaseControl.boxBuild(image: UIImage(named: "loading")!,
                                                       title: "数据加载中...",
                                                       text: "...")
            
            
            let collectionBox = returnArray[0] as! UIButton
            moduleContainerView.addSubview(collectionBox)
            collectionBox.snp.makeConstraints { make in
                make.height.equalTo(360)
                make.top.equalTo(moduleContainerView)
                //                    .offset(Spaced.control() + CGFloat(i) * (Spaced.control() + 90))
                make.left.equalTo(0).offset(Spaced.screen() + CGFloat(i) * (Spaced.control() + 270))
                make.width.equalTo(270)
                if i == 6 {
                    make.right.equalToSuperview().offset(-Spaced.screen())
                }
            }
            
            collectionBox.addTarget(self, action: #selector(clickCollectionControl), for: .touchUpInside)
            let interaction = UIContextMenuInteraction(delegate: self)
            collectionBoxArray.append(collectionBox)
            collectionBoxtitleArray.append(returnArray[1] as! UILabel)
            collectionBoxtextArray.append(returnArray[2] as! UILabel)
            collectionBoxcoverArray.append(returnArray[3] as! UIImageView)
            collectionBoxbackgroundArray.append(returnArray[4] as! UIImageView)
            
            collectionBox.addInteraction(interaction)
        }
        
        return moduleView.snp.bottom
    }
    
    /// 👷创建模块2的方法
    func module2(_ snpTop: ConstraintRelatableTarget) {
        // 初始化
        essayRowArray = []
        essayRowtextArray = []
        essayRowtitleArray = []
        essayRowcoverArray = []
        essayRowbackgroundArray = []
        /// 模块标题：精选文章
        let title = UIButton().moduleTitleMode("精选文章", mode: .arrow)
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(snpTop).offset(Spaced.module())
            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
        }
        // 关联跳转方法
        title.addTarget(self, action: #selector(clickModuleTitleControl), for: .touchUpInside)
        
        for i in 0 ... 6 {
            var direction = Bool()
            if i == 2 || i == 3 || i == 4 {
                direction = false
            } else {
                direction = true
            }
            
            
            let returnArray = ShowcaseControl.rowBuild(image: UIImage(named: "loading")!,
                                                       title: "数据加载中...",
                                                       text: "...",
                                                       direction: direction)
            
            let essayRowView = returnArray[0] as! UIButton
            containerView.addSubview(essayRowView)
            essayRowView.snp.makeConstraints { make in
                make.height.equalTo(90)
                make.top.equalTo(title.snp.bottom).offset(Spaced.control() + CGFloat(i) * (Spaced.control() + 90))
                make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
                make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
                if i == 6 {
                    make.bottom.equalToSuperview().offset(-Spaced.module())
                }
            }
            
            essayRowView.addTarget(self, action: #selector(clickEssayControl), for: .touchUpInside)
            essayRowArray.append(essayRowView)
            essayRowtitleArray.append(returnArray[1] as! UILabel)
            essayRowtextArray.append(returnArray[2] as! UILabel)
            essayRowcoverArray.append(returnArray[3] as! UIImageView)
            essayRowbackgroundArray.append(returnArray[4] as! UIImageView)
            
            essayRowView.addInteraction(UIContextMenuInteraction(delegate: self))
        }
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
    
    func fetchEssayData() {
        /// 收集所有获取索引值URL的数组
        var indexURLArray: [URL] = []
        // 故事与小说分区所有内容索引值的URL
        guard let storyURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/List/story.plist") else { return }
        indexURLArray.append(storyURL)
        // 代码与技术分区所有内容索引值的URL
        guard let codeURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/List/code.plist") else { return }
        indexURLArray.append(codeURL)
        
        /// 初始化获取索引值的任务计数器
        let indexGroup = DispatchGroup()
        
        /// 收集所有内容索引值的数组
        var indexArray: [[Int]] = []
        for item in indexURLArray {
            indexGroup.enter()
            URLSession.shared.dataTask(with: URLRequest(url: item)) { (data, response, error) in
                if let data = data {
                    /// 请求单个分区的索引值数组
                    let decoder = PropertyListDecoder()
                    let result = try? decoder.decode([[Int]].self, from: data)
                    indexArray += result ?? [[0, 0]]
                    indexGroup.leave()
                }
            }.resume()
        }
        
        indexGroup.notify(queue: .main) {
            /// 从索引值数组中随机取出的7个元素
            let indexArray_random7 = self.randomElements(from: &indexArray, count: 7)
            /// 选出文章的编号数组（从索引值数组中随机取出7个元素组成数组的每个子数组的第一个元素组成的数组）
            var indexArray_random7_0: [Int] = []
            for i in 0 ... 6 {
                indexArray_random7_0.append(indexArray_random7[i][0])
            }
            
            /// 初始化获取cover和info的任务计数器
            // let infoGroup = DispatchGroup()
            for (index, item) in indexArray_random7_0.enumerated() {
                /// 获取选出文章的info的URL
                guard let infoURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/Essay/\(item)/info.txt") else { return }
                URLSession.shared.dataTask(with: URLRequest(url: infoURL)) { (data, response, error) in
                    if let data = data {
                        let string = String(data: data, encoding: .utf8) ?? "简介转换失败"
                        let stringArray = string.components(separatedBy: "\n")
                        DispatchQueue.main.async { [self] in
                            essayRowtitleArray[index].text = stringArray[0]
                            essayRowtextArray[index].text = stringArray[1]
                            essayRowArray[index].tag = item
                            essayRowArray[index].infoString = []
                            essayRowArray[index].infoString?.append(stringArray[0])
                            essayRowArray[index].infoString?.append(stringArray[1])
                            let dataString = dateInvoke(stringArray[2])
                            essayRowArray[index].infoString?.append(dataString)
                        }
                    }
                }.resume()
                guard let coverURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/Essay/\(item)/cover.png") else { return }
                URLSession.shared.dataTask(with: URLRequest(url: coverURL)) { (data, response, error) in
                    if let data = data {
                        let coverImage = UIImage(data: data)
                        DispatchQueue.main.async { [self] in
                            if let coverImage = coverImage {
                                essayRowcoverArray[index].image = coverImage
                                essayRowbackgroundArray[index].image = coverImage
                                essayRowArray[index].tag = item
                                // ⚠️没有infoString进去不行的
                            }
                        }
                    }
                }.resume()
            }
        }
    }
    
    func fetchCollectionData() {
        /// 收集所有获取索引值URL的数组
        var indexURLArray: [URL] = []
        // 故事与小说分区所有内容索引值的URL
        guard let collectionURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/List/collection.plist") else { return }
        indexURLArray.append(collectionURL)
        
        /// 初始化获取索引值的任务计数器
        let indexGroup = DispatchGroup()
        
        /// 收集所有内容索引值的数组
        var indexArray: [[Int]] = []
        for item in indexURLArray {
            indexGroup.enter()
            URLSession.shared.dataTask(with: URLRequest(url: item)) { (data, response, error) in
                if let data = data {
                    /// 请求单个分区的索引值数组
                    let decoder = PropertyListDecoder()
                    let result = try? decoder.decode([[Int]].self, from: data)
                    indexArray += result ?? [[0, 0]]
                    indexGroup.leave()
                }
            }.resume()
        }
        
        indexGroup.notify(queue: .main) {
            /// 从索引值数组中随机取出的7个元素
            let indexArray_random7 = self.randomElements(from: &indexArray, count: 7)
            /// 选出文章的编号数组（从索引值数组中随机取出7个元素组成数组的每个子数组的第一个元素组成的数组）
            var indexArray_random7_0: [Int] = []
            for i in 0 ... 6 {
                indexArray_random7_0.append(indexArray_random7[i][0])
            }
            
            /// 初始化获取cover和info的任务计数器
            // let infoGroup = DispatchGroup()
            for (index, item) in indexArray_random7_0.enumerated() {
                /// 获取选出文章的info的URL
                guard let infoURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/Collection/\(item)/info.txt") else { return }
                URLSession.shared.dataTask(with: URLRequest(url: infoURL)) { (data, response, error) in
                    if let data = data {
                        let string = String(data: data, encoding: .utf8) ?? "简介转换失败"
                        let stringArray = string.components(separatedBy: "\n")
                        DispatchQueue.main.async { [self] in
                            collectionBoxtitleArray[index].text = stringArray[0]
                            collectionBoxtextArray[index].text = stringArray[1]
                            collectionBoxArray[index].tag = item
                            collectionBoxArray[index].infoString = []
                            collectionBoxArray[index].infoString?.append(stringArray[0])
                            collectionBoxArray[index].infoString?.append(stringArray[1])
                            let dataString = dateInvoke(stringArray[2])
                            collectionBoxArray[index].infoString?.append(dataString)
                        }
                    }
                }.resume()
                guard let coverURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/Collection/\(item)/cover.png") else { return }
                URLSession.shared.dataTask(with: URLRequest(url: coverURL)) { (data, response, error) in
                    if let data = data {
                        let coverImage = UIImage(data: data)
                        DispatchQueue.main.async { [self] in
                            if let coverImage = coverImage {
                                collectionBoxcoverArray[index].image = coverImage
                                collectionBoxbackgroundArray[index].image = coverImage
                                collectionBoxArray[index].tag = item
                            }
                        }
                    }
                }.resume()
            }
        }
    }
}

// 📦➡️封装“推荐内容”界面中跳转界面的方法
extension SuggestViewController {
    ///
    @objc func clickEssayControl(_ sender: UIButton) {
        let VC = EssayViewController()
        VC.essayIndex = sender.tag
        VC.essayInfo = sender.infoString
        self.navigationController?.pushViewController(VC, animated: true)
    }
    ///
    @objc func clickCollectionControl(_ sender: UIButton) {
        let VC = CourseViewController()
        VC.collectionIndex = sender.tag
        VC.collectionInfo = sender.infoString
        self.navigationController?.pushViewController(VC, animated: true)
    }
    ///
    @objc func clickModuleTitleControl(_ sender: UIButton) {
        let VC = SelectedMineViewController()
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

// 📦🔄封装“推荐内容”界面中刷新重载功能（横竖屏和主题色切换）
extension SuggestViewController {
    
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
