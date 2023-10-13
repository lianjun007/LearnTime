//
//  LearnTimeApp.swift
//  LearnTime
//
//  Created by LianJun on 2023/10/13.
//

import SwiftUI
import SwiftData

@main
struct LearnTimeApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
