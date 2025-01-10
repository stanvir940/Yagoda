//
//  HomePage.swift
//  Yagoda
//
//  Created by Tanvir Ahmed on 4/1/25.
//

import Foundation
import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationStack{
        NavigationView {
            VStack {
                //PropertyListView() // Embedding the property list here
                AdsView();
            }
            .navigationTitle("Home")
            .navigationBarItems(
                leading: Button(action: {
                    print("Menu button tapped")
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title2)
                },
                trailing: Button(action: {
                    print("Profile button tapped")
                }) {
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                }
            )
        }
    }
    }
}
