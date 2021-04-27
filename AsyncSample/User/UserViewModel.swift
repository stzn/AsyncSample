//
//  UserViewModel.swift
//  AsyncSample
//
//  Created by Shinzan Takata on 2021/04/26.
//

import SwiftUI

final class UserViewModel: ObservableObject {
    private let queue = DispatchQueue(label: "shiz.sample.UserViewModel", attributes: .concurrent)

    @Published var user: User?

    func getUserInfo() {
        getUserId { [weak self] id in
            self?.getUserName(id: id) { [weak self] name in
                self?.getUserAge(id: id) { [weak self] age in
                    self?.getIsPremium(id: id) { isPremium in
                        DispatchQueue.main.async { [weak self] in
                            self?.user = User(id: id,
                                              name: name,
                                              age: age,
                                              isPremium: isPremium)
                        }
                    }
                }
            }
        }
    }

    func getUserId(completion: @escaping (UserID) -> Void) {
        queue.asyncAfter(deadline: .now() + 2.0) {
            completion(UUID())
        }
    }

    func getUserName(id: UserID, completion: @escaping (String) -> Void) {
        queue.asyncAfter(deadline: .now() + 2.0) {
            completion("User Name")
        }
    }

    func getUserAge(id: UserID, completion: @escaping (Int) -> Void) {
        queue.asyncAfter(deadline: .now() + 2.0) {
            completion(20)
        }
    }

    func getIsPremium(id: UserID, completion: @escaping (Bool) -> Void) {
        queue.asyncAfter(deadline: .now() + 2.0) {
            completion(true)
        }
    }

}

final class AsyncUserViewModel: ObservableObject {
    @Published var user: User?

    var taskHandle: Task.Handle<Void, Error>?

    deinit {
        taskHandle?.cancel()
    }

    func getUserInfo() {
        taskHandle = detach {
            let id = await self.getUserId()
            let name = await self.getUserName(id: id)
            let age = await self.getUserAge(id: id)
            let isPremium = await self.getUserIsPremium(id: id)

            await MainActor.run {
                self.user = User(id: id, name: name, age: age, isPremium: isPremium)
            }
        }
    }

    func getUserId() async -> UserID {
        await withUnsafeContinuation { continuation in
            getUserId { continuation.resume(returning: $0) }
        }
    }

    func getUserName(id: UserID) async -> String {
        await withUnsafeContinuation { continuation in
            getUserName(id: id) { continuation.resume(returning: $0) }
        }
    }

    func getUserAge(id: UserID) async -> Int {
        await withUnsafeContinuation { continuation in
            getUserAge(id: id) { continuation.resume(returning: $0) }
        }
    }

    func getUserIsPremium(id: UserID) async -> Bool {
        await withUnsafeContinuation { continuation in
            getUserIsPremium(id: id) { continuation.resume(returning: $0) }
        }
    }

    func getUserId(completion: @escaping (UserID) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(UUID())
        }
    }

    func getUserName(id: UserID, completion: @escaping (String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion("User Name")
        }
    }

    func getUserAge(id: UserID, completion: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(20)
        }
    }

    func getUserIsPremium(id: UserID, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(true)
        }
    }

    func getIsPremium(id: UserID, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(true)
        }
    }
}

