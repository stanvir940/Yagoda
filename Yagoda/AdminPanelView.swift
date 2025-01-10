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
    @State private var showSuccessMessage: Bool = false
    @State private var showErrorMessage: Bool = false
    @State private var errorMessage: String = ""
    
    private let db = Firestore.firestore()
    private let adminEmail = "admin@us.com" // Replace with your admin email

    var body: some View {
        NavigationView {
            VStack {
                Text("Admin Panel")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                Form {
                    Section(header: Text("Property Details")) {
                        TextField("Property Name", text: $propertyName)
                            .autocapitalization(.none)

                        TextField("Location", text: $propertyLocation)
                            .autocapitalization(.none)

                        TextField("Price (e.g., $200/night)", text: $propertyPrice)
                            .keyboardType(.default)

                        TextField("Description", text: $propertyDescription)
                            .autocapitalization(.none)

                        TextField("Image URL", text: $propertyImageUrl)
                            .autocapitalization(.none)
                    }

                    Button(action: addProperty) {
                        Text("Add Property")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.vertical)
                }
                .background(Color(.systemGroupedBackground))

                if showSuccessMessage {
                    Text("Property added successfully!")
                        .foregroundColor(.green)
                        .bold()
                        .padding(.top)
                }

                if showErrorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .bold()
                        .padding(.top)
                }
            }
            .navigationBarTitle("Admin Panel", displayMode: .inline)
            .padding()
        }
        .onAppear(perform: checkAdminAccess)
    }

    // Function to check if the logged-in user is an admin
    private func checkAdminAccess() {
        guard let user = Auth.auth().currentUser else {
            showErrorMessage = true
            errorMessage = "User not logged in."
            return
        }

        if user.email != adminEmail {
            showErrorMessage = true
            errorMessage = "You do not have admin access."
        }
    }

    // Function to add property to Firestore
    private func addProperty() {
        guard !propertyName.isEmpty, !propertyLocation.isEmpty, !propertyPrice.isEmpty, !propertyDescription.isEmpty, !propertyImageUrl.isEmpty else {
            showErrorMessage = true
            errorMessage = "All fields are required."
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
                showErrorMessage = true
                errorMessage = "Error adding property: \(error.localizedDescription)"
            } else {
                // Reset fields and show success message
                propertyName = ""
                propertyLocation = ""
                propertyPrice = ""
                propertyDescription = ""
                propertyImageUrl = ""
                showSuccessMessage = true
                showErrorMessage = false
            }
        }
    }
}
