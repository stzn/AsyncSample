//
//  TodoViewModel.swift
//  AsyncSample
//
//  Created by Shinzan Takata on 2021/04/26.
//

import SwiftUI

final class TodoViewModel: ObservableObject {
    @Published var todo: Todo?
    @Published var isLoading: Bool = false

    private let loader: TodoLoader
    init(loader: @escaping TodoLoader) {
        self.loader = loader
    }

    func getTodo() {
        todo = nil
        isLoading = true
        async { @MainActor in
            let loadedTodo = try? await self.loader()
            todo = loadedTodo
            isLoading = false
        }
    }
}
