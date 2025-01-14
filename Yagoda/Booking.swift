//
//  Booking.swift
//  Yagoda
//
//  Created by Tanvir Ahmed on 14/1/25.
//

import Foundation
import Foundation
import FirebaseFirestore

struct Booking: Identifiable, Codable {
    @DocumentID var id: String?
    var hotelId: String
    var userId: String
    var date: Date
    var status: String
    var image: String
    var name: String
}
