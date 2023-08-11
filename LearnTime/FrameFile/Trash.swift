//
//  没有用的.swift
//  LearnTime
//
//  Created by LianJun on 2023/8/7.
//
//
//import Foundation
// 在需要响应主题切换的地方添加观察者







//        let underlyView = UIScrollView()
//        view.addSubview(underlyView)
//        underlyView.snp.makeConstraints { make in
//            make.edges.equalTo(self.view)
//        }
//        let containerView = UIView()
//        underlyView.addSubview(containerView)
//        containerView.snp.makeConstraints { make in
//            make.edges.equalTo(underlyView)
//            make.width.equalTo(underlyView)
//        }
//
//        let accountView = UIButton()
//        accountView.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
//        accountView.layer.cornerRadius = 15
//        containerView.addSubview(accountView)
//        accountView.snp.makeConstraints { make in
//            make.top.equalTo(Spaced.navigation())
//            make.left.equalTo(containerView.safeAreaLayoutGuide).offset(Spaced.screen())
//            make.right.equalTo(containerView.safeAreaLayoutGuide).offset(-Spaced.screen())
//            make.height.equalTo(90)
//            make.bottom.equalToSuperview().offset(-1000)
//        }
//        accountView.addTarget(self, action: #selector(clickedAccountView), for: .touchUpInside)
//
//        if let user = LCApplication.default.currentUser {
//            let label = UILabel()
//            accountView.addSubview(label)
//            label.snp.makeConstraints { make in
//                make.edges.equalTo(10)
//            }
//            label.text = user.username?.stringValue
//        } else {
//            let label = UILabel()
//            accountView.addSubview(label)
//            label.snp.makeConstraints { make in
//                make.edges.equalTo(10)
//            }
//            label.text = "点击注册或登录"
//        }





//                    // guard let markdownP = Bundle.main.path(forResource: "Test", ofType: "md") else { return }
//                    // var markdown = ""
//                    do {
//                        markdown = try String(contentsOfFile: markdownP)
//                        // 处理元数据
//                        let components = markdown.components(separatedBy: "---\n\n")
//                        let header = try Yams.load(yaml: components[0]) as? [String: Any]
//
//                        let title = header?["title"] as? String
//                        let author = header?["author"] as? String
//                        let dateStart = header?["dateStart"] as? String
//                        let dateEnd = header?["dateEnd"] as? String
//                        let infoText = header?["infoText"] as? String
//
//                        print("title: \(title ?? "")")
//                        print("author: \(author ?? "")")
//                        print("dateStart: \(dateStart ?? "")")
//                        print("dateEnd: \(dateEnd ?? "")")
//                        print("infoText: \(infoText ?? "")")
//                    } catch {
//
//                    }




//        let contentController = WKUserContentController()
//        contentController.add(self, name: "callbackHandler")
//
//        let config = WKWebViewConfiguration()
//        config.userContentController = contentController






// 设置第一个模块的横向滚动视图，用来承载第一个模块“精选合集”
//    let moduleView = UIScrollView(frame: CGRect(x: 0, y: moduleTitle1.frame.maxY + Spaced.control(), width: Screen.width(), height: largeControlSize.height))
//    moduleView.contentSize = CGSize(width: largeControlSize.width * 7 + Spaced.control() * 6 + Spaced.screenAuto() * 2, height: largeControlSize.height)
//    moduleView.showsHorizontalScrollIndicator = false
//    moduleView.clipsToBounds = false
//    underlyScrollView.addSubview(moduleView)
//    // 创建7个精选合集框
//    for i in 0 ... 6 {
//        // 配置参数
//        let moduleControlOrigin = CGPoint(x: Spaced.screenAuto() + CGFloat(i) * (largeControlSize.width + Spaced.control()), y: 0)
//        let featuredCourseBox = largeControlBuild(origin: moduleControlOrigin, imageName: featuredCollectionsRandomDataArray[i]["imageName"]!, title: featuredCollectionsRandomDataArray[i]["title"]!, title2: featuredCollectionsRandomDataArray[i]["author"]!)
//        featuredCourseBox.tag = i
//        featuredCourseBox.addTarget(self, action: #selector(clickCollectionControl), for: .touchUpInside)
//        moduleView.addSubview(featuredCourseBox)
//        let interaction = UIContextMenuInteraction(delegate: self)
//        featuredCourseBox.addInteraction(interaction)
//    }
    






//    static func spliceImage(_ image: UIImage, direction: Bool, imageSize: CGFloat) -> UIImage {
//        // 裁剪和拼接控件的背景图片
//        let image = image
//
//        let flippedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .upMirrored)
//        let imageSize = CGSize(width: Screen.basicWidth(), height: image.size.height / image.size.width * mediumControlImageWidth)
//        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
//        image.draw(in: CGRect(x: direction ? 0: imageSize - mediumControlImageWidth, y: 0, width: mediumControlImageWidth, height: imageSize.height))
//        flippedImage.draw(in: CGRect(x: direction ? mediumControlImageWidth: 0, y: 0, width: Screen.basicWidth() - mediumControlImageWidth, height: imageSize.height))
//        let finalImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//
//        return finalImage
//    }




//            let moduleControlOrigin = CGPoint(x: Spaced.screen() + CGFloat(i) * (largeControlSize.width + Spaced.control()), y: 0)
//            let featuredCourseBox = largeControlBuild(origin: moduleControlOrigin, imageName: featuredCollectionsRandomDataArray[i]["imageName"]!, title: featuredCollectionsRandomDataArray[i]["title"]!, title2: featuredCollectionsRandomDataArray[i]["author"]!)
//            featuredCourseBox.tag = i








//        // 发送网络请求
//        URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/List/story.plist")!)) { (data, response, error) in
//            if let data = data {
//                // 将网络请求得到的数据解析为字典对象
//                var result = try? PropertyListDecoder().decode([[Int]].self, from: data)
//
//
//                    // 在主线程更新UI
//                    DispatchQueue.main.async { [self] in
////                        let randomNumbers = self.randomElements(from: &result, count: 7) // 随机取 7 个元素
//                        var newArray: Array<Int> = []
//                        for i in 0 ... 6 {
//                            newArray.append(randomNumbers[i][0])
//                        }
//                        for (index, item) in newArray.enumerated() {
//                            // 请求info
//                            // 创建URL对象
//                            guard let infoURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/Essay/\(item)/info.plist") else { return }
//                            // 创建URL请求
//                            let request0 = URLRequest(url: infoURL)
//                            // 发送网络请求
//                            URLSession.shared.dataTask(with: request0) { [self] (data0, response0, error0) in
//                                if let data0 = data0 {
//                                    // 处理网络请求得到的数据
//                                    do {
//                                        let dict = try PropertyListDecoder().decode([String: String].self, from: data0)
//                                        info.append(dict)
//
//                                        DispatchQueue.main.async { [self] in
//                                            titleArray[index].text = dict["title"]!
//                                            textArray[index].text = dict["author"]!
//                                        }
//                                    } catch {
//                                        print(error0 ?? "error0的错误")
//                                    }
//                                }
//                            }.resume() // 发送网络请求
//                            guard let coverURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/Essay/\(item)/cover.png") else { return }
//                            // 创建URL请求
//                            let request1 = URLRequest(url: coverURL)
//                            // 发送网络请求
//                            URLSession.shared.dataTask(with: request1) { [self] (data1, response1, error1) in
//                                if let data1 = data1 {
//                                    // 处理网络请求得到的数据
//                                    let coverImage = UIImage(data: data1)
//                                    cover.append(coverImage ?? UIImage(named: "loading")!)
//
//                                    DispatchQueue.main.async { [self] in
//                                        coverArray[index].image = coverImage ?? UIImage(named: "loading")
//                                        backgroundArray[index].image = coverImage ?? UIImage(named: "loading")
//                                        cellViewArray[index].tag = item
//                                    }
//                                }
//                            }.resume() // 发送网络请求
//                        }
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//        }.resume() // 发送网络请求









//
//var index2: Array<Dictionary<String, String>> = []
//
//class MineViewController: UIViewController, UIContextMenuInteractionDelegate {
//
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//
//        var identifier = Int()
//        if let button = interaction.view as? UIButton {
//            identifier = button.tag
//        }
//
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
//
//            let previewControllerInstance = UIViewController()
//            if identifier < 7 {
//                let image = UIImageView(frame: CGRect(x: Spaced.screenAuto(), y: Spaced.screenAuto(), width: previewControllerInstance.view.bounds.width - Spaced.screenAuto() * 2, height: previewControllerInstance.view.bounds.width - Spaced.screenAuto() * 2))
//                image.layer.cornerRadius = 15
//                image.clipsToBounds = true
//                image.image = UIImage(named: index2[identifier]["imageName"]!)
//                previewControllerInstance.view.addSubview(image)
//
//                // 设置精选课程的标题
//                let courseLabel = UILabel(frame: CGRect(x: Spaced.screenAuto(), y: image.frame.maxY + Spaced.screenAuto(), width: 0, height: 0))
//                courseLabel.text = index2[identifier]["title"]
//                courseLabel.font = titleFont2
//                courseLabel.sizeToFit()
//                courseLabel.isUserInteractionEnabled = false
//                previewControllerInstance.view.addSubview(courseLabel)
//
//                // 设置精选课程的作者名
//                let courseLabel2 = UILabel(frame: CGRect(x: Spaced.screenAuto(), y: courseLabel.frame.maxY + Spaced.control(), width: 0, height: 0))
//                courseLabel2.text = index2[identifier]["author"]
//                courseLabel2.font = Font.title3()
//                courseLabel2.sizeToFit()
//                courseLabel2.isUserInteractionEnabled = false
//                previewControllerInstance.view.addSubview(courseLabel2)
//
//                previewControllerInstance.preferredContentSize = CGSize(width: previewControllerInstance.view.bounds.width, height: courseLabel2.frame.maxY + Spaced.screenAuto())
//            } else {
//                let image = UIImageView(frame: CGRect(x: Spaced.screenAuto(), y: Spaced.screenAuto(), width: previewControllerInstance.view.bounds.width - Spaced.screenAuto() * 2, height: previewControllerInstance.view.bounds.width - Spaced.screenAuto() * 2))
//                image.layer.cornerRadius = 20
//                image.clipsToBounds = true
//                image.image = UIImage(named: index2[identifier - 7]["name"]!)
//                previewControllerInstance.view.addSubview(image)
//
//                // 设置精选课程的标题
//                let courseLabel = UILabel(frame: CGRect(x: Spaced.screenAuto(), y: image.frame.maxY + Spaced.screenAuto(), width: 0, height: 0))
//                courseLabel.text = index2[identifier - 7]["name"]
//                courseLabel.font = Font.title2()
//                courseLabel.sizeToFit()
//                courseLabel.isUserInteractionEnabled = false
//                previewControllerInstance.view.addSubview(courseLabel)
//
//                // 设置精选课程的作者名
//                let courseLabel2 = UILabel(frame: CGRect(x: Spaced.screenAuto(), y: courseLabel.frame.maxY + Spaced.control(), width: 0, height: 0))
//                courseLabel2.text = index2[identifier - 7]["author"]
//                courseLabel2.font = Font.title3()
//                courseLabel2.sizeToFit()
//                courseLabel2.isUserInteractionEnabled = false
//                previewControllerInstance.view.addSubview(courseLabel2)
//
//                previewControllerInstance.preferredContentSize = CGSize(width: previewControllerInstance.view.bounds.width, height: courseLabel2.frame.maxY + Spaced.screenAuto())
//            }
//
//            return previewControllerInstance
//        }) { suggestedActions in
//            let action1 = UIAction(title: "查看该课程", image: UIImage(systemName: "eye")) { action in
//            }
//            let action2 = UIAction(title: "收藏至收藏夹", image: UIImage(systemName: "star")) { action in
//            }
//            let action3 = UIAction(title: "分享给朋友", image: UIImage(systemName: "square.and.arrow.up")) { action in
//            }
//            let menu1 = UIMenu(title: "",options: .displayInline, children: [action1, action2, action3])
//            let action4 = UIAction(title: "点赞课程", image: UIImage(systemName: "hand.thumbsup")) { action in
//            }
//            let action5 = UIAction(title: "打赏作者", image: UIImage(systemName: "dollarsign.circle")) { action in
//            }
//            let action6 = UIAction(title: "减少推荐", image: UIImage(systemName: "hand.thumbsdown")) { action in
//            }
//            let menu2 = UIMenu(title: "",options: .displayInline, children: [action4, action5, action6])
//            let action7 = UIAction(title: "反馈问题", image: UIImage(systemName: "quote.bubble.rtl")) { action in
//            }
//            let action8 = UIAction(title: "举报不良信息", image: UIImage(systemName: "exclamationmark.bubble"), attributes: .destructive) { action in
//            }
//            let menu3 = UIMenu(title: "",options: .displayInline, children: [action7, action8])
//            return UIMenu(title: "", children: [menu1, menu2, menu3])
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Set the backgroundColor of the interface and the title of the navigationBar
//        view.backgroundColor = .systemBackground
//        navigationItem.title = "我的收藏"
//        navigationController?.navigationBar.prefersLargeTitles = true
//
//        // Set the UIScrollView at the underlying of the interface
//        let mainScrollView = UIScrollView(frame: UIScreen.main.bounds)
//        mainScrollView.contentSize = CGSize(width: Screen.width, height: Screen.height() * 2)
//        view.addSubview(mainScrollView)
//
//        // Set the UILabel at the featuredCoursesBox tilte
//        let featuredCourseLable = UILabel(frame: CGRect(x: Spaced.screenAuto(), y: Spaced.module(), width: 0, height: 0))
//        featuredCourseLable.text = "收藏夹"
//        featuredCourseLable.font = titleFont2
//        featuredCourseLable.sizeToFit()
//        mainScrollView.addSubview(featuredCourseLable)
//
//        // Set a UIScrollView of featuredCourses at the top of the interface
//        let headerScrollView = UIScrollView(frame: CGRect(x: 0, y: featuredCourseLable.frame.maxY + Spaced.control(), width: Screen.width(), height: largeControlSize.height))
//        headerScrollView.contentSize = CGSize(width: largeControlSize.width * 7 + Spaced.control() * 6 + Spaced.screenAuto() * 2, height: largeControlSize.height)
//        headerScrollView.showsHorizontalScrollIndicator = false
//        headerScrollView.clipsToBounds = false
//        mainScrollView.addSubview(headerScrollView)
//
//        // Set the UILabel at the featuredCoursesBox tilte
//        let featuredCourseLable1 = UILabel(frame: CGRect(x: Spaced.screenAuto(), y: Spaced.module()2 + headerScrollView.frame.height + Spaced.module() * 2, width: 0, height: 0))
//        featuredCourseLable1.text = "收藏的合集"
//        featuredCourseLable1.font = Font.title2()
//        featuredCourseLable1.sizeToFit()
//        mainScrollView.addSubview(featuredCourseLable1)
//
//        // 设置随机数来从课程数据库中取用数据
//        var newCourseData = courseData() // 获取CourseData中的数据
//        newCourseData.shuffle() // 打乱数组顺序
//        for i in 0 ... 6 {
//            index2.append(newCourseData.prefix(7)[i]) // 取出前7个元素
//        }
//
//        // 循环创建精选课程框
//        for i in 0 ... 6 {
//
//            // 创建精选课程框
//            let featuredCourseBox = UIButton(frame: CGRect(x: Spaced.screenAuto() + CGFloat(CGFloat(i) * (Screen.width - Spaced.screenAuto() * 2 + Spaced.control())), y: 0, width: largeControl2Size.width, height: largeControl2Size.height))
//            featuredCourseBox.layer.cornerRadius = basicCornerRadius(featuredCourseBox.frame.size)
//            featuredCourseBox.setImage(UIImage(named: index2[i]["imageName"]!), for: .normal)
//            featuredCourseBox.imageView?.contentMode = .scaleAspectFill
//            featuredCourseBox.layer.masksToBounds = true
//            featuredCourseBox.tag = i
//            featuredCourseBox.addTarget(self, action: #selector(click), for: .touchUpInside)
//            headerScrollView.addSubview(featuredCourseBox)
//
//            // 设置精选课程框底部的高斯模糊
//            let blurEffect = UIBlurEffect(style: .light)
//            let blurView = UIVisualEffectView(effect: blurEffect)
//            blurView.frame = CGRect(x: 0, y: featuredCourseBox.frame.height / 4 * 3, width: featuredCourseBox.frame.width, height: featuredCourseBox.frame.height / 4)
//            blurView.isUserInteractionEnabled = false
//            featuredCourseBox.addSubview(blurView)
//
//            // 设置精选课程的标题
//            let courseLabel = UILabel(frame: CGRect(x: Spaced.screenAuto(), y: featuredCourseBox.frame.height / 4 * 3 + Spaced.screenAuto(), width: 0, height: 0))
//            courseLabel.text = index2[i]["title"]
//            courseLabel.font = UIFont.systemFont(ofSize: CGFloat(titleFont3), weight: .bold)
//            courseLabel.sizeToFit()
//            courseLabel.isUserInteractionEnabled = false
//            featuredCourseBox.addSubview(courseLabel)
//
//            // 设置精选课程的作者名
//            let courseLabel2 = UILabel(frame: CGRect(x: Spaced.screenAuto(), y: featuredCourseBox.frame.height / 4 * 3 + Spaced.screenAuto() + courseLabel.frame.height, width: 0, height: 0))
//            courseLabel2.text = index2[i]["author"]
//            courseLabel2.font = UIFont.systemFont(ofSize: basicFont, weight: .regular)
//            courseLabel2.sizeToFit()
//            courseLabel2.isUserInteractionEnabled = false
//            featuredCourseBox.addSubview(courseLabel2)
//
//            let interaction = UIContextMenuInteraction(delegate: self)
//            featuredCourseBox.addInteraction(interaction)
//
//        }
//
//        var cellViewArray: Array<UIButton> = []
//        for i in 0 ... 6 {
//            // 创建精选文章的框
//            let cellView = UIButton(frame: CGRect(origin: CGPoint(x: Spaced.screenAuto(), y: featuredCourseLable1.frame.maxY + Spaced.control() + CGFloat(i) * (Spaced.control() + mediumControlSize.height)), size: mediumControlSize))
//            cellView.setImage(UIImage(named: index2[i]["imageName"]!), for: .normal)
//            cellView.imageView?.contentMode = .scaleAspectFill
//            cellView.layer.cornerRadius = basicCornerRadius(cellView.frame.size)
//            cellView.clipsToBounds = true
//            cellView.tag = i + 7
//            cellView.addTarget(self, action: #selector(click), for: .touchUpInside)
//            cellViewArray.append(cellView)
//            mainScrollView.addSubview(cellView)
//
//            // 设置精选文章信息区域的高斯模糊背景
//            let blurEffect = UIBlurEffect(style: .light)
//            let blurView = UIVisualEffectView(effect: blurEffect)
//            if i == 2 || i == 3 || i == 4 {
//                blurView.frame = CGRect(x: cellView.frame.width / 5 * 2, y: 0, width: cellView.frame.width - cellView.frame.width / 5 * 2, height: cellView.frame.height + 1)
//            } else {
//                blurView.frame = CGRect(x: 0, y: 0, width: cellView.frame.width - cellView.frame.width / 5 * 2, height: cellView.frame.height + 1)
//            } // 判断模糊应该在左边还是右边
//            blurView.isUserInteractionEnabled = false
//            cellView.addSubview(blurView)
//
//            // 创建封面图视图
//            let imageView = UIImageView(image: UIImage(named: index2[i]["imageName"]!))
//            imageView.frame = CGRect(x: blurView.frame.origin.x == 0 ? blurView.frame.origin.x + blurView.frame.width - 1: 0, y: 0, width: cellView.frame.width - blurView.frame.width + 1, height: cellView.frame.height)
//            imageView.isUserInteractionEnabled = false
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            cellView.addSubview(imageView)
//
//            // 设置精选文章的标题
//            let essayLabel = UILabel(frame: CGRect(x: blurView.frame.origin.x + Spaced.screenAuto(), y: 0, width: blurView.frame.width - Spaced.control() * 2, height: 0))
//            essayLabel.text = index2[i]["title"]
//            essayLabel.font = UIFont.systemFont(ofSize: CGFloat(titleFont3), weight: .bold)
//            // 根据字符串长度赋予不同行数,最多为两行
//            if isTruncated(essayLabel) {
//                essayLabel.numberOfLines += 1
//            }
//            essayLabel.sizeToFit()
//            essayLabel.frame.size.width = blurView.frame.width - Spaced.control() * 2
//            essayLabel.isUserInteractionEnabled = false
//            cellView.addSubview(essayLabel)
//
//            // 设置精选文章的作者名
//            let essayLabel2 = UILabel()
//            essayLabel2.text = index2[i]["author"]
//            essayLabel2.font = UIFont.systemFont(ofSize: basicFont, weight: .regular)
//            essayLabel2.sizeToFit()
//            essayLabel2.isUserInteractionEnabled = false
//            cellView.addSubview(essayLabel2)
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
//            let interaction = UIContextMenuInteraction(delegate: self)
//            cellView.addInteraction(interaction)
//        }
//
//        mainScrollView.contentSize = CGSize(width: Screen.width, height: cellViewArray[6].frame.maxY + Spaced.control())
//
//
//    }
//
//    @objc func click(_ sender: UIButton) {
//        let b = CourseViewController()
//        let a = PaperViewController()
//        if sender.tag < 7 {
//            self.navigationController?.pushViewController(b, animated: true)
//        } else {
//            self.navigationController?.pushViewController(a, animated: true)
//        }
//    }
//
//}
//



//
//class DiscussViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    var btnArray: Array<UIButton> = []
//    let scrollViewNav = UIScrollView()
//    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//
//    let cellId = "cellId"
//    var topHeight = CGFloat() // 接收顶部高度
//    var navBarHeight = CGFloat() // 接收导航栏高度的变量
//    var a = CGFloat()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .systemBackground
//        navigationItem.title = "交流讨论"
//        navigationController?.navigationBar.prefersLargeTitles = true
//
//        let searchControllerInstance = UISearchController(searchResultsController: nil)
//        searchControllerInstance.obscuresBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        navigationItem.hidesSearchBarWhenScrolling = false
//        navigationItem.searchController = searchControllerInstance
//        navigationItem.searchController?.searchBar.isHidden = true
//        navigationItem.hidesSearchBarWhenScrolling = false
//
//        // 获取状态栏高度
//        var statusBarHeight = CGFloat()
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let statusBarManager = windowScene.statusBarManager {
//            statusBarHeight = statusBarManager.statusBarFrame.height
//        }
//        navBarHeight = navBar(self.navigationController!.navigationBar) // 获取导航栏高度
//        topHeight = statusBarHeight + navBarHeight // 导航栏加状态栏高度
//
//        scrollViewNav.frame = CGRect(x: 0, y: topHeight, width: Screen.width, height: 44)
//
//        scrollViewNav.showsHorizontalScrollIndicator = false
//
//
//        // 两字和三字UILabel的参考尺寸
//        let referenceLabel2 = UILabel()
//        referenceLabel2.text = "一二三四"
//        referenceLabel2.font = titleFont2
//        referenceLabel2.sizeToFit()
//
//        // 循环创建收藏界面导航栏按钮
//        let array = ["技术探讨", "文章教程", "闲聊杂谈", "互动排行", "反馈公示", "举报公示"]
//        for i in 0 ... 11 {
//            if 0 ... 5 ~= i {
//
//                let headerBtn = UIButton(frame: CGRect(x: CGFloat(i) * (Spaced.control() + 100) + Spaced.screenAuto(), y: 0, width: 100, height: 33))
//                headerBtn.setTitle(array[i], for: .normal)
//                headerBtn.setTitleColor(.black, for: .normal)
//                headerBtn.tag = i
//                headerBtn.addTarget(self, action: #selector(navClicked), for: .touchUpInside)
//                if i == 0 {
//                    headerBtn.backgroundColor = .systemPurple
//                }
//                btnArray.append(headerBtn)
//                scrollViewNav.addSubview(headerBtn)
//            } else {
//
//                let headerBtn = UIButton(frame: CGRect(x: CGFloat(i) * (Spaced.control() + 100) + Spaced.screenAuto(), y: 44, width: 100, height: 40))
//                headerBtn.setTitleColor(.black, for: .normal)
//                if i == 6 {
//                    headerBtn.frame.size.width = referenceLabel2.frame.width
//                } else {
//                    headerBtn.frame.origin.x = btnArray[i - 6].frame.minX
//                }
//                headerBtn.tag = i
//                headerBtn.addTarget(self, action: #selector(navClicked), for: .touchUpInside)
//                btnArray.append(headerBtn)
//
//            }
//
//        }
//
//        scrollViewNav.contentSize = CGSize(width: CGFloat(6) * (Spaced.control() + 100) + Spaced.screenAuto() * 2 - Spaced.control(), height: 44)
//
//        collectionView.dataSource = self
//        collectionView.delegate = self
//
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
//
//        view.addSubview(collectionView)
//        view.addSubview(scrollViewNav)
//        collectionView.backgroundColor = .systemBackground
//        collectionView.frame = view.frame
//        a = collectionView.contentOffset.y
//
//    }
//
//    // 导航栏按钮点击事件
//    @objc func navClicked(sender: UIButton) {
//
//        collectionView.setContentOffset(CGPoint(x: Int(Screen.width) * sender.tag, y: 0), animated: true)
//        switch sender.tag {
//        case 0:
//            sender.backgroundColor = .systemIndigo
//            for i in 0 ... 5 {
//                if i != 0 {
//                    btnArray[i].backgroundColor = .clear
//                }
//            }
//        case 1:
//            sender.backgroundColor = .systemIndigo
//            for i in 0 ... 5 {
//                if i != 1 {
//                    btnArray[i].backgroundColor = .clear
//                }
//            }
//        case 2:
//            sender.backgroundColor = .systemIndigo
//            for i in 0 ... 5 {
//                if i != 2 {
//                    btnArray[i].backgroundColor = .clear
//                }
//            }
//        case 3:
//            sender.backgroundColor = .systemIndigo
//            for i in 0 ... 5 {
//                if i != 3 {
//                    btnArray[i].backgroundColor = .clear
//                }
//            }
//        case 4:
//            sender.backgroundColor = .systemIndigo
//            for i in 0 ... 5 {
//                if i != 4 {
//                    btnArray[i].backgroundColor = .clear
//                }
//            }
//        case 5:
//            sender.backgroundColor = .systemIndigo
//            for i in 0 ... 5 {
//                if i != 5 {
//                    btnArray[i].backgroundColor = .clear
//                }
//            }
//        default:
//            btnArray[sender.tag - 6].sendActions(for: .touchUpInside)
//        }
//
//    }
//
//
//    var bool = true
////    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        if a == 0, bool {
////            bool = false
////            a = collectionView.contentOffset.y
////        }
////        if (navigationController?.navigationBar.frame.height)! >= CGFloat(100) {
////            scrollViewNav.frame.origin.y = a - collectionView.contentOffset.y + 96
////        } else {
////            scrollViewNav.frame.origin.y = 44
////        }
////        print(a, collectionView.contentOffset.y, (navigationController?.navigationBar.frame.height)!, scrollViewNav.frame.origin.y)
////
////    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 21
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
//
//        let index = indexPath.row % 7
//        let cellView = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: mediumControlSize))
//        cellView.setImage(UIImage(named: index1[index]["imageName"]!), for: .normal)
//        cellView.imageView?.contentMode = .scaleAspectFill
//        cellView.layer.cornerRadius = basicCornerRadius(cellView.frame.size)
//        cellView.clipsToBounds = true
//        cellView.tag = index + 7
//        cellView.addTarget(self, action: #selector(click), for: .touchUpInside)
//        cell.addSubview(cellView)
//
//        // 设置精选文章信息区域的高斯模糊背景
//        let blurEffect = UIBlurEffect(style: .light)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        if index == 2 || index == 3 || index == 4 {
//            blurView.frame = CGRect(x: cellView.frame.width / 5 * 2, y: 0, width: cellView.frame.width - cellView.frame.width / 5 * 2, height: cellView.frame.height + 1)
//        } else {
//            blurView.frame = CGRect(x: 0, y: 0, width: cellView.frame.width - cellView.frame.width / 5 * 2, height: cellView.frame.height + 1)
//        } // 判断模糊应该在左边还是右边
//        blurView.isUserInteractionEnabled = false
//        cellView.addSubview(blurView)
//
//        // 创建封面图视图
//        let imageView = UIImageView(image: UIImage(named: index1[index]["imageName"]!))
//        imageView.frame = CGRect(x: blurView.frame.origin.x == 0 ? blurView.frame.origin.x + blurView.frame.width - 1: 0, y: 0, width: cellView.frame.width - blurView.frame.width + 1, height: cellView.frame.height)
//        imageView.isUserInteractionEnabled = false
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        cellView.addSubview(imageView)
//
//        // 设置精选文章的标题
//        let essayLabel = UILabel(frame: CGRect(x: blurView.frame.origin.x + Spaced.screenAuto(), y: 0, width: blurView.frame.width - Spaced.control() * 2, height: 0))
//        essayLabel.text = index1[index]["title"]
//        essayLabel.font = UIFont.systemFont(ofSize: CGFloat(titleFont3), weight: .bold)
//        // 根据字符串长度赋予不同行数,最多为两行
//        if isTruncated(essayLabel) {
//            essayLabel.numberOfLines += 1
//        }
//        essayLabel.sizeToFit()
//        essayLabel.frame.size.width = blurView.frame.width - Spaced.control() * 2
//        essayLabel.isUserInteractionEnabled = false
//        cellView.addSubview(essayLabel)
//
//        // 设置精选文章的作者名
//        let essayLabel2 = UILabel()
//        essayLabel2.frame.origin = CGPoint(x: blurView.frame.origin.x + Spaced.control(), y: (blurView.frame.height - essayLabel.frame.height * 2 - essayLabel2.frame.height - Spaced.control()) / 2 + essayLabel.frame.height * 2 + Spaced.control())
//        essayLabel2.text = index1[index]["author"]
//        essayLabel2.font = font(.body)
//        essayLabel2.sizeToFit()
//        essayLabel2.isUserInteractionEnabled = false
//        cellView.addSubview(essayLabel2)
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return mediumControlSize
//    }
//
//    @objc func click(_ sender: UIButton) {
//        let b = CourseViewController()
//        let a = PaperViewController()
//        if sender.tag < 7 {
//            self.navigationController?.pushViewController(b, animated: true)
//        } else {
//            self.navigationController?.pushViewController(a, animated: true)
//        }
//    }
//
//}










/// 搜索栏控制器
//let searchControllerInstance = UISearchController(searchResultsController: nil)
//navigationItem.searchController = searchControllerInstance
//searchControllerInstance.searchBar.placeholder = "搜索所有内容"
//searchControllerInstance.obscuresBackgroundDuringPresentation = false
//searchControllerInstance.searchBar.searchTextField.backgroundColor = UIColor.systemGroupedBackground
//definesPresentationContext = true
//navigationItem.hidesSearchBarWhenScrolling = false
