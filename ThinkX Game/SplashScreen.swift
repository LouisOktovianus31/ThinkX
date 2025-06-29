import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0

    var body: some View {
        if isActive {
            MainMenuView() // Ganti ini sesuai next screen
        } else {
            ZStack {
                Color.blue
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Image("ThinkX Logo") // Pastikan gambar ada di Assets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .onAppear {
                            withAnimation(.easeOut(duration: 1.2)) {
                                logoScale = 1.0
                                logoOpacity = 1.0
                            }
                        }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}



#Preview {
    SplashScreen()
}
