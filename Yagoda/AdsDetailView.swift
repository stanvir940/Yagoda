import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

struct AdsDetailView: View {
    let property: Property
    @State private var selectedDate = Date()
    @State private var showConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Image Section
                AsyncImage(url: URL(string: property.imageUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 200)
                .cornerRadius(12)
                .padding(.horizontal)
                .shadow(radius: 5)

                // Property Details Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(property.name)
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 5)

                    Text("Location: \(property.location)")
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text("Price: \(property.price)")
                        .font(.title3)
                        .foregroundColor(.blue)

                    Divider()
                        .padding(.vertical, 8)

                    Text(property.description)
                        .font(.body)
                        .lineLimit(nil)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.horizontal)

                // Booking Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select a Date")
                        .font(.headline)

                    DatePicker("Booking Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding(.bottom, 10)

                    Button(action: bookNow) {
                        Text("Book Now")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.horizontal)
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showConfirmation) {
            Alert(title: Text("Booking Confirmed"), message: Text("Your booking has been submitted."), dismissButton: .default(Text("OK")))
        }
    }

    // Booking Functionality
    private func bookNow() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let booking = [
            "hotelId": property.id ?? "",
            "userId": userId,
            "date": Timestamp(date: selectedDate),
            "status": "pending",
            "image": property.imageUrl,
            "name": property.name
        ] as [String: Any]

        Firestore.firestore().collection("bookings").addDocument(data: booking) { error in
            if let error = error {
                print("Error saving booking: \(error.localizedDescription)")
            } else {
                showConfirmation = true
            }
        }
    }
}
