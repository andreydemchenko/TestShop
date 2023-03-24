//
//  FavoritesView.swift
//  TestStorik
//
//  Created by andreydem on 16.03.2023.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        ZStack {
            CustomColor.baseColor
                .ignoresSafeArea()
            
            Text("FavoritesView")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
