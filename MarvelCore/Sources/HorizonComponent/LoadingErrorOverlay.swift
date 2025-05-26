import SwiftUI

public struct LoadingErrorOverlay: ViewModifier {
    @Binding var isLoading: Bool
    @Binding var error: String?
    let action: () -> Void

    public func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: isLoading ? 1 : 0)
                .disabled(isLoading)
                .redacted(reason: (isLoading || error != nil) ? .placeholder : .invalidated)

            if isLoading {
                ProgressView("Loading...")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
            }else if let error = error {
                VStack {
                    Button("", systemImage: "xmark.circle") {
                        self.error = nil
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                    Button("Retry") {
                        action()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .cornerRadius(8)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .padding()
            }
        }
    }
}
extension View {
    public func loadingErrorOverlay(
        isLoading: Binding<Bool>,
        error: Binding<String?>,
        action: @escaping () -> Void
    ) -> some View {
        self.modifier(LoadingErrorOverlay(isLoading: isLoading, error: error, action: action))
    }
}

#Preview {
    @Previewable @State var isLoading = false
    @Previewable @State var error: String? = nil
    VStack {
        VStack {
            Text("SSSS")
            Spacer()
            HStack{
                Spacer()
                Text("Heroes.....")
            }
            Spacer()
        }
        .loadingErrorOverlay(
            isLoading: $isLoading,
            error: $error,
            action: {
                debugPrint("Retrying ......")
            }
        )
        Button("Show Loading") {
            isLoading = true
        }
        
        Button ("Show Error") {
            isLoading = false
            error = "Something went wrong"
        }
    }
}
