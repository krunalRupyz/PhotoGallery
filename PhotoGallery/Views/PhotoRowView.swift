import SwiftUI

struct PhotoRowView: View {
    @ObservedObject var photo: PhotoEntity
    var body: some View {

        HStack(spacing: 12) {
            AsyncImage(url: URL(string: photo.thumbnailUrl ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure(_):

                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                case .empty:
                    ProgressView()

                @unknown default:

                    EmptyView()
                }
            }
            .frame(width: 80, height: 80)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(photo.title ?? "")
                .font(.body)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )

            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
    }
}
