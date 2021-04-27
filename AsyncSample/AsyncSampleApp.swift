//
//  AsyncSampleApp.swift
//  AsyncSample
//
//  Created by Shinzan Takata on 2021/04/24.
//

import SwiftUI

struct AsyncUserSampleApp: App {
    var body: some Scene {
        WindowGroup {
            UserView(model: AsyncUserViewModel())
        }
    }
}

@main
struct AsyncTodoSampleApp: App {
    var body: some Scene {
        WindowGroup {
            TodoView(model: TodoViewModel(loader: loadTodo))
        }
    }
}
