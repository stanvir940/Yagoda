//
//  AdsDetailView.swift
//  Yagoda
//
//  Created by Tanvir Ahmed on 9/1/25.
//

import Foundation
import SwiftUI

struct AdsDetailView: View { //PropertyDetailView
    let property: Property

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: property.imageUrl)) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 300)
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 10) {
                    Text(property.name)
                        .font(.largeTitle)
                        .bold()

                    Text("Location: \(property.location)")
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text("Price: \(property.price)")
                        .font(.title3)
                        .foregroundColor(.blue)

                    Divider()
                        .padding(.vertical, 10)

                    Text(property.description)
                        .font(.body)
                }
                .padding()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
