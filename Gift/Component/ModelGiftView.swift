import SwiftUI

struct ModelGiftView: View {
    var name: String
    var price: Double
    var address: String?
    var url: URL?
    var bought: Bool = false
    var backgroundColor: Color = Color("redPastel")
    var image: Image = Image("giftIconRouge")

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .alignmentGuide(.top) { d in d[.top] }

                Text(String(format: "$%.2f", price))
                    .font(.subheadline)
                    .foregroundColor(.white)

                if let address = address {
                    Text(address)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }

                if let url = url {
                    Link(destination: url) {
                        Text(url.absoluteString)
                            .font(.subheadline)
                            .underline()
                            .foregroundColor(.white)
                            .alignmentGuide(.bottom) { d in d[.bottom] }
                    }
                }
            }
            .padding()

            Spacer()

            VStack {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .padding(.top, 5)
                    .alignmentGuide(.top) { d in d[.top] }

                if bought {
                    Text("Purchased")
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .alignmentGuide(.bottom) { d in d[.bottom] }
                } else {
                    Text("Not Purchased")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .alignmentGuide(.bottom) { d in d[.bottom] }
                }
            }
            .padding()
        }
        .background(backgroundColor)
        .cornerRadius(10)
    }
}

#Preview {
    ModelGiftView(name: "Teddy Bear", price: 29.99, address: "amazon", url: URL(string: "https://amazon.fr/"), bought: false, image: Image("giftIconRouge"))
}

