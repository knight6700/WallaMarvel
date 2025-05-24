import SwiftUI
import HorizonComponent

struct HeroHeaderView: View {
    let hero: Hero
    var body: some View {
        HStack(alignment: .center) {
            Image(.placeholder)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)

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
//    HeroHeaderView()
}
