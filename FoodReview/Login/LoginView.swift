//
//  LoginView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/28/26.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = ViewModel()
    @State private var username = ""
    @State private var password = ""
    var isValid: Bool {
        4...16 ~= username.count && 8...24 ~= password.count
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                VStack(spacing: 16) {
                    TextField("Username", text: $username)
                        .keyboardType(.asciiCapable)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.horizontal)
                        .frame(minHeight: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color(.tertiarySystemBackground))
                        )
                    
                    SecureField("Password", text: $password)
                        .padding(.horizontal)
                        .frame(minHeight: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color(.tertiarySystemBackground))
                        )
                }
                
                Button(action: {
                    Task {
                        let result = await viewModel.logIn(username: username, password: password)
                        if result { dismiss() }
                    }
                    
                }) {
                    Group{
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Log In")
                                .font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isValid ? Color.blue: Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                }
                .disabled(!isValid)
                .padding(.top, 8)
                
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.secondary)
                    
                    NavigationLink(destination: SignupView()) {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 16)
            }
            .padding()
            .navigationTitle("Log In")
        }
    }
}


#Preview {
    LoginView()
}
