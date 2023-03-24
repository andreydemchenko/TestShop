//
//  SignInView.swift
//  TestStorik
//
//  Created by andreydem on 11.03.2023.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    @ObservedObject var coordinator: AuthCoordinator
    @FocusState private var isFirstNameFieldFocused: Bool
    @FocusState private var isLastNameFieldFocused: Bool
    @FocusState private var isEmailFieldFocused: Bool
    @FocusState private var isPasswordFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer(minLength: 20)
            Text("Sign Up")
                .font(.montserratFont(size: 28))
                .padding()
                .padding(.bottom, 40)
            VStack(alignment: .center, spacing: 10) {
                ZStack(alignment: .center) {
                    if viewModel.firstName.isEmpty {
                        Text("First name")
                            .font(.montserratFont(size: 12))
                            .foregroundColor(CustomColor.grayColor)
                            .multilineTextAlignment(.center)
                            .zIndex(1)
                            .onTapGesture {
                                isFirstNameFieldFocused = true
                            }
                    }
                    
                    TextField("", text: $viewModel.firstName)
                        .onChange(of: viewModel.firstName) { _ in
                            viewModel.validateFirstName()
                        }
                        .focused($isFirstNameFieldFocused)
                        .font(.montserratFont(size: 12))
                        .frame(height: 30)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .background(CustomColor.fieldColor)
                        .cornerRadius(20)
                        .zIndex(0)
                }
                Text(viewModel.firstNameError)
                    .font(.montserratFont(size: 12))
                    .foregroundColor(.red)
                ZStack(alignment: .center) {
                    if viewModel.lastName.isEmpty {
                        Text("Last name")
                            .font(.montserratFont(size: 12))
                            .foregroundColor(CustomColor.grayColor)
                            .multilineTextAlignment(.center)
                            .zIndex(1)
                            .onTapGesture {
                                isLastNameFieldFocused = true
                            }
                    }
                    
                    TextField("", text: $viewModel.lastName)
                        .onChange(of: viewModel.lastName) { _ in
                            viewModel.validateLastName()
                        }
                        .focused($isLastNameFieldFocused)
                        .font(.montserratFont(size: 12))
                        .frame(height: 30)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .background(CustomColor.fieldColor)
                        .cornerRadius(20)
                        .zIndex(0)
                }
                Text(viewModel.lastNameError)
                    .font(.montserratFont(size: 12))
                    .foregroundColor(.red)
                VStack(spacing: 10) {
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
                            .font(.montserratFont(size: 12))
                            .frame(height: 30)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .background(CustomColor.fieldColor)
                            .cornerRadius(20)
                            .keyboardType(.emailAddress)
                            .zIndex(0)
                    }
                    Text(viewModel.emailError)
                        .font(.montserratFont(size: 12))
                        .foregroundColor(.red)
                    HStack {
                        if viewModel.showSignUpPassword {
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
                                    .font(.montserratFont(size: 12))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .background(CustomColor.fieldColor)
                                    .cornerRadius(20)
                                    .zIndex(0)
                            }
                        } else {
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
                                SecureField("", text: $viewModel.password)
                                    .onChange(of: viewModel.password) { _ in
                                        viewModel.validatePassword()
                                    }
                                    .focused($isPasswordFieldFocused)
                                    .font(.montserratFont(size: 12))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .background(CustomColor.fieldColor)
                                    .cornerRadius(20)
                                    .zIndex(0)
                            }
                        }
                        Button(action: {
                            viewModel.toggleShowSignUpPassword()
                        }, label: {
                            Image(systemName: viewModel.showSignUpPassword ? "eye" : "eye.slash")
                                .resizable()
                                .frame(width: 18, height: 14)
                                .foregroundColor(CustomColor.grayColor)
                        })
                    }
                    .padding()
                    .background(CustomColor.fieldColor)
                    .frame(height: 30)
                    .cornerRadius(20)
                }
                Text(viewModel.passwordError)
                    .font(.montserratFont(size: 12))
                    .foregroundColor(.red)
            }
            Text(viewModel.errorMessage)
                .font(.montserratFont(size: 12))
                .foregroundColor(.red)
            Button(action: {
                if viewModel.validateInputFields() {
                    viewModel.clearErrors()
                    viewModel.signUp()
                }
            }, label: {
                Text("Sign Up")
                    .font(.boldMontserratFont(size: 16))
                    .foregroundColor(.white)
            })
            .frame(maxWidth: .infinity)
            .padding()
            .background(CustomColor.blueColor)
            .cornerRadius(16)
            .padding(.top, 20)
            HStack {
                Text("Already have an account?")
                    .font(.montserratFont(size: 12))
                    .foregroundColor(CustomColor.grayColor)
                Button(action: {
                    viewModel.clearFields()
                    viewModel.clearErrors()
                    coordinator.navigate(to: .signIn)
                }, label: {
                    Text("Log In")
                        .font(.montserratFont(size: 12))
                        .foregroundColor(CustomColor.blueColor)
                })
                Spacer()
            }
            .padding(.top, 10)
            Spacer()
            Button(action: {
                // Handle sign-in with Google
            }, label: {
                HStack(spacing: 1) {
                    Image("googlelogo")
                        .foregroundColor(.black)
                    Text("Sign in with Google")
                        .font(.montserratFont(size: 14))
                        .foregroundColor(.black)
                        .padding()
                }
            })
            Button(action: {
                // Handle sign-in with Apple
            }, label: {
                HStack(spacing: 1) {
                    Image("applelogo")
                        .foregroundColor(.black)
                    Text("Sign in with Apple ")
                        .font(.montserratFont(size: 14))
                        .foregroundColor(.black)
                        .padding()
                }
            })
            Spacer()
        }
        .padding(30)
        .background(CustomColor.baseColor)
        .ignoresSafeArea()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: AuthViewModel(authService: AuthService()), coordinator: AuthCoordinator())
    }
}
