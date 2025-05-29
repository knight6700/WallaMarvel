import SwiftUI
import HorizonComponent

struct HeroHeaderView: View {
    let hero: Hero
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                ImageView(
                    url: hero.imageURL,
                    size: CGSize(width: 150, height: 150),
                    placeholder: .placeholder
                )
                .clipShape(Circle())
                Text(hero.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.secondary))
                    .accessibilityLabel("Hero: \(hero.name)")
            }
            .padding(.leading)
            .frame(maxWidth: .infinity)
            Text(hero.shortDescription)
                .font(.subheadline)
                .foregroundStyle(Color(.secondary))
        }
        .padding()
        .background(Color(.primary))
        .clipShape(AngledBottomCorners(corner: .trailing, cutSize: 20))
    }
}

#Preview {
    HeroHeaderView(hero: .mock)
}
