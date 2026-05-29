//
//  SignupView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/28/26.
//

import SwiftUI


struct SignupView: View {
    @State private var viewModel = ViewModel()
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    var isValid: Bool {
        4...16 ~= username.count && 8...24 ~= password.count && password == confirmPassword
    }
    @Environment(\.dismiss) private var dismiss

    var body: some View {
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

                SecureField("비밀번호 확인", text: $confirmPassword)
                    .padding(.horizontal)
                    .frame(minHeight: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(.tertiarySystemBackground))
                    )
            }


            Button(action: {
                Task {
                    let result = await viewModel.signUp(username: username, password: password)
                    if result { dismiss() }
                }
            }) {
                Text("회원가입")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isValid ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(25)
            }
            .disabled(!isValid)
            .padding(.top, 8)

            Spacer()
        }
        .padding()
        .navigationTitle("회원가입")
        .background(Color(.secondarySystemBackground))
    }
}

