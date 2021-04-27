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
        if let todo = model.todo {
            VStack {
                Text("Title: \(todo.title)")
                Text("Completed: \(todo.completed ? "Yes" : "No")")
            }
        } else {
            Text("Loading...").onAppear {
                model.getTodo()
            }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView(model: TodoViewModel(loader: { Todo(id: 1, title: "todo", completed: false) }))
    }
}
