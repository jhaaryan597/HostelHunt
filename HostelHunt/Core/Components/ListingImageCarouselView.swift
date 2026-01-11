import SwiftUI

struct ListingImageCarouselView: View {
    let listing: Listing
    @State private var selectedIndex = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedIndex) {
                ForEach(0..<listing.imageURLs.count, id: \.self) { index in
                    GeometryReader { geometry in
                        let imageString = listing.imageURLs[index]

                        // Check if it's a URL or local asset name
                        if imageString.hasPrefix("http://") || imageString.hasPrefix("https://") {
                            // Remote URL - use AsyncImage
                            AsyncImage(url: URL(string: imageString)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .clipped()
                                        .overlay(
                                            LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.6)]),
                                                           startPoint: .center,
                                                           endPoint: .bottom)
                                        )
                                case .failure:
                                    ZStack {
                                        Color.gray.opacity(0.3)
                                        VStack(spacing: 8) {
                                            Image(systemName: "photo")
                                                .font(.system(size: 40))
                                                .foregroundColor(.gray)
                                            Text("Image unavailable")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            // Local asset - use Image
                            Image(imageString)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                                .overlay(
                                    LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.6)]),
                                                   startPoint: .center,
                                                   endPoint: .bottom)
                                )
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: selectedIndex)

            // Custom Pagination Dots
            HStack(spacing: GenZDesignSystem.Spacing.sm) {
                ForEach(0..<listing.imageURLs.count, id: \.self) { index in
                    Circle()
                        .fill(selectedIndex == index ? GenZDesignSystem.Colors.primary : Color.white.opacity(0.5))
                        .frame(width: 8, height: 8)
                        .animation(GenZDesignSystem.Animation.smooth, value: selectedIndex)
                }
            }
            .padding(.bottom, GenZDesignSystem.Spacing.lg)
        }
    }
}
#Preview {
    ListingImageCarouselView(listing: DeveloperPreview.shared.listings[0])
}
