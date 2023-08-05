import UIKit
import WebKit
import Ink

class EssayViewController: UIViewController, WKUIDelegate, UIScrollViewDelegate {
    
    var tag: String?
    var a = ""
    var underlyView = UIScrollView()
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "文章加载中", mode: .basic)
        self.navigationItem.largeTitleDisplayMode = .never
        
        // 创建URL对象
        guard let url = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/Essay/\(tag!)/body") else { return }
        
        // 创建URL请求
        let request = URLRequest(url: url)
        
        // 创建URLSession对象
        let session = URLSession.shared
        
        // 发送网络请求
        session.dataTask(with: request) { [self] (data, response, error) in
            if let data = data {
                // 将网络请求得到的数据转换为字符串
                
                // 在主线程更新UI
                DispatchQueue.main.async { [self] in
                    
                    a = (String(data: data, encoding: .utf8) ?? "")
                    
                    guard let markdownP = Bundle.main.path(forResource: "ceshi", ofType: "md") else { return }
                    var markdown = ""
                    do {
                        markdown = try String(contentsOfFile: markdownP)
                    } catch {
                        
                    }
                    print(markdown)
                    
                    let parser = MarkdownParser()
                    
                    let html = parser.html(from: markdown)
                    let newString = html.replacingOccurrences(of: "<table>", with: "<div><table>")
                    let newString1 = newString.replacingOccurrences(of: "</table>", with: "</table></div>")


                    // 获取CSS文件的路径
                    guard let cssPath = Bundle.main.path(forResource: "basic", ofType: "css") else { return }
                    
                    // 获取CSS内容
                    do {
                        let cssString = try String(contentsOfFile: cssPath)
                        
                        let result = "<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><meta name=\"viewport\"content=\"width=device-width, initial-scale=1.0\"><title>Document</title></head><style>" + cssString + "</style><body>" + newString1 + "</body><html>"
                        print(result)
                        
                        webView.loadHTMLString(result, baseURL: nil)
                    } catch {
                        print("无法读取CSS文件")
                    }
                }
            }
        }.resume()
        
        
        // 在需要响应主题切换的地方添加观察者
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: changeThemeNotification, object: nil)
        
        //        let fileURL = Bundle.main.path(forResource: "File", ofType: "")
        //        let content = try! String(contentsOfFile: fileURL!, encoding: .utf8)
        
    }
    
    // 实现观察者方法
    @objc func themeDidChange() {
        // 更新主题相关的设置
        
        // 记录当前滚动视图的偏移量
        var offset: CGPoint?
        for subview in view.subviews {
            if let scrollView = subview as? UIScrollView {
                offset = scrollView.contentOffset
                break
            }
        }
        
        // 移除旧的滚动视图
        for subview in view.subviews {
            if subview is UIScrollView {
                subview.removeFromSuperview()
            }
        }
        
        // 重新构建界面
        //        let fileURL = Bundle.main.path(forResource: "File", ofType: "")
        //        let content = try! String(contentsOfFile: fileURL!, encoding: .utf8)
        //        let scrollView = essayInterfaceBuild(content, self)
        self.viewDidLoad()
        // 将新的滚动视图的偏移量设置为之前记录的值
        if let offset = offset {
            underlyView.setContentOffset(offset, animated: false)
        }
    }
}

