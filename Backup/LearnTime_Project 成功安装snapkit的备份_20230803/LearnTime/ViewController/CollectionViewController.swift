//
//  CourseViewController.swift
//  CodeForum
//
//  Created by QHuiYan on 2023/5/22.
//let array = ["收藏夹", "合集", "文章", "闲聊杂谈", "用户", "官方公示"]

import UIKit

class CollectionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "我的收藏", mode: .basic)
    }
}
//
//var index2: Array<Dictionary<String, String>> = []
//
//class CollectionViewController: UIViewController, UIContextMenuInteractionDelegate {
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
