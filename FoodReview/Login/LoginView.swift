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
                    TextField("유저 아이디", text: $username)
                        .keyboardType(.asciiCapable)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.horizontal)
                        .frame(minHeight: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color(.tertiarySystemBackground))
                        )
                    
                    SecureField("비밀번호", text: $password)
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
                        } else {
                            Text("로그인")
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
                    Text("계정이 없으신가요?")
                        .foregroundColor(.secondary)
                    
                    NavigationLink(destination: SignupView()) {
                        Text("회원가입")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 16)
            }
            .padding()
            .navigationTitle("로그인")
        }
    }
}


#Preview {
    LoginView()
}
