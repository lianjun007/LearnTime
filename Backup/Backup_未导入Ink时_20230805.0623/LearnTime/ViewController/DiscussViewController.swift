//
//import UIKit

import UIKit

class DiscussViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "发现更多", mode: .basic)
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        button.setTitle("Button", for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.masksToBounds = true
        button.tintColor = UIColor.white
        button.setBackgroundImage(UIImage(named: "FC3"), for: .normal)


        view.addSubview(button)

    }
}
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
////        let searchControllerInstance = UISearchController(searchResultsController: nil)
////        searchControllerInstance.obscuresBackgroundDuringPresentation = false
////        definesPresentationContext = true
////        navigationItem.hidesSearchBarWhenScrolling = false
////        navigationItem.searchController = searchControllerInstance
////        navigationItem.searchController?.searchBar.isHidden = true
////        navigationItem.hidesSearchBarWhenScrolling = false
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
