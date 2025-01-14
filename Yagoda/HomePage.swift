//
//  AdsDetailView.swift
//  Yagoda
//
//  Created by Tanvir Ahmed on 9/1/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct HomePage: View {
    @State private var searchText = ""
    @State private var properties: [Property] = []
    @State private var isLoading = true
    @State private var showingSortOptions = false
    @State private var selectedSortOption: SortOption = .default
    @State private var navigateToNewView = false // State for navigation
    @State private var navigationPath: [String] = []
    
    
    enum SortOption: String, CaseIterable {
        case `default` = "Default"
        case priceLowToHigh = "Price: Low to High"
        case priceHighToLow = "Price: High to Low"
        case name = "Name"
    }
    
    var filteredAndSortedProperties: [Property] {
        let filtered = searchText.isEmpty ? properties : properties.filter { property in
            property.name.localizedCaseInsensitiveContains(searchText) ||
            property.location.localizedCaseInsensitiveContains(searchText)
        }
        
        return filtered.sorted { first, second in
            switch selectedSortOption {
            case .default:
                return true
            case .priceLowToHigh:
                return extractPrice(from: first.price) < extractPrice(from: second.price)
            case .priceHighToLow:
                return extractPrice(from: first.price) > extractPrice(from: second.price)
            case .name:
                return first.name < second.name
            }
        }
    }
    
    private func extractPrice(from priceString: String) -> Double {
        // Remove "$" and "/night", then convert to Double
        let numberString = priceString
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: "/night", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        return Double(numberString) ?? 0.0
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Search and Filter Bar
                    HStack {
                        // Search Bar
                        SearchBarView(text: $searchText)
                        
                        // Sort Button
                        Button(action: {
                            showingSortOptions = true
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                                .foregroundColor(.blue)
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                        Button(action: {
                            navigateToNewView = true;
                            navigationPath.append("newView");
//                            printf($navigationToNewView)
                        }) {
                            Text("Bookings")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Selected Sort Option Display
                    if selectedSortOption != .default {
                        HStack {
                            Text("Sorted by: \(selectedSortOption.rawValue)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Button(action: {
                                selectedSortOption = .default
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            
                        }
                        .padding(.horizontal)
                        
                        // start here
                        // Navigation Button
//                                            NavigationLink(destination: UserBookingsView(), isActive: $navigateToNewView) {
//                                                EmptyView()
//                                            }.hidden()
                                            
                                            
                    }
                    
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Featured Properties
                        VStack(alignment: .leading) {
                            SectionHeaderView(title: "Featured Properties", subtitle: "Handpicked properties for you")
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(filteredAndSortedProperties.prefix(5)) { property in
                                        NavigationLink(destination: AdsDetailView(property: property)) {
                                            FeaturedPropertyCard(property: property)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // All Properties
                        VStack(alignment: .leading) {
                            SectionHeaderView(title: "All Properties", subtitle: "Explore all available properties")
                            
                            LazyVStack(spacing: 15) {
                                ForEach(filteredAndSortedProperties) { property in
                                    NavigationLink(destination: AdsDetailView(property: property)) {
                                        PropertyListItem(property: property)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Find Your Stay")
            .onAppear(perform: fetchProperties)
            .actionSheet(isPresented: $showingSortOptions) {
                ActionSheet(
                    title: Text("Sort Properties"),
                    buttons: SortOption.allCases.map { option in
                        .default(Text(option.rawValue)) {
                            selectedSortOption = option
                        }
                    } + [.cancel()]
                )
            }
            .navigationDestination(isPresented: $navigateToNewView) {
                UserBookingsView()
            }
        }
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

struct SearchBarView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search destinations", text: $text)
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct SectionHeaderView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

struct FeaturedPropertyCard: View {
    let property: Property
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: property.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(ProgressView())
            }
            .frame(width: 280, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(property.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(property.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                Text(property.price)
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
        }
        .frame(width: 280)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct PropertyListItem: View {
    let property: Property
    
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: property.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(ProgressView())
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(property.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(property.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(property.price)
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            Spacer()
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 3)
    }
} 
