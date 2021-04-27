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
        if let user = model.user {
            GeometryReader { proxy in
                VStack(alignment: .center) {
                    Text("User").font(.title)
                    Text("name: \(user.name)").font(.body)
                    Text("age: \(user.age)").font(.body)
                }
                .frame(width: proxy.size.width)
                .background(user.isPremium ? Color.yellow : Color.blue)
            }
        } else {
            Text("Loading...").onAppear {
                model.getUserInfo()
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(model: AsyncUserViewModel())
    }
}
