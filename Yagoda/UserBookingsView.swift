//
//  UserBookingsView.swift
//  Yagoda
//
//  Created by Tanvir Ahmed on 14/1/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct UserBookingsView: View {
    @State private var bookings: [Booking] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading your bookings...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if bookings.isEmpty {
                EmptyStateView()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(bookings) { booking in
                            BookingCardView(booking: booking)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear(perform: fetchBookings)
        .navigationTitle("My Bookings")
    }

    private func fetchBookings() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("bookings")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                isLoading = false
                if let error = error {
                    print("Error fetching bookings: \(error.localizedDescription)")
                    return
                }
                bookings = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Booking.self)
                } ?? []
            }
    }
}

struct BookingCardView: View {
    let booking: Booking
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image
            AsyncImage(url: URL(string: booking.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(ProgressView())
            }
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Details
            VStack(alignment: .leading, spacing: 8) {
                Text(booking.name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                    Text(booking.date.formatted(date: .long, time: .omitted))
                }
                
                HStack {
                    Image(systemName: booking.status == "confirmed" ? "checkmark.circle.fill" : "clock.fill")
                    Text(booking.status.capitalized)
                        .font(.subheadline)
                }
                .foregroundColor(booking.status == "confirmed" ? .green : .orange)
            }
            .padding(.horizontal)
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Bookings Yet")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Your bookings will appear here")
                .font(.body)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
