//
//  CartView.swift
//  TestStorik
//
//  Created by andreydem on 16.03.2023.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        ZStack {
            CustomColor.baseColor
                .ignoresSafeArea()
            
            Text("CartView")
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
