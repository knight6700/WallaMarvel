import SwiftUI
import HorizonComponent

struct HeroHeaderView: View {
    let hero: Hero
    var body: some View {
        HStack(alignment: .center) {
            ImageView(
                url: hero.imageURL,
                size: CGSize(width: 150, height: 150),
                placeholder: .placeholder
            )
            .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(hero.shortDescription)
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text(hero.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding(.leading)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.black)
        .foregroundColor(.white)
    }
}

#Preview {
    HeroHeaderView(hero: .mock)
}
