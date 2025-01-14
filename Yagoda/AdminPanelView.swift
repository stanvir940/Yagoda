//
//  AdminPanelView.swift
//  Yagoda
//
//  Created by Tanvir Ahmed on 9/1/25.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AdminPanelView: View {
    @State private var propertyName: String = ""
    @State private var propertyLocation: String = ""
    @State private var propertyPrice: String = ""
    @State private var propertyDescription: String = ""
    @State private var propertyImageUrl: String = ""
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var isError = false
    @State private var adminPanelView = false
    
    private let db = Firestore.firestore()
    private let adminEmail = "admin@us.com"

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Admin Stats Card
                    AdminStatsCard()
                        .padding(.horizontal)
                    
                    // Bookings Management Card
                    NavigationLink(destination: AdminBookingsView()) {
                        DashboardCard(
                            title: "Manage Bookings",
                            subtitle: "View and manage all reservations",
                            icon: "list.bullet.clipboard.fill",
                            color: .blue
                        )
                    }
                    .padding(.horizontal)
                    
                    // Add Property Form
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Add New Property")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        CustomTextField(
                            title: "Property Name",
                            text: $propertyName,
                            icon: "house.fill"
                        )
                        
                        CustomTextField(
                            title: "Location",
                            text: $propertyLocation,
                            icon: "location.fill"
                        )
                        
                        CustomTextField(
                            title: "Price",
                            text: $propertyPrice,
                            icon: "dollarsign.circle.fill",
                            placeholder: "$200/night"
                        )
                        
                        CustomTextField(
                            title: "Description",
                            text: $propertyDescription,
                            icon: "text.alignleft",
                            isMultiline: true
                        )
                        
                        CustomTextField(
                            title: "Image URL",
                            text: $propertyImageUrl,
                            icon: "photo.fill"
                        )
                        
                        Button(action: addProperty) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Property")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Admin Dashboard")
            .overlay(
                Group {
                    if showToast {
                        ToastView(message: toastMessage, isError: isError)
                            .transition(.move(edge: .top))
                            .animation(.spring(), value: showToast)
                    }
                }
            )
        }
        .onAppear(perform: checkAdminAccess)
    }

    private func checkAdminAccess() {
        guard let user = Auth.auth().currentUser else {
            showErrorToast(message: "User not logged in.")
            return
        }

        if user.email != adminEmail {
            showErrorToast(message: "You do not have admin access.")
        }
    }

    private func addProperty() {
        guard !propertyName.isEmpty, !propertyLocation.isEmpty,
              !propertyPrice.isEmpty, !propertyDescription.isEmpty,
              !propertyImageUrl.isEmpty else {
            showErrorToast(message: "All fields are required.")
            return
        }

        let newProperty = [
            "name": propertyName,
            "location": propertyLocation,
            "price": propertyPrice,
            "description": propertyDescription,
            "imageUrl": propertyImageUrl
        ]

        db.collection("properties").addDocument(data: newProperty) { error in
            if let error = error {
                showErrorToast(message: "Error: \(error.localizedDescription)")
            } else {
                clearFields()
                showSuccessToast(message: "Property added successfully!")
            }
        }
    }
    
    private func clearFields() {
        propertyName = ""
        propertyLocation = ""
        propertyPrice = ""
        propertyDescription = ""
        propertyImageUrl = ""
    }
    
    private func showErrorToast(message: String) {
        toastMessage = message
        isError = true
        showToast = true
        hideToastAfterDelay()
    }
    
    private func showSuccessToast(message: String) {
        toastMessage = message
        isError = false
        showToast = true
        hideToastAfterDelay()
    }
    
    private func hideToastAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showToast = false
            }
        }
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    var placeholder: String = ""
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                if isMultiline {
                    TextEditor(text: $text)
                        .frame(height: 100)
                } else {
                    TextField(placeholder.isEmpty ? title : placeholder, text: $text)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
        }
    }
}

struct DashboardCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
                .frame(width: 60, height: 60)
                .background(color.opacity(0.2))
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct AdminStatsCard: View {
    var body: some View {
        HStack {
            StatItem(title: "Properties", value: "12", icon: "house.fill", color: .blue)
            StatItem(title: "Bookings", value: "48", icon: "calendar.badge.clock", color: .green)
            StatItem(title: "Revenue", value: "$5.2k", icon: "dollarsign.circle.fill", color: .orange)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}
