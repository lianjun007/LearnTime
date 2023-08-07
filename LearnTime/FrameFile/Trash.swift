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
