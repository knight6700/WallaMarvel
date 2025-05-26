import SwiftUI
import HorizonComponent

struct HeroCell: View {
    let hero: Hero
    var body: some View {
        VStack(spacing: 0) {
            Image(.placeholder)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 4) {
                Text(hero.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(hero.shortDescription)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.black)
        }
        .clipShape(AngledBottomCorners())
        .padding(.horizontal)
    }
}

#Preview {
    HeroCell(
        hero: .mock
    )
}
struct AngledBottomCorners: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let cutSize: CGFloat = 20

        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cutSize))
        path.addLine(to: CGPoint(x: rect.maxX - cutSize, y: rect.maxY))
        path.addLine(to: CGPoint(x: cutSize, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY - cutSize))
        path.closeSubpath()

        return path
    }
}
