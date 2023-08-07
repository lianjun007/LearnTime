---
title: Swift中安全优雅的使用UserDefaults
author: 未知
---


# 前言

纳尼？如此简单的 UserDefaults 怎么去优雅的使用？这么简单的还能玩出花来？没毛病吧？

嗯，没毛病！

***

# 正文

## 分析

Objective-C 中的 NSUserDefaults 我们并不陌生，通常作为数据持久化的一种方式，一般用来存储用户信息和基础配置信息。Swift 中使用 UserDefaults 来替代 NSUserDefaults，两者的使用基本相同。

```swift
let defaults = UserDefaults.standard
defaults.set(123, forKey: "defaultKey")
defaults.integer(forKey: "defaultKey")
```

> Objective-C 中需要调用 synchronize 方法进行同步，但是在 Swift 中已经废弃了该方法，所以不需要手动去调用。
>
>
>
>
>
> -synchronize is deprecated and will be marked with the NS_DEPRECATED macro in a future release.

上面的用法是最基本的用法，也是我们平常开发中使用频率最高的用法，但也是最危险的用法，为什么呢?

1. 在应用内部我们可以随意地覆盖和删除存储的值，直接使用字符串来作为存储数据的 key 是非常危险的，容易导致存数据时使用的 key 和取数据的时候使用的 key 不一致。
2. UserDefaults.standard 是一个全局的单例，如果需要存储账户信息（AccountInfo），配置信息（SettingInfo），此时按照最基本的使用方式，简单的使用 key 来存取数据，那么 key 值会随着存储的数据越来越多，到时候不管是新接手的小伙伴还是我们自己都很难明白每个 key 值对应的意义。 也就是说我们不能根据方法调用的上下文明确知道我存取数据的具体含义，代码的可读性和可维护性就不高。所以我们要利用 Swift 强大的灵活性来让我们使用 UserDefaults 存取数据的时候更加便捷和安全。

所以要想把 UserDefaults 玩出花来就得解决下面两个问题：

- 一致性
- 上下文

## 一致性

使用 UserDefaults 存取数据时使用的 key 值不同就会导致存在一致性问题。原因就在于通常我们在存取数据的时候，手动键入 key 或者复制粘贴 key 可能会出错，输入的时候也很麻烦。那我们的目的就比较明确了，就是为了让存取的 key 一致，即使改了其中一个另外一个也随之更改。

解决办法:

- 常量保存
- 分组存储

### 常量保存

既然涉及到两个重复使用的字符串，很容易就想到用常量保存字符串，只有在初始化的时候设置 key 值，存取的时候拿来用即可，简单粗暴的方式.

```swift
let defaultStand = UserDefaults.standard
let defaultKey = "defaultKey"
defaultStand.set(123, forKey: defaultKey)
defaultStand.integer(forKey: defaultKey)
```

是不是感觉有点换汤不换药？上面使用常量存储 key 值，虽然能够保证存取的时候 key 值相同，但是在设置 key 值的时候稍显麻烦。

最重要的一点就是如果需要存很多账户信息或者配置信息的时候，按照这种方式都写在同一处地方就稍微欠妥，比如下面这个场景，在 app 启动后，需要存储用户信息和登录信息，用户信息里面包含: userName、avatar、password、gender等，登录信息里包含：token、userId、timeStamp等等，也就说需要存两类不同的信息，那么此时这种方式就不合时宜了，我们就会想办法把同类的信息归为一组，进行分组存取。

### 分组存储

分组存储 key 可以把存储数据按不同类别区分开，代码的可读性和可维护性大大提升. 我们可以采用类（class）、结构体（struct）、枚举（enum）来进行分组存储 key，下面使用结构体来示例。

```swift
// 账户信息
struct AccountInfo {
    let userName = "userName"
    let avatar = "avatar"
    let password = "password"
    let gender = "gender"
    let age = "age"
    
}
// 登录信息
struct LoginInfo {
    let token = "token"
    let userId = "userId"
}
// 配置信息
struct SettingInfo {
    let font = "font"
    let backgroundImage = "backgroundImage"
}
```

存取数据：

```swift
let defaultStand = UserDefaults.standard
// 账户信息
defaultStand.set("Chilli Cheng", forKey: AccountInfo().avatar)
defaultStand.set(18, forKey: AccountInfo().age)
// 登录信息
defaultStand.set("achj167", forKey: LoginInfo().token)
// 配置信息
defaultStand.set(24, forKey: SettingInfo().font)
        
let userName = defaultStand.string(forKey: AccountInfo().avatar)
let age = defaultStand.integer(forKey: AccountInfo().age)
let token = defaultStand.string(forKey: LoginInfo().token)
let font = defaultStand.integer(forKey: SettingInfo().font)
```

## 上下文

上面这种方式是不是比直接使用常量的效果更好？但是仍然有个问题：账户信息、登录信息、配置信息都是属于要存储的信息，那我们就可以把这三类信息归到一个大类里，在这个大类中有这三个小类，三个小类作为大类的属性，既能解决一致性问题，又能解决上下文的问题，需要存储到 UserDefaults 里面的数据，我只需要去特定的类中找到对应分组里面的属性即可。示例：

```swift
struct UserDefaultKeys {
    // 账户信息
    struct AccountInfo {
        let userName = "userName"
        let avatar = "avatar"
        let password = "password"
        let gender = "gender"
        let age = "age"
    }
    // 登录信息
    struct LoginInfo {
        let token = "token"
        let userId = "userId"
    }
    // 配置信息
    struct SettingInfo {
        let font = "font"
        let backgroundImage = "backgroundImage"
    }
}
```

存取数据：

```swift
let defaultStand = UserDefaults.standard
// 账户信息
defaultStand.set("Chilli Cheng", forKey:UserDefaultKeys.AccountInfo().userName)
defaultStand.string(forKey: UserDefaultKeys.AccountInfo().userName)
```

上面的代码看起来可读性好了很多，不仅是为了新接手的小伙伴能看懂，更是为了我们自己过段时间能看懂。我亲眼见过自己写的代码看不懂反而要进行重构的小伙伴。

## 避免初始化

但是上面的代码存在一个明显的缺陷，每次存取值的时候需要初始化 struct 出一个实例，再访问这个实例的属性获取 key 值，其实是不必要的，怎么才能做到不初始化实例就能访问属性呢？可以使用静态变量，直接通过类型名字访问属性的值。

```swift
struct AccountInfo {
    static let userName = "userName"
    static let avatar = "avatar"
    static let password = "password"
    static let gender = "gender"
    static let age = "age"
}
```

存取的时候：

```swift
defaultStand.set("Chilli Cheng", forKey: UserDefaultKeys.AccountInfo.userName)
defaultStand.string(forKey: UserDefaultKeys.AccountInfo.userName)
```

## 枚举分组存储

上面的方法虽然能基本满足要求，但是仍然不完美，我们依然需要手动去设置 key，当 key 值很多的时候，需要一个个的设置，那有没有可以一劳永逸的办法呢？不需要我们自己设置 key 的值，让系统默认给我们设置好 key 的初始值，我们直接拿 key 去进行存取数据。Swift 这么好的语言当然可以实现，即用枚举的方式，枚举不仅可以分组设置 key，还能默认设置 key 的原始值. 前提是我们需要遵守 String 协议，不设置 rawValue 的时候，系统会默认给我们的枚举 case 设置跟成员名字相同的原始值（rawValue），我们就可以拿这个 rawValue 来作为存取数据的 key。

```swift
struct UserDefaultKeys {
    // 账户信息
    enum AccountInfo: String {
        case userName
        case age
    }
}

// 存账户信息
defaultStand.set("Chilli Cheng", forKey: UserDefaultKeys.AccountInfo.userName.rawValue)
defaultStand.set(18, forKey: UserDefaultKeys.AccountInfo.age.rawValue)

// 取存账户信息
defaultStand.string(forKey: UserDefaultKeys.AccountInfo.userName.rawValue)
defaultStand.integer(forKey: UserDefaultKeys.AccountInfo.age.rawValue)
```

吼吼，是不是感觉很方便，Swift 太棒了！
上面基本就能达到我们的目的，既解决了一致性问题，又有上下文知道我存取数据使用的 key 的含义. 但是代码看起来很冗余，我不就需要一个key 嘛，干嘛非要链式调用那么多层呢？还有就是为啥我非要写 rawValue 呢？如果新来的小伙伴不知道 rawValue 是什么鬼肯定懵逼。

## 优化 key 值路径

虽然上面的代码能很好的达到目的，但是写法和使用上还是欠妥，我们仍需要继续改进，上面的代码主要存在两个问题：

- key 值路径太长
- rawValue 没必要写

我们先分析一下为什么会出现这个两个问题：  
key 值的路径长是因为我们想分组存储 key，让 key 具有上下文，可读性更改；  
rawValue 的作用是因为我们使用枚举来存储 key，就不需要去手动设置 key 的初始值。

看起来简直是”鱼和熊掌不能兼得“，有什么办法能解决”鱼和熊掌“的问题呢？

那就是”砍掉抓着鱼的熊掌“。也就是说我们必须先解决一个问题（先让熊抓鱼），再想法”砍熊掌“。

有了上面的一系列步骤，解决第一个问题并不像刚开始一样使用简单的字符串，而必须是使用枚举，在这个前提下去”抓鱼“. 也就是我能不能直接传枚举成员值进去，先利用枚举的 rawValue 解决第一个问题，例如这样使用：

```swift
defaultStand.set("Chilli Cheng", forKey: .userName)
defaultStand.string(forKey: .userName)
```

很明显能够实现，只要给 userDefaults 扩展自定义方法即可，在自定义方法中调用系统的方法进行存取，为了使用方便我们扩展类方法。示例：

```swift
extension UserDefaults {
    enum AccountKeys: String {
        case userName
        case age
    }

    static func set(value: String, forKey key: AccountKeys) {
        let key = key.rawValue
        UserDefaults.standard.set(value, forKey: key)
    }

    static func string(forKey key: AccountKeys) -> String? {
        let key = key.rawValue
        return UserDefaults.standard.string(forKey: key)
    }
}

// 存取数据
UserDefaults.set(value: "chilli cheng", forKey: .userName)
UserDefaults.string(forKey: .userName)
```
## 前置上下文

能实现上面的目的之一，但是没有上下文，既然在 key 那里不能加，换一个思路，那就在前面加，例如：

```swift
UserDefaults.AccountInfo.set(value: "chilli cheng", forKey: .userName)
UserDefaults.AccountInfo.string(forKey: .userName)
```

要实现上面的实现方式，需要扩展 UserDefaults，添加 AccountInfo 属性，再调用 AccountInfo 的方法，key 值由 AccountInfo 来提供，因为 AccountInfo 提供分组的 key，由于是自定义的一个分组信息，需要实现既定方法，必然想到用协议呀，毕竟 Swift 的协议很强大，Swift 就是面向协议编程的。

那我们先把自定义的方法抽取到协议中，额，但是协议不是只能提供方法声明，不提供方法实现吗? 谁说的? 站出来我保证不打死他! Swift 中可以对协议 protocol 进行扩展，提供协议方法的默认实现，如果遵守协议的类/结构体/枚举实现了该方法，就会覆盖掉默认的方法。

我们来试着实现一下，先写一个协议，提供默认的方法实现：

```swift
protocol UserDefaultsSettable {
    
}

extension UserDefaultsSettable {
    static func set(value: String, forKey key: AccountKeys) {
        let key = key.rawValue
        UserDefaults.standard.set(value, forKey: key)
    }
    static func string(forKey key: AccountKeys) -> String? {
        let key = key.rawValue
        return UserDefaults.standard.string(forKey: key)
    }
}
```

只要我的 AccountInfo 类/结构体/枚举遵守这个协议，就能调用存取方法了。但是，现在问题来了，也是至关重要的问题，AccountKeys 从哪儿来? 我们上面是把 AccountKeys 写在 UserDefaults 扩展里面的，在协议里面如何知道这个变量是什么类型呢？而且还使用到了 rawValue，为了通用性，那就需要在协议里关联类型，而且传入的值能拿到 rawValue，那么这个关联类型需要遵守 RawRepresentable 协议，这个很关键！！！

```swift
protocol UserDefaultsSettable {
    associatedtype defaultKeys: RawRepresentable
}

extension UserDefaultsSettable where defaultKeys.RawValue==String {
    static func set(value: String?, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    static func string(forKey key: defaultKeys) -> String? {
        let aKey = key.rawValue
        return UserDefaults.standard.string(forKey: aKey)
    }
}
```

> 必须在扩展中使用 where 子语句限制关联类型是字符串类型，因为 UserDefaults 的 key 就是字符串类型。   
> where defaultKeys.RawValue==String

在 UserDefaults 的扩展中定义分组 key：

```swift
extension UserDefaults {
    // 账户信息
    struct AccountInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case userName
            case age
        }
    }

    // 登录信息
    struct LoginInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case token
            case userId
        }
    }
}
```

存取数据：

```swift
UserDefaults.AccountInfo.set(value: "chilli cheng", forKey: .userName)
UserDefaults.AccountInfo.string(forKey: .userName)
        
UserDefaults.LoginInfo.set(value: "ahdsjhad", forKey: .token)
UserDefaults.LoginInfo.string(forKey: .token)
```

打完收工，既没有手动去写 key，避免了写错的问题，实现了 key 的一致性，又实现了上下文，能够直接明白 key 的含义。

# 后记

如果还有需要存储的分类数据，同样在 UserDefaults extension 中添加一个结构体，遵守 UserDefaultsSettable 协议，实现 defaultKeys 枚举属性，在枚举中设置该分类存储数据所需要的 key。

> 注意：UserDefaultsSettable 协议中只实现了存取 string 类型的数据，可以自行在 UserDefaultsSettable 协议中添加 Int、Bool 等类型方法，虽然这种用法前期比较费劲，但是不失为一种管理 UserDefaults 的比较好的方式。
> 如果大家有更好的方式，欢迎交流。

欢迎大家斧正！

最后编辑于 ：2018.05.17 10:18:40
©著作权归作者所有,转载或内容合作请联系作者

作者：跷脚啖牛肉
链接：https://www.jianshu.com/p/3796886b4953
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
