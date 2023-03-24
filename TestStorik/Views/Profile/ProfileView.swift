//
//  ProfileView.swift
//  TestStorik
//
//  Created by andreydem on 15.03.2023.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel: ProfileViewModel
    @State private var isShowingImagePicker = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Text("Profile")
                    .font(.boldMontserratFont(size: 16))
                VStack(alignment: .center) {
                    profileImage
                    changePhotoButton
                }
                Text(viewModel.name)
                    .font(.boldMontserratFont(size: 16))
                    .padding(10)
                uploadItemButton
                    .padding(10)
                VStack(spacing: 20) {
                    tradeStoreBlock
                    paymentMethodBlock
                    balanceBlock
                    tradeHistoryBlock
                    restorePurchaseBlock
                    helpBlock
                    logOutBlock
                }
            }
            .padding()
        }
        .background(CustomColor.baseColor)
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: self.$viewModel.profileImage)
        }
        
    }
    
    private var profileImage: some View {
        VStack {
            if let image = viewModel.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            } else {
                Image("person_image")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
        }
        .onTapGesture {
            self.isShowingImagePicker.toggle()
        }
    }
    
    private var changePhotoButton: some View {
        Button(action: {
            self.isShowingImagePicker.toggle()
        }) {
            Text("Change photo")
                .font(.montserratFont(size: 9))
                .foregroundColor(CustomColor.grayColor)
        }
        
    }
    
    private var uploadItemButton: some View {
        Button(action: {
            viewModel.uploadItem()
        }) {
            HStack {
                Image("ico_upload")
                Text("Upload item")
                    .font(.boldMontserratFont(size: 14))
                    .padding(.leading)
                    .padding(.trailing, 30)
            }
            .frame(height: 10)
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white.opacity(0.9))
            .background(CustomColor.blueColor)
            .cornerRadius(16)
        }
    }
    
    private var tradeStoreBlock: some View {
        BlockView(icon: "ico_store", heading: "Trade Store", isChevronOnLeft: true, onTap: viewModel.restorePurchaseTapped)
    }
    
    private var paymentMethodBlock: some View {
        BlockView(icon: "ico_store", heading: "Payment Method", isChevronOnLeft: true, onTap: viewModel.paymentMethodTapped)
    }
    
    private var balanceBlock: some View {
        BlockView(icon: "ico_store", heading: "Balance", onTap: viewModel.balanceTapped, balance: "$\(viewModel.balance.removeZerosInTheFractionPart)")
    }
    
    private var tradeHistoryBlock: some View {
        BlockView(icon: "ico_store", heading: "Trade History", isChevronOnLeft: true, onTap: viewModel.tradeHistoryTapped)
    }
    
    private var restorePurchaseBlock: some View {
        BlockView(icon: "ico_restore", heading: "Restore Purchase", isChevronOnLeft: true, onTap: viewModel.restorePurchaseTapped)
    }
    
    private var helpBlock: some View {
        BlockView(icon: "ico_help", heading: "Help", onTap: viewModel.helpTapped)
    }
    
    private var logOutBlock: some View {
        BlockView(icon: "ico_exit", heading: "Log Out", onTap: viewModel.logOutTapped)
    }
    
    struct BlockView: View {
        let icon: String
        let heading: String
        let onTap: () -> Void
        let isChevronOnLeft: Bool
        let balance: String?
        
        init(icon: String, heading: String, isChevronOnLeft: Bool = false, onTap: @escaping () -> Void, balance: String? = nil) {
            self.icon = icon
            self.heading = heading
            self.isChevronOnLeft = isChevronOnLeft
            self.onTap = onTap
            self.balance = balance
        }
        
        var body: some View {
            Button(action: {
                self.onTap()
            }) {
                HStack {
                    Image(icon)
                        .foregroundColor(.black)
                    Text(heading)
                        .font(.montserratFont(size: 14))
                        .foregroundColor(.black)
                    if balance != nil {
                        Spacer()
                        Text(balance!)
                            .foregroundColor(.black)
                            .font(.montserratFont(size: 14))
                    } else if isChevronOnLeft {
                        Spacer()
                        Image("ico_arrow")
                            .foregroundColor(.black)
                    } else {
                        Spacer()
                    }
                }
                .padding([.leading, .trailing], 20)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(userSubject: AppCoordinator.userSubject))
    }
}
