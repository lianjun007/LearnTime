
import Foundation

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
