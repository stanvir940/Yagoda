//
//  PropertyListViewModel.swift
//  Yagoda
//
//  Created by Tanvir Ahmed on 4/1/25.
//

import Foundation

import SwiftUI
import FirebaseFirestore

class PropertyListViewModel: ObservableObject {
    @Published var properties = [Property]()

    private var db = Firestore.firestore()

    func fetchProperties() {
        db.collection("properties").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching properties: \(error)")
                return
            }

//            self.properties = snapshot?.documents.compactMap { document in
//                try? document.data(as: Property.self)
//            } ?? []
        }
    }
}
