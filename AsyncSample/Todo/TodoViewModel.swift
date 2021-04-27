//
//  TodoViewModel.swift
//  AsyncSample
//
//  Created by Shinzan Takata on 2021/04/26.
//

import SwiftUI

final class TodoViewModel: ObservableObject {
    @Published var todo: Todo?

    private let loader: TodoLoader
    init(loader: @escaping TodoLoader) {
        self.loader = loader
    }

    func getTodo() {
        detach {
            let todo = try await self.loader()
            await MainActor.run {
                self.todo = todo
            }
        }
    }
}
