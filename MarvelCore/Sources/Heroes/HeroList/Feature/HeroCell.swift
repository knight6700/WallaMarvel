import SwiftUI
import HorizonComponent

struct HeroCell: View {
    let hero: Hero
    var body: some View {
        VStack(spacing: 0) {
            ImageView(
                url: hero.imageURL,
                size: CGSize(width: 200, height: 200),
                placeholder: .placeholder
            )
            VStack(alignment: .leading, spacing: 4) {
                Text(hero.name)
                    .font(.headline)
                    .foregroundColor(Color(.secondary))
                Text(hero.shortDescription)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.primary))
        }
        .clipShape(AngledBottomCorners(corner: .trailing, cutSize: 20))
        .padding(.horizontal)
    }
}

#Preview {
    HeroCell(
        hero: .mock
    )
}

struct AngledBottomCorners: Shape {
    enum AngledCorner {
        case leading
        case trailing
        case both
    }
    var corner: AngledCorner
    var cutSize: CGFloat = 20

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - (corner == .trailing || corner == .both ? cutSize : 0)))

        if corner == .trailing || corner == .both {
            path.addLine(to: CGPoint(x: rect.maxX - cutSize, y: rect.maxY))
        } else {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }

        if corner == .leading || corner == .both {
            path.addLine(to: CGPoint(x: cutSize, y: rect.maxY))
            path.addLine(to: CGPoint(x: 0, y: rect.maxY - cutSize))
        } else {
            path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        }

        path.closeSubpath()
        return path
    }
}
