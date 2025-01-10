////
////  PropertyListView.swift
////  Yagoda
////
////  Created by Tanvir Ahmed on 4/1/25.
////
//import SwiftUI
//
//struct PropertyListView: View {
//    @State private var properties: [Property] = [
//        Property(id: UUID(), name: "Luxury Villa", location: "Los Angeles", price: "$500/night", description: "A beautiful villa with a pool.", imageUrl: "hotel1"),
//        Property(id: UUID(), name: "Cozy Apartment", location: "New York", price: "$150/night", description: "A small, cozy apartment in the city.", imageUrl: "hotel2"),
//        Property(id: UUID(), name: "Beach House", location: "Miami", price: "$350/night", description: "A stunning house near the beach.", imageUrl: "hotel3")
//    ]
//
//    var body: some View {
//        NavigationView {
//            List(properties) { property in
//                NavigationLink(destination: PropertyDetailView(property: property)) {
//                    VStack(alignment: .leading) {
//                        Image(property.imageUrl)
//                                                            .resizable()
//                                                            .aspectRatio(contentMode: .fill)
//                                                            .frame(height: 200)
//                                                            .clipped()
//                                                            .cornerRadius(15)
//
//                        VStack(alignment: .leading) {
//                            Text(property.name)
//                                .font(.headline)
//                            Text(property.location)
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//
//                        Spacer()
//
//                        Text(property.price)
//                            .font(.subheadline)
//                            .foregroundColor(.blue)
//                    }
//                    .padding(.vertical, 5)
//                }
//            }
//            .navigationTitle("Properties")
//        }
//    }
//}
//
