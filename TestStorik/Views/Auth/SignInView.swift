//
//  SignInView.swift
//  TestStorik
//
//  Created by andreydem on 11.03.2023.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: AuthViewModel
    @ObservedObject var coordinator: AuthCoordinator
    @FocusState private var isEmailFieldFocused: Bool
    @FocusState private var isPasswordFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Spacer(minLength: 10)
            Text("Welcome back")
                .font(.montserratFont(size: 28))
                .padding()
                .padding(.bottom, 40)
            ZStack(alignment: .center) {
                if viewModel.email.isEmpty {
                    Text("Email")
                        .font(.montserratFont(size: 12))
                        .foregroundColor(CustomColor.grayColor)
                        .multilineTextAlignment(.center)
                        .zIndex(1)
                        .onTapGesture {
                            isEmailFieldFocused = true
                        }
                }
                
                TextField("", text: $viewModel.email)
                    .onChange(of: viewModel.email) { _ in
                        viewModel.validateEmail()
                    }
                    .focused($isEmailFieldFocused)
                    .padding(.horizontal, 10)
                    .font(.montserratFont(size: 12))
                    .frame(height: 30)
                    .background(CustomColor.fieldColor)
                    .multilineTextAlignment(.center)
                    .cornerRadius(20)
                    .keyboardType(.emailAddress)
                    .zIndex(0)
            }
            HStack {
                if viewModel.showSignInPassword {
                    ZStack(alignment: .center) {
                        if viewModel.password.isEmpty {
                            Text("Password")
                                .font(.montserratFont(size: 12))
                                .padding(.leading, 25)
                                .foregroundColor(CustomColor.grayColor)
                                .multilineTextAlignment(.center)
                                .zIndex(1)
                                .onTapGesture {
                                    isPasswordFieldFocused = true
                                }
                        }
                        
                        TextField("", text: $viewModel.password)
                            .onChange(of: viewModel.password) { _ in
                                viewModel.validatePassword()
                            }
                            .focused($isPasswordFieldFocused)
                            .padding(.horizontal, 10)
                            .font(.montserratFont(size: 12))
                            .multilineTextAlignment(.center)
                            .foregroundColor(CustomColor.grayColor)
                            .background(CustomColor.fieldColor)
                            .cornerRadius(20)
                            .zIndex(0)
                    }
                } else {
                    ZStack(alignment: .center) {
                        if viewModel.password.isEmpty {
                            Text("Password")
                                .font(.montserratFont(size: 12))
                                .foregroundColor(CustomColor.grayColor)
                                .multilineTextAlignment(.center)
                                .padding(.leading, 25)
                                .zIndex(1)
                                .onTapGesture {
                                    isPasswordFieldFocused = true
                                }
                        }
                        SecureField("", text: $viewModel.password)
                            .onChange(of: viewModel.password) { _ in
                                viewModel.validatePassword()
                            }
                            .focused($isPasswordFieldFocused)
                            .padding(.horizontal, 10)
                            .font(.montserratFont(size: 12))
                            .multilineTextAlignment(.center)
                            .background(CustomColor.fieldColor)
                            .cornerRadius(20)
                            .zIndex(0)
                    }
                }
                Button(action: {
                    viewModel.toggleShowSignInPassword()
                }, label: {
                    Image(systemName: viewModel.showSignInPassword ? "eye" : "eye.slash")
                        .resizable()
                        .frame(width: 18, height: 14)
                        .foregroundColor(CustomColor.grayColor)
                })
            }
            .padding()
            .background(CustomColor.fieldColor)
            .frame(height: 30)
            .cornerRadius(20)
            .padding(.bottom, 30)
            VStack(spacing: -8) {
                Button(action: {
                    if viewModel.emailError.isEmpty && viewModel.passwordError.isEmpty {
                        viewModel.clearErrors()
                        viewModel.signIn()
                    }
                }, label: {
                    Text("Login")
                        .font(.boldMontserratFont(size: 16))
                        .foregroundColor(.white)
                })
                .frame(maxWidth: .infinity)
                .padding()
                .background(CustomColor.blueColor)
                .cornerRadius(16)
                .padding(.top, 20)
                Text(viewModel.errorMessage)
                    .font(.montserratFont(size: 12))
                    .foregroundColor(.red)
                    .padding()
                HStack {
                    Text("Don't have an account?")
                        .font(.montserratFont(size: 12))
                        .foregroundColor(CustomColor.grayColor)
                    Button(action: {
                        viewModel.clearFields()
                        viewModel.clearErrors()
                        coordinator.navigate(to: .signUp)
                    }, label: {
                        Text("Sign Up")
                            .font(.montserratFont(size: 12))
                            .foregroundColor(CustomColor.blueColor)
                    })
                    Spacer()
                }
            }
            Spacer()
        }
        .padding(30)
        .background(CustomColor.baseColor)
        .ignoresSafeArea()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: AuthViewModel(authService: AuthService()), coordinator: AuthCoordinator())
    }
}
