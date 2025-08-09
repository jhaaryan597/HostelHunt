import SwiftUI
import MapKit

struct ListingDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    let listing: Listing
    @State private var cameraPosition: MapCameraPosition
    @State private var showLogin = false

    init(listing: Listing) {
        self.listing = listing
        
        let region = MKCoordinateRegion(
            center: listing.city == "Los Angeles" ? .losAngeles : .miami,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        
        self._cameraPosition = State(initialValue: .region(region))
    }
    
    var body: some View {
            ScrollView {
                ZStack(alignment: .topLeading) {
                    ListingImageCarouselView(listing: listing)
                        .frame(height: 320)
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                            .font(.title2)
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(.white))
                    }
                    .padding(32)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("\(listing.title)")
                        .font(.title)
                        .fontWeight(.semibold)

                    VStack(alignment: .leading) {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                            Text(formatRating(listing.rating))
                            Text(" - ")
                            Text("\(listing.reviews.count) reviews")
                                .underline()
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.black)
                        .font(.caption)

                        Text("\(listing.city), \(listing.state)")
                            .font(.caption)
                    }
                }
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Entire \(listing.type.description) hosted by \(listing.ownerName)")
                            .font(.headline)
                            .frame(width: 250, alignment: .leading)
                        
                        HStack(spacing: 2) {
                            Text("\(listing.numberOfBeds) beds")
                        }
                        .font(.caption)
                        
                        Text("Gender: \(listing.gender.description)")
                            .font(.caption)
                    }
                    .frame(width: 300, alignment: .leading)
                    Spacer()
                    Image(listing.ownerImageUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                }
                .padding()
                
                Divider()
                
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(listing.features) { feature in
                        HStack(spacing: 12) {
                            Image(systemName: feature.imageName)

                            VStack(alignment: .leading) {
                                Text(feature.title)
                                    .font(.footnote)
                                    .fontWeight(.semibold)

                                Text(feature.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
                .padding()
                
                Divider()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Reviews")
                        .font(.headline)

                    ForEach(listing.reviews) { review in
                        HStack {
                            Image(review.userImageUrl)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 48, height: 48)
                                .clipShape(Circle())

                            VStack(alignment: .leading) {
                                Text(review.userName)
                                    .fontWeight(.semibold)
                                Text(review.comment)
                            }
                            Spacer()
                            
                            HStack {
                                Image(systemName: "star.fill")
                                Text("\(review.rating)")
                            }
                        }
                    }
                }
                .padding()

                Divider()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("What this place offers")
                        .font(.headline)

                    ForEach(listing.amenities) { amenity in
                        HStack {
                            Image(systemName: amenity.imageName)
                                .frame(width: 32)

                            Text(amenity.title)
                                .font(.footnote)

                            Spacer()
                        }
                    }
                }
                .padding()
                
                Divider()

                VStack(alignment: .leading, spacing: 16) {
                    Text("Where you'll be")
                        .font(.headline)

                    Map(position: $cameraPosition)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }
            .toolbar(.hidden, for: .tabBar)
            .ignoresSafeArea()
            .padding(.bottom, 64)
            .overlay(alignment: .bottom){
                VStack{
                    Divider().padding(.bottom)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("₹\(listing.pricePerMonth)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text("per month")
                                .font(.footnote)
                        }

                        Spacer()

                        Button {
                            if authService.user != nil {
                                // Handle reservation
                            } else {
                                showLogin.toggle()
                            }
                        } label: {
                            Text("Reserve")
                                .foregroundStyle(.white)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(width: 140, height: 40)
                                .background(Color("AccentColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal, 32)
                }
                .background(.white)
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showLogin) {
                NavigationView {
                    LoginView()
                }
            }
        }
}

#Preview {
    ListingDetailView(listing: DeveloperPreview.shared.listings[0])
}
