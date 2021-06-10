//
//  UserViewModel.swift
//  AsyncSample
//
//  Created by Shinzan Takata on 2021/04/26.
//

import SwiftUI

final class SyncUserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false

    var isPremium: Bool { user?.isPremium ?? false }

    func getUserInfo() {
        isLoading = true
        user = nil
        let id = getUserId()
        let name = getUserName(id: id)
        let age = getUserAge(id: id)
        let isPremium = getUserIsPremium(id: id)
        self.user = User(id: id,
                         name: name,
                         age: age,
                         isPremium: isPremium)
        isLoading = false
    }

    func getUserId() -> UserID {
        sleep(2)
        return UUID()
    }

    func getUserName(id: UserID) -> String {
        sleep(2)
        return "User Name"
    }

    func getUserAge(id: UserID) -> Int {
        sleep(2)
        return 20
    }

    func getUserIsPremium(id: UserID) -> Bool {
        sleep(2)
        return true
    }

}

final class DispatchUserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false

    var isPremium: Bool { user?.isPremium ?? false }

    func getUserInfo() {
        isLoading = true
        user = nil
        getUserId { [weak self] id in
            self?.getUserName(id: id) { [weak self] name in
                self?.getUserAge(id: id) { [weak self] age in
                    self?.getUserIsPremium(id: id) { isPremium in
                        DispatchQueue.main.async { [weak self] in
                            self?.user = User(id: id,
                                              name: name,
                                              age: age,
                                              isPremium: isPremium)
                            self?.isLoading = false
                        }
                    }
                }
            }
        }
    }

    func getUserId(completion: @escaping (UserID) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            completion(UUID())
        }
    }

    func getUserName(id: UserID, completion: @escaping (String) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            completion("User Name")
        }
    }

    func getUserAge(id: UserID, completion: @escaping (Int) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            completion(20)
        }
    }

    func getUserIsPremium(id: UserID, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            completion(true)
        }
    }
}

final class AsyncUserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false

    var isPremium: Bool { user?.isPremium ?? false }

    func getUserInfo() {
        isLoading = true
        user = nil
        asyncDetached { @MainActor in
            let id = await getUserId()
            let name = await getUserName(id: id)
            let age = await getUserAge(id: id)
            let isPremium = await getUserIsPremium(id: id)
            user = User(id: id, name: name, age: age, isPremium: isPremium)
            isLoading = false
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

final class DispatchGroupUserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false

    var isPremium: Bool { user?.isPremium ?? false }

    func getUserInfo() {
        isLoading = true
        user = nil

        let group = DispatchGroup()
        getUserId { [weak self] id in
            var name = ""
            var age = 0
            var isPremium = false

            self?.getUserName(id: id, group: group) { name = $0 }
            self?.getUserAge(id: id, group: group) { age = $0 }
            self?.getUserIsPremium(id: id, group: group) { isPremium = $0 }
            group.notify(queue: .main) { [weak self] in
                self?.user = User(id: id,
                                  name: name,
                                  age: age,
                                  isPremium: isPremium)
                self?.isLoading = false
            }
        }
    }

    func getUserId(completion: @escaping (UserID) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            completion(UUID())
        }
    }

    func getUserName(id: UserID, group: DispatchGroup, completion: @escaping (String) -> Void) {
        group.enter()
        DispatchQueue.global().async(group: group) {
            sleep(2)
            group.leave()
            completion("User Name")
        }
    }

    func getUserAge(id: UserID, group: DispatchGroup, completion: @escaping (Int) -> Void) {
        group.enter()
        DispatchQueue.global().async(group: group) {
            sleep(2)
            group.leave()
            completion(20)
        }
    }

    func getUserIsPremium(id: UserID, group: DispatchGroup, completion: @escaping (Bool) -> Void) {
        group.enter()
        DispatchQueue.global().async(group: group) {
            sleep(2)
            group.leave()
            completion(true)
        }
    }
}

final class ConcurrentAsyncUserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false

    var isPremium: Bool { user?.isPremium ?? false }

    func getUserInfo() {
        isLoading = true
        user = nil
        async { @MainActor in
            let id = await getUserId()
            async let name = getUserName(id: id)
            async let age = getUserAge(id: id)
            async let isPremium = getUserIsPremium(id: id)
            user = await User(id: id, name: name, age: age, isPremium: isPremium)
            isLoading = false
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

