
import UIKit
import Yams

class CourseViewController: UIViewController {
    // 接收其他界面的属性传值的变量
    /// 文章内容的唯一索引码
    var collectionIndex: Int!
    /// 文章内容的部分简介
    var collectionInfo: [String]!
    
    var essayTitle: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, collectionInfo[0], mode: .group)
        
        let underlyView = UITableView(frame: view.bounds, style: .insetGrouped)
        view.addSubview(underlyView)
        underlyView.delegate = self
        underlyView.dataSource = self
        underlyView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // 获取整个文章主体内容的URL
        guard let profileURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/Collection/\(collectionIndex ?? 0)/profile.txt") else { return }
        // 发送网络请求
        URLSession.shared.dataTask(with: URLRequest(url: profileURL)) { [self] (data, response, error) in
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
                for item in 0 ..< essayIndex!.count {
                    // 获取整个文章主体内容的URL
                    guard let essayURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/Essay/\(item)/info.txt") else { return }
                    URLSession.shared.dataTask(with: URLRequest(url: essayURL)) { [self] (data, response, error) in
                        if let data = data {
                            let string = String(data: data, encoding: .utf8) ?? "简介转换失败"
                            let stringArray = string.components(separatedBy: "\n")
                            if stringArray[0] != "<!DOCTYPE html>" {
                                essayTitle.append(stringArray[0])
                            } else {
                                essayTitle.append("文章标题加载失败...")
                            }
                            print(essayTitle)
                        }
                        DispatchQueue.main.async {
                            underlyView.reloadData()
                        }
                    }.resume()
                }
            }
        }.resume()
    }
}

extension CourseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(essayTitle)
        return essayTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: .none)
        print(essayTitle, "222")
        cell.textLabel?.text = essayTitle[indexPath.row]
        cell.imageView?.image = UIImage(named: "preson")
        
        return cell
    }
}

