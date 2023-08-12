
import UIKit
import WebKit
import Yams
import Ink

class InfoViewControlle: UIViewController {
    // 接收其他界面的属性传值的变量
    /// 接收文章内容的唯一索引码
    var essayIndex: Int!
    /// 接收文章内容的CSS文件数据
    var cssString: String!
    
    /// 底层的Web视图，最基础的界面
    var webView: WKWebView!
    
    override func loadView() {
        // 创建webview并且让他覆盖整个页面的view
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
        
        // 给webView的按钮关联上原生代码
        webConfiguration.userContentController.add(self, name: "authorClicked")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize.view(self, "简介", mode: .basic)
        webView.navigationDelegate = self
        
        // 获取整个文章简介内容的URL
        guard let infoURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/Essay/\(essayIndex ?? 0)/profile.txt") else { return }
        // 发送网络请求
        URLSession.shared.dataTask(with: URLRequest(url: infoURL)) { [self] (data, response, error) in
            if let data = data {
                DispatchQueue.main.async { [self] in
                    // 获取文章原始数据
                    let infoString = String(data: data, encoding: .utf8) ?? "文章数据转换失败"
                    // 处理文章中的元数据
                    let components = infoString.components(separatedBy: "7777lianjun7777")
                    let header = try? Yams.load(yaml: components[0]) as? [String: Any]
                    
                    let title = header?["title"] as? String
                    let author = header?["author"] as? String
                    let coverLink = header?["coverLink"] as? String
                    let createdData = header?["createdData"] as? String
                    let modifiedData = header?["modifiedData"] as? String
                    let type = header?["type"] as? String
                    let index = header?["index"] as? String
                    let originalLink = header?["originalLink"] as? String
                    let authorArray = header?["authorArray"] as? [String]
                    let originalAuthor = header?["originalAuthor"] as? String
                    
                    // 将文章原始数据markdown格式经过一系列处理转换为html格式并且加载
                    let html0 = MarkdownParser().html(from: components[1])
                    let html1 = markdownToHtml(html0)
                    /// 最终处理完的html数据
                    let essayHtml = dataInvoke(css: cssString, html: html1, title: title ?? "未知", author: author ?? "未知", cover: coverLink ?? "404图片链接⚠️", createdData: createdData ?? "未知", modifiedData: modifiedData ?? "未知", originalLink: originalLink ?? "未知")
                    webView.loadHTMLString(essayHtml, baseURL: nil)
                }
            }
        }.resume()
    }
}

/// 📦封装JavaScript相关实现webView的一些特殊功能的代码
extension InfoViewControlle: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    /// 注入JavaScript让webView界面屏蔽缩放功能
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let javascript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"
        webView.evaluateJavaScript(javascript)
    }
    
    /// 注入注入JavaScript让webView中的一个按钮点击后执行原生Swift代码
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "authorClicked" {
            // 在这里执行跳转到原生视图控制器的代码
        }
    }
}
