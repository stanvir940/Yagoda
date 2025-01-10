//
//  AuthenticationView.swift
//  Yagoda
//
//  Created by Tanvir Ahmed on 3/1/25.
//

import Foundation
import SwiftUI
import FirebaseAuth


struct ToastView: View {
    let message: String
    let isError: Bool

    var body: some View {
        Text(message)
            .font(.body)
            .foregroundColor(.white)
            .padding()
            .background(isError ? Color.red : Color.green)
            .cornerRadius(8)
            .shadow(radius: 5)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .transition(.opacity)
    }
}
struct AuthenticationView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn = false
    @State private var isAdmin = false

    @State private var toastMessage: String = ""
    @State private var showToast: Bool = false
    @State private var isError: Bool = false

    var body: some View {
        NavigationStack{
            VStack {
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                Button(action: login) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)
                
                Button(action: register) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)
                
                // NavigationLink for transitioning to HomePage
                NavigationLink(value: "HomePage") {
                    EmptyView()
                }
            }
            .padding()
            .overlay(
                VStack {
                    if showToast {
                        ToastView(message: toastMessage, isError: isError)
                            .animation(.easeInOut, value: showToast)
                    }
                }
                    .padding(.top, 40),
                alignment: .top
            )
            
            .navigationDestination(isPresented: $isAdmin) {
                            AdminPanelView()
                        }
            
            .navigationDestination(for: String.self) { value in
                if value == "HomePage" {
                    HomePage()
                }
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                HomePage()
            }
            .onAppear {
                            // Reset states when the view appears
                            isAdmin = false
                            isLoggedIn = false
            }
        }
        }
        
        func login() {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    showErrorToast(message: "Login failed: \(error.localizedDescription)")
                } else {
                    if( email == "admin@us.com"){
                        isAdmin = true
                        
                    }
                    else {
                        showSuccessToast(message: "Login successful!")
                        isLoggedIn = true
                    }
                    
                }
            }
        }
        
        func register() {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    showErrorToast(message: "Registration failed: \(error.localizedDescription)")
                } else {
                    showSuccessToast(message: "Registration successful!")
                    isLoggedIn = true
                }
            }
        }
        
        // Toast helper functions
        func showErrorToast(message: String) {
            toastMessage = message
            isError = true
            showToast = true
            hideToastAfterDelay()
        }
        
        func showSuccessToast(message: String) {
            toastMessage = message
            isError = false
            showToast = true
            hideToastAfterDelay()
        }
        
        func hideToastAfterDelay() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                showToast = false
            }
        }
    
}
