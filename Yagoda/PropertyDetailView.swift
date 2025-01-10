//
//  PropertyDetailView.swift
//  Yagoda
//
//  Created by Tanvir Ahmed on 4/1/25.
//

import Foundation
import SwiftUI

struct PropertyDetailView: View {
    let property: Property

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image(property.imageUrl)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.bottom, 20)

                Text(property.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)

                Text(property.location)
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)

                Text(property.price)
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding(.bottom, 15)

                Text("Description")
                    .font(.headline)
                    .padding(.bottom, 5)

                Text(property.description)
                    .font(.body)
                    .foregroundColor(.secondary)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Property Details")
    }
}

