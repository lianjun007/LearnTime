
import UIKit
import JXSegmentedView

class DiscussViewController: UIViewController, JXSegmentedViewDelegate, JXSegmentedListContainerViewListDelegate {
    
    let segmentedDataSource = JXSegmentedTitleDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "发现更多", mode: .basic)

        let segmentedView = JXSegmentedView()
        segmentedView.delegate = self
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.right.left.equalTo(0)
            make.height.equalTo(44)
        }
        
        // segmentedDataSource一定要通过属性强持有，不然会被释放掉
       
        // 配置数据源相关配置属性
        
        segmentedDataSource.titles = ["精选", "文章", "合集", "闲聊", "反馈"]
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedDataSource.isItemSpacingAverageEnabled = false
        // 关联dataSource
        segmentedView.dataSource = segmentedDataSource
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 20
        segmentedView.indicators = [indicator]
    }
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        segmentedDataSource.titles.count
    }
    
    func listView() -> UIView {
        self.view
    }
    
}
