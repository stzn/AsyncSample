//
//  TodoLoader.swift
//  AsyncSample
//
//  Created by Shinzan Takata on 2021/04/26.
//

import Foundation

typealias TodoLoader = () async throws -> Todo

func loadTodo() async throws -> Todo {
    struct NoDataError: Error {}

    let list = try await fetchTodoList()
    guard let id = list.first?.id else {
        throw NoDataError()
    }
    return try await fetchTodoDetail(id: id)
}

func request(_ url: URL) async throws -> Data {
    struct NetworkError: Error {}

    return try await withUnsafeThrowingContinuation { (continuation) in
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            switch (data, error) {
            case let (_, error?):
                return continuation.resume(throwing: error)
            case let (data?, _):
                return continuation.resume(returning: data)
            case (nil, nil):
                return continuation.resume(throwing: NetworkError())
            }
        }
        .resume()
    }
}

func fetchTodoList() async throws -> [Todo] {
    let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
    let data = try await request(url)
    return try JSONDecoder().decode([Todo].self, from: data)
}

func fetchTodoDetail(id: Int) async throws -> Todo {
    let url = URL(string: "https://jsonplaceholder.typicode.com/todos/\(id)")!
    let data = try await request(url)
    return try JSONDecoder().decode(Todo.self, from: data)
}

