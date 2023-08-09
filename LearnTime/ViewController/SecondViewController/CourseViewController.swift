
import UIKit
import Yams

class CourseViewController: UIViewController {
    // 接收其他界面的属性传值的变量
    /// 合集内容的唯一索引码
    var collectionIndex: Int!
    /// 合集内容的部分简介
    var collectionInfo: [String]!
    
    var essayTitle: [Int: String] = [:]
    var essayAuthor: [Int: String] = [:]
    var essayCover: [Int: UIImage] = [:]
    
    var essayIndexArray: [Int] = []
    var essayInfoArray: [Int: [String]] = [:]
    
    let underlyView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, collectionInfo[0], mode: .group)
    
        view.addSubview(underlyView)
        underlyView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        underlyView.delegate = self
        underlyView.dataSource = self
        underlyView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // 获取整个文章主体内容的URL
        guard let profileURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/Collection/\(collectionIndex ?? 0)/profile.txt") else { return }
        // 发送网络请求
        URLSession.shared.dataTask(with: URLRequest(url: profileURL)) { [self] (data, response, error) in
            /// 初始化获取索引值的任务计数器
            let indexGroup = DispatchGroup()
            
            if let data = data {
                // 获取文章原始数据
                let profileString = String(data: data, encoding: .utf8) ?? "文章数据转换失败"
                // 处理文章中的元数据
                let components = profileString.components(separatedBy: "7777lianjun7777")
                let header = try? Yams.load(yaml: components[0]) as? [String: Any]
                
                let title = header?["title"] as? String
                let author = header?["author"] as? String
                let coverLink = header?["coverLink"] as? String
                let createdData = header?["createdData"] as? String
                let modifiedData = header?["modifiedData"] as? String
                let type = header?["type"] as? String
                let index = header?["index"] as? String
                let essayIndex = header?["essayIndex"] as? [Int]
                let originalLink = header?["originalLink"] as? String
                let authorArray = header?["authorArray"] as? [String]
                let originalAuthor = header?["originalAuthor"] as? String
                
                essayIndexArray = essayIndex!
                
                indexGroup.enter()
                
                guard let coverURL = URL(string: coverLink!) else { return }
                URLSession.shared.dataTask(with: URLRequest(url: coverURL)) { [self] (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async { [self] in
                            let coverView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Screen.nativeWidth()))
                            
                            let collectionCoverView = UIImageView(image: UIImage(data: data))
                            collectionCoverView.layer.cornerRadius = 15
                            collectionCoverView.layer.masksToBounds = true
                            coverView.addSubview(collectionCoverView)
                            collectionCoverView.snp.makeConstraints { make in
                                make.top.left.equalTo(Spaced.screen())
                                make.size.equalTo(Screen.nativeBasicWidth())
                            }
                            underlyView.tableHeaderView = coverView

                        }
                    }
                }.resume()
                
                for item in 0 ..< essayIndex!.count {
                    indexGroup.enter()
                    // 获取整个文章主体内容的URL
                    guard let essayURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/Essay/\((essayIndex!)[item])/info.txt") else { return }
                    URLSession.shared.dataTask(with: URLRequest(url: essayURL)) { [self] (data, response, error) in
                        if let data = data {
                            let string = String(data: data, encoding: .utf8) ?? "简介转换失败"
                            let stringArray = string.components(separatedBy: "\n")
                            if stringArray[0] != "<!DOCTYPE html>" {
                                essayTitle[item] = "\(item + 1).\(stringArray[0])"
                                essayAuthor[item] = stringArray[1]
                                essayInfoArray[item] = [stringArray[0], stringArray[1], stringArray[2]]
                            } else {
                                essayTitle[item] = "加载失败"
                                essayTitle[item] = "加载失败"
                            }
                        }
                        indexGroup.leave()
                    }.resume()
                    indexGroup.enter()
                    guard let coverURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/Essay/\((essayIndex!)[item])/cover.png") else { return }
                    URLSession.shared.dataTask(with: URLRequest(url: coverURL)) { [self] (data, response, error) in
                        if let data = data {
                            essayCover[item] = UIImage(data: data)
                        }
                        indexGroup.leave()
                    }.resume()
                }
                indexGroup.leave()
            }
            indexGroup.notify(queue: .main) {
                DispatchQueue.main.async {
                    underlyView.reloadData()
                }
            }
        }.resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
}

extension CourseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(essayTitle)
        return essayTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: .none)
        cell.textLabel?.text = essayTitle[indexPath.row]
        cell.detailTextLabel?.text = essayAuthor[indexPath.row]
        cell.imageView?.image = essayCover[indexPath.row]
        cell.imageView?.layer.cornerRadius = 5
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.snp.makeConstraints { make in
            make.top.equalTo(2)
            make.left.equalTo(cell.safeAreaLayoutGuide).offset(Spaced.screen())
            make.width.height.equalTo(52)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationViewController = EssayViewController()
        destinationViewController.essayIndex = essayIndexArray[indexPath.row]
        destinationViewController.essayInfo = essayInfoArray[indexPath.row]
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

