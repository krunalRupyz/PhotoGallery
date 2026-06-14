import SwiftUI

struct PhotoRowView: View {
    @ObservedObject var photo: PhotoEntity
    
    var body: some View {
        HStack(spacing: 12) {
            // FIX: Use the cached loader instead of AsyncImage
            CachedAsyncImage(
                url: photo.thumbnailUrl ?? "",
                placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                        .foregroundColor(.gray)
                }
            )
            .scaledToFill()
            .frame(width: 80, height: 80)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(photo.title ?? "")
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
    }
}

