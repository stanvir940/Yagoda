//
//  AdsView.swift
//  Yagoda
//
//  Created by Tanvir Ahmed on 9/1/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
struct AdsView: View {
    @State private var properties: [Property] = []
    @State private var isLoading: Bool = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading properties...")
            } else if properties.isEmpty {
                Text("No properties found.")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                List(properties) { property in
                    NavigationLink(destination: PropertyDetailView(property: property)) {
                        HStack {
                            AsyncImage(url: URL(string: property.imageUrl)) { image in
                                image.resizable()
                                     .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                            .clipped() // Ensures that the image does not overflow


                            VStack(alignment: .leading) {
                                Text(property.name)
                                    .font(.headline)
                                Text(property.location)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(property.price)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
        .onAppear(perform: fetchProperties)
    }

    func fetchProperties() {
        let db = Firestore.firestore()
        db.collection("properties").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching properties: \(error)")
                isLoading = false
                return
            }
            
            if let snapshot = snapshot {
                properties = snapshot.documents.compactMap { doc -> Property? in
                    try? doc.data(as: Property.self)
                }
            }
            isLoading = false
        }
    }
}
