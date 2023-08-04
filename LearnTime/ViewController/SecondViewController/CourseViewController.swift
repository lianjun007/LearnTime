import UIKit

class CourseViewController: UIViewController {
    
    var tag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "精选课程标题", mode: .group)

        let collectionView = UITableView(frame: view.bounds, style: .insetGrouped)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension CourseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = collectionData["11"]!["essays"] as! Array<Int>
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: .none)
        
        cell.textLabel?.text = essayData["\(data[indexPath.row])"]!["title"]! as? String
 
        cell.imageView?.image = UIImage(named: "preson")
        
        return cell
    }

}

