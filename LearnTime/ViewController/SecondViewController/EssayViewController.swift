// 阅读界面，展示内容的地方

import UIKit
import WebKit
import Ink
import Yams

class EssayViewController: UIViewController {
    // 接收其他界面的属性传值的变量
    /// 文章内容的唯一索引码
    var essayIndex: Int!
    /// 文章内容的部分简介
    var essayInfo: [String]!
    
    /// 底层的Web视图，最基础的界面
    var webView: WKWebView!
    
    /// 接收CSS数据渲染页面并且传递给简介页面
    var cssString: String! = ""
    
    override func loadView() {
        // 创建webview并且让他覆盖整个页面的view
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
        
        // 给webView的按钮关联上原生代码
        webConfiguration.userContentController.add(self, name: "infoClick")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if essayInfo != nil {
            Initialize.view(self, essayInfo[0], mode: .basic)
        } else {
            Initialize.view(self, "获取文章失败", mode: .basic)
        } // 判断上级界面点击的按钮是否加载好数据
        self.navigationItem.largeTitleDisplayMode = .never
        webView.navigationDelegate = self
        
        // 获取CSS内容
        guard let cssPath = Bundle.main.path(forResource: "basic", ofType: "css") else { return }
        cssString = try? String(contentsOfFile: cssPath)
        
        // 先直接加载标题作者和日期等从上个界面传递过来的数据
        if let cssString = cssString {
            let infoHtml = dataInvoke(css: cssString, info: essayInfo)
            webView.loadHTMLString(infoHtml, baseURL: nil)
        }

        // 获取整个文章主体内容的URL
        guard let bodyURL = URL(string: "https://lianjun581.github.io/lianjun581/LearnTime/Content/Essay/\(essayIndex ?? 0)/body.md") else { return }
        // 发送网络请求
        URLSession.shared.dataTask(with: URLRequest(url: bodyURL)) { [self] (data, response, error) in
            if let data = data {
                DispatchQueue.main.async { [self] in
                    // 将文章原始数据markdown格式经过一系列处理转换为html格式并且加载
                    let bodyString = String(data: data, encoding: .utf8) ?? "文章数据转换失败"
                    let html0 = MarkdownParser().html(from: bodyString)
                    let html1 = markdownToHtml(html0)
                    /// 最终处理完的html数据
                    let essayHtml = dataInvoke(css: cssString!, html: html1, info: essayInfo)
                    webView.loadHTMLString(essayHtml, baseURL: nil)
                }
            }
        }.resume()
    }
}

/// 📦封装JavaScript相关实现webView的一些特殊功能的代码
extension EssayViewController: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    /// 注入JavaScript让webView界面屏蔽缩放功能
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let javascript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"
        webView.evaluateJavaScript(javascript)
    }
    
    /// 注入注入JavaScript让webView中的一个按钮点击后执行原生Swift代码
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "infoClick" {
            // 在这里执行跳转到原生视图控制器的代码
            let VC = InfoViewControlle()
            VC.essayIndex = essayIndex
            VC.cssString = cssString
            let navigationController = UINavigationController(rootViewController: VC)
            present(navigationController, animated: true)
        }
    }
}
