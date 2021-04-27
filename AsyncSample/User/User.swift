//
//  User.swift
//  AsyncSample
//
//  Created by Shinzan Takata on 2021/04/24.
//

import Foundation

typealias UserID = UUID
struct User {
    let id: UserID
    let name: String
    let age: Int
    let isPremium: Bool
}
