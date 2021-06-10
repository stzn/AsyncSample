//
//  UserView.swift
//  AsyncSample
//
//  Created by Shinzan Takata on 2021/04/26.
//

import SwiftUI

struct UserView: View {
    @ObservedObject var model: ConcurrentAsyncUserViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            if let user = model.user {
                Text("User").font(.title)
                Text("name: \(user.name)").font(.body)
                    .foregroundColor(model.isPremium ? Color.yellow : Color.black)
                Text("age: \(user.age)").font(.body)
            }
            if model.isLoading {
                ProgressView()
            }
            Button(action: {}) {
                Text("Tap")
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .buttonStyle(ShrinkButtonStyle())
            Button("Load", action: { model.getUserInfo() })
                .disabled(model.isLoading)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(model: ConcurrentAsyncUserViewModel())
    }
}

struct ShrinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        let isPressed = configuration.isPressed
        return configuration.label
            .scaleEffect(x: isPressed ? 0.7 : 1, y: isPressed ? 0.7 : 1, anchor: .center)
            .animation(.spring(response: 0.2, dampingFraction: 0.9, blendDuration: 0))
    }
}
