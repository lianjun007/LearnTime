//
//  没有用的.swift
//  LearnTime
//
//  Created by LianJun on 2023/8/7.
//

import Foundation
// 在需要响应主题切换的地方添加观察者
// NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: changeThemeNotification, object: nil)

//        let fileURL = Bundle.main.path(forResource: "File", ofType: "")
//        let content = try! String(contentsOfFile: fileURL!, encoding: .utf8)


// 实现观察者方法
//    @objc func themeDidChange() {
    // 更新主题相关的设置
    
//        // 记录当前滚动视图的偏移量
//        var offset: CGPoint?
//        for subview in view.subviews {
//            if let scrollView = subview as? UIScrollView {
//                offset = scrollView.contentOffset
//                break
//            }
//        }
//
//        // 移除旧的滚动视图
//        for subview in view.subviews {
//            if subview is UIScrollView {
//                subview.removeFromSuperview()
//            }
//        }
//
//        // 重新构建界面
//        //        let fileURL = Bundle.main.path(forResource: "File", ofType: "")
//        //        let content = try! String(contentsOfFile: fileURL!, encoding: .utf8)
//        //        let scrollView = essayInterfaceBuild(content, self)
//        self.viewDidLoad()
//        // 将新的滚动视图的偏移量设置为之前记录的值
//        if let offset = offset {
//            underlyView.setContentOffset(offset, animated: false)
//        }
//    }

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
