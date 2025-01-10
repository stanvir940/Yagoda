//
//  Property.swift
//  Yagoda
//
//  Created by Tanvir Ahmed on 4/1/25.
//


import Foundation
import FirebaseFirestore // FirebaseFirestoreSwift hobe
//
//struct Property: Identifiable, Codable {
//    @DocumentID var id: String?
//    var name: String
//    var location: String
//    var price: Double
//    var imageURL: String
//}

struct Property: Identifiable,Codable {
//    let id: UUID
    @DocumentID var id: String?
    let name: String
    let location: String
    let price: String
    let description: String
    let imageUrl: String
}
