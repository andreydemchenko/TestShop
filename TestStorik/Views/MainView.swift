//
//  MainView.swift
//  TestStorik
//
//  Created by andreydem on 14.03.2023.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    @ObservedObject var coordinator: MainCoordinator
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        let tabBarItems = [
            MainCoordinator.Navigation.home(viewModel.homeViewModel),
            MainCoordinator.Navigation.favorites,
            MainCoordinator.Navigation.cart,
            MainCoordinator.Navigation.chat,
            MainCoordinator.Navigation.profile(viewModel.profileViewModel ?? ProfileViewModel(userSubject: viewModel.userSubject))
        ]
        
        let tabViews = ForEach(tabBarItems.indices, id: \.self) { index in
            NavigationView {
                tabBarItems[index].destinationView
            }
            .tag(index)
        }
        
        let tabView = TabView(selection: $selectedIndex) {
            tabViews
        }
        .onChange(of: selectedIndex) { index in
            coordinator.navigate(to: tabBarItems[index])
        }
        
        let customTabBar = HStack {
            ForEach(tabBarItems.indices, id: \.self) { index in
                CustomTabItem(selection: index, imageName: tabBarItems[index].imageName, isSelected: Binding(get: {
                    selectedIndex == index
                }, set: { isSelected in
                    selectedIndex = index
                    coordinator.navigate(to: tabBarItems[index])
                }), selectedIndex: $selectedIndex)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 50)
        .padding(.top, 40)
        .background(Color.white)
        .cornerRadius(30, corners: [.topLeft, .topRight])
        .edgesIgnoringSafeArea(.bottom)
        
        return ZStack(alignment: .bottom) {
            tabView
            customTabBar
        }
        .ignoresSafeArea()
    }
}

struct CustomTabItem: View {
    var selection: Int
    var imageName: String
    @Binding var isSelected: Bool
    @Binding var selectedIndex: Int
    
    var body: some View {
        Button(action: {
            isSelected = true
            selectedIndex = selection
        }, label: {
            ZStack {
                Circle()
                    .foregroundColor(isSelected ? CustomColor.primaryColor : .clear)
                    .frame(width: 40, height: 40)
                    .zIndex(0)
                Image(imageName)
                    .renderingMode(.template)
                    .frame(width: 18, height: 18)
                    .zIndex(1)
                    .foregroundColor(isSelected ? CustomColor.secondaryColor : .gray)
            }
        })
        .padding(.bottom, 50)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
