
import Foundation

func dataInvoke(css style: String, html body: String = "", info: [String]) -> String {
"""
<!DOCTYPE html>
<html lang=\"en\">
    <head>
        <meta charset=\"UTF-8\">
        <meta name=\"viewport\"content=\"width=device-width, initial-scale=1.0\">
        <title>Document</title>
    </head>
    <style>
        \(style)
    </style>
    <body>
        <p id="title">
            \(info[0])
        </p>
        <button id="essayInfo" onclick="infoClick()">
            <p id="essayType">
                原创
            </p>
            <spen id="essayAuthor">
                \(info[1])
            </spen>
            <spen id="essayData">
                \(info[2])
            </spen>
        </button>
        \(body)
    </body>
    <script>
        function infoClick() {
            window.webkit.messageHandlers.infoClick.postMessage("");
        }
    </script>
<html>
"""

//        <p class="data">
//            \(info[2])
//        </p>
//        <p class="data">
//            \(info[3])
//        </p>

}

func dataInvoke(css style: String, html body: String, title: String, author: String, cover: String, createdData: String, modifiedData: String, originalLink: String) -> String {
    """
    <!DOCTYPE html>
    <html lang=\"en\">
        <head>
            <meta charset=\"UTF-8\">
            <meta name=\"viewport\"content=\"width=device-width, initial-scale=1.0\">
            <title>Document</title>
        </head>
        <style>
            \(style)
        </style>
        <body>
            <img src="\(cover)" alt="文章的封面">
            <p id="title">
                \(title)
            </p>
            <div id="infoAuthorBox">
                <p id="infoType">
                    原创
                </p>
                <button id="infoAuthor" onclick="authorClicked()">
                    \(author)
                </button>
            </div>
            <div id="infoDataBox">
                <p id="infoCreatedData">
                    创建时间：\(createdData)
                </p>
                <p id="infoModifiedData">
                    修改时间：\(modifiedData)
                </p>
            </div>
            <a id="infoLink" href="\(originalLink)">原文链接</a>
            \(body)
        </body>
        <script>
            function authorClicked() {
                window.webkit.messageHandlers.authorClicked.postMessage("");
            }
        </script>
    <html>
    """
}

func dateInvoke(_ date: String) -> String {
    var newdata = date
    switch date.count {
    case 4:
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let date2 = dateFormatter.date(from: newdata)
        dateFormatter.dateFormat = "yyyy年"
        newdata = dateFormatter.string(from: date2!)
    case 6:
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        let date2 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy年MM月"
        newdata = dateFormatter.string(from: date2!)
    case 8:
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let date2 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        newdata = dateFormatter.string(from: date2!)
    case 10:
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHH"
        let date2 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH时"
        newdata = dateFormatter.string(from: date2!)
    case 12:
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        let date2 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        newdata = dateFormatter.string(from: date2!)
    case 14:
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let date2 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        newdata = dateFormatter.string(from: date2!)
    default: break
    }
    return newdata
}

func markdownToHtml(_ data: String) -> String {
    // table标签外添加div标签，让table变得可以滚动
    let newData1 = data.replacingOccurrences(of: "<table>", with: "<div class=\"tableBox\"><table>")
    let newData2 = newData1.replacingOccurrences(of: "</table>", with: "</table></div>")
    return newData2
}

// 随机取用数组方法
func arrayRandom(number: Int, array: Array<Any>) -> Array<Any> {
    var randomArray: Array<Any> = []
    var newArray = array
    newArray.shuffle()
    for i in 0 ..< number {
        randomArray.append(newArray.prefix(number)[i])
    }
    // 将一个数组传入，随机从中取出指定数量的元素后构成一个新数组
    return randomArray
}

// 精选合集数据初始化方法
func featuredCollectionsDataInitialize() -> Array<Dictionary<String, String>>  {
    var dataArray: Array<Dictionary<String, String>> = []
    if let path = Bundle.main.path(forResource: "FeaturedCollectionsData", ofType: "plist") {
        if let array = NSArray(contentsOfFile: path) as? [Dictionary<String, String>] {
            dataArray = array
        }
    }
    // 将精选合集数据里面的所有数据全部初始化载入项目
    return dataArray
}

func contentDataInitialize() -> Dictionary<String, Dictionary<String, Dictionary<String, Any>>>  {
    var dataArray: Dictionary<String, Dictionary<String, Dictionary<String, Any>>> = [:]
    if let path = Bundle.main.path(forResource: "ContentFile", ofType: "plist") {
        if let array = NSDictionary(contentsOfFile: path) as? Dictionary<String, Dictionary<String, Dictionary<String, Any>>> {
            dataArray = array
        }
    }
    // 将精选合集数据里面的所有数据全部初始化载入项目
    return dataArray
}
