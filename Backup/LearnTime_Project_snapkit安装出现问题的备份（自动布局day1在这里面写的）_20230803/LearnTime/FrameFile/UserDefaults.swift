
import Foundation

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

extension UserDefaults {
    // 设置信息
    struct SettingInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            /// 阅读文章界面的主体风格设置（`textrue、style、gorgeous`）
            case essayTheme
            /// 阅读文章界面的代码块的序号行设置（`true、false`）
            case essayCodeNumber
            /// 阅读文章界面的代码块的前后空行是否去除功能（`true、false`）
            case essayCodeFristAndList
            /// 阅读文章界面文本单词是否分行显示（`true、false`）
            case essayTextRow
        }
    }
}

/// 默认设置的初始化，放在第一个界面中调用即可
func initializeUserDefaults() {
    // 默认文章显示模式为“texture”，质感
    if UserDefaults.SettingInfo.string(forKey: .essayTheme) == nil {
        UserDefaults.SettingInfo.set(value: "texture", forKey: .essayTheme)
    }
    // 默认文章代码块显示模式为“true”，显示
    if UserDefaults.SettingInfo.string(forKey: .essayCodeNumber) == nil {
        UserDefaults.SettingInfo.set(value: "true", forKey: .essayCodeNumber)
    }
    // 默认文章代码块前后空行是否去除为“true”，去除
    if UserDefaults.SettingInfo.string(forKey: .essayCodeFristAndList) == nil {
        UserDefaults.SettingInfo.set(value: "true", forKey: .essayCodeFristAndList)
    }
    // 默认文章文本单词不分行显示为“true”，是（以单词换行）
    if UserDefaults.SettingInfo.string(forKey: .essayTextRow) == nil {
        UserDefaults.SettingInfo.set(value: "true", forKey: .essayTextRow)
    }
}
