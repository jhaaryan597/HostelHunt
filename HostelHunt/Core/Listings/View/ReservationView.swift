import SwiftUI
import Razorpay

struct ReservationView: View {
    @StateObject private var paymentHandler = RazorpayPaymentHandler()
    @Binding var isPresented: Bool
    let listing: Listing
    let user: User
    
    @StateObject private var reservationService = ReservationService()
    @State private var startDate = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    @State private var isBooking = false
    @State private var bookingSuccess = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showConfirmationAlert = false
    @State private var proceedToPayment = false

    private var totalPrice: Double {
        reservationService.calculateTotalPrice(listing: listing, startDate: startDate, endDate: endDate)
    }
    
    private var gst: Double {
        totalPrice * 0.18
    }
    
    private var finalPrice: Double {
        totalPrice + gst
    }

    var body: some View {
        NavigationView {
            content
            .navigationBarTitle("Reservation", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
            .alert("Success!", isPresented: $bookingSuccess) {
                Button("OK", role: .cancel) {
                    isPresented = false
                }
            } message: {
                Text("Your reservation for \(listing.title) has been confirmed.")
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .alert("Confirm Reservation", isPresented: $showConfirmationAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Confirm") {
                    proceedToPayment = true
                }
            } message: {
                Text("Are you sure you want to proceed with the payment? This will confirm your reservation.")
            }
        }
        .onChange(of: proceedToPayment) {
            if proceedToPayment {
                paymentHandler.openCheckout(
                    amount: finalPrice,
                    name: listing.title,
                    description: "Reservation for \(listing.title)",
                    email: user.email,
                    phone: user.phoneNumber ?? ""
                )
                proceedToPayment = false
            }
        }
        .onAppear {
            paymentHandler.onPaymentSuccess = { paymentId in
                reserveListing()
            }
            paymentHandler.onPaymentError = { error in
                errorMessage = error
                showError = true
            }
        }
    }
    
    private var content: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    Text("Confirm Reservation")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // Listing Info
                    HStack {
                        ListingImageCarouselView(listing: listing)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                        VStack(alignment: .leading) {
                            Text(listing.title)
                                .font(.headline)
                            Text("\(listing.city), \(listing.state)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    // Date Selection
                    VStack(alignment: .leading) {
                        Text("Select Dates").font(.title2).fontWeight(.semibold)
                        DatePicker("Check-in", selection: $startDate, in: Date()..., displayedComponents: .date)
                        DatePicker("Check-out", selection: $endDate, in: startDate..., displayedComponents: .date)
                    }
                    
                    Divider()
                    
                    // Price Details
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Price Details").font(.title2).fontWeight(.semibold)
                        HStack {
                            Text("Base Price")
                            Spacer()
                            Text(String(format: "₹%.2f", totalPrice))
                        }
                        HStack {
                            Text("GST (18%)")
                            Spacer()
                            Text(String(format: "₹%.2f", gst))
                        }
                        Divider()
                        HStack {
                            Text("Total")
                                .fontWeight(.bold)
                            Spacer()
                            Text(String(format: "₹%.2f", finalPrice))
                                .fontWeight(.bold)
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            // Confirm Button
            Button(action: {
                showConfirmationAlert = true
            }) {
                if isBooking {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                } else {
                    Text("Proceed to Payment")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(isBooking)
            .padding()
        }
    }
    
    private func reserveListing() {
        isBooking = true
        Task {
            do {
                try await reservationService.reserve(listing: listing, user: user, startDate: startDate, endDate: endDate)
                bookingSuccess = true
            } catch {
                errorMessage = "Failed to reserve the listing. Please try again."
                showError = true
            }
            isBooking = false
        }
    }
}
