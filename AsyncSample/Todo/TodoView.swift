//
//  TodoView.swift
//  AsyncSample
//
//  Created by Shinzan Takata on 2021/04/25.
//

import SwiftUI

struct TodoView: View {
    @ObservedObject var model: TodoViewModel

    var body: some View {
        VStack(spacing: 12) {
            if let todo = model.todo {
                VStack(alignment: .leading) {
                    Text("Title: \(todo.title)")
                    Text("Completed: \(todo.completed ? "Yes" : "No")")
                }
            }
            if model.isLoading {
                ProgressView()
            }
            HStack(spacing: 8) {
                Button("Tap", action: { })
                Button("Load", action: { model.getTodo() })
                    .disabled(model.isLoading)
            }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView(model: TodoViewModel(loader: { Todo(id: 1, title: "todo", completed: false) }))
    }
}
