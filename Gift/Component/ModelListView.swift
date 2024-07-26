import SwiftUI

struct ModelListView: View {
    var nameList: String
    var background: Color

    var body: some View {
        VStack {
            HStack {
                Text(nameList)
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.leading, 10)
                Spacer()
            }
            .frame(width: .infinity, height: 50)
            .background(Rectangle().fill(background))
            .cornerRadius(10)
            .padding(4)
        }
        .padding()

    }
}

#Preview {
    ModelListView(nameList: "Dylan's List", background: Color("bluePastel"))
}
