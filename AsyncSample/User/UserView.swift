//
//  UserView.swift
//  AsyncSample
//
//  Created by Shinzan Takata on 2021/04/26.
//

import SwiftUI

struct UserView: View {
    @ObservedObject var model: AsyncUserViewModel

    var body: some View {
        VStack(alignment: .center) {
            if let user = model.user {
                Text("User").font(.title)
                Text("name: \(user.name)").font(.body)
                Text("age: \(user.age)").font(.body)
            }
            if model.isLoading {
                ProgressView()
            }
            Button("Tap", action: { })
            Button("Load", action: { model.getUserInfo() })
                .disabled(model.isLoading)
        }
        .background(model.isPremium ? Color.yellow : Color.clear)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(model: AsyncUserViewModel())
    }
}
