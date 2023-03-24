//
//  ChatView.swift
//  TestStorik
//
//  Created by andreydem on 16.03.2023.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        ZStack {
            CustomColor.baseColor
                .ignoresSafeArea()
            Text("ChatView")
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
