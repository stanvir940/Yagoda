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
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 25) {
                    // Logo and Welcome Text
                    VStack(spacing: 20) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                        
                        Text("StayNest")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Your Home Away From Home")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 50)

                    // Login Form
                    VStack(spacing: 20) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.white)
                            TextField("Email", text: $email)
                                .autocapitalization(.none)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.white)
                            SecureField("Password", text: $password)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)

                        Button(action: login) {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                        Button(action: register) {
                            Text("Create Account")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 25)

                    // Keep your original NavigationLink
                    NavigationLink(value: "HomePage") {
                        EmptyView()
                    }
                }
            }
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
                isAdmin = false
                isLoggedIn = false
            }
        }
    }
    
    // Keep your original functions
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                showErrorToast(message: "Login failed: \(error.localizedDescription)")
            } else {
                if email == "admin@us.com" {
                    isAdmin = true
                } else {
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
