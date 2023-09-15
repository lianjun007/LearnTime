
import UIKit
import JXSegmentedView

class DiscussViewController: UIViewController, JXSegmentedViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "发现更多", mode: .basic)

        let segmentedView = JXSegmentedView()
        segmentedView.backgroundColor = UIColor.orange
        segmentedView.delegate = self
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.top.right.bottom.left.equalTo(0)
        }
        
        //segmentedDataSource一定要通过属性强持有，不然会被释放掉
        let segmentedDataSource = JXSegmentedTitleDataSource()
        //配置数据源相关配置属性
        segmentedDataSource.titles = ["猴哥", "青蛙王子", "旺财"]
        segmentedDataSource.isTitleColorGradientEnabled = true
        //关联dataSource
        segmentedView.dataSource = segmentedDataSource
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 20
        segmentedView.indicators = [indicator]
    }
}
