import SwiftUI

struct MainMenuView: View {
    @State private var currentQuoteIndex = 0

    let quotes = [
        "“Matematika bukan tentang angka, rumus, atau persamaan. Ini tentang memahami.” \n— William Paul Thurston",
        "“Tanpa matematika, tidak ada yang bisa kamu lakukan. Segalanya di sekitarmu adalah matematika.” \n— Shakuntala Devi",
        "“Matematika adalah musik dari alasan.” \n— James Joseph Sylvester",
        "“Berpikir matematis bukan bakat, tapi kebiasaan.” \n— Richard Skemp"
    ]

    var body: some View {
        NavigationView {
            ZStack {
                // 🌈 ThinkX-style gradient background (blue + orange + white)
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.2),
                        Color.orange.opacity(0.1),
                        Color.white
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // 🧠 Quotes section
                    Text(quotes[currentQuoteIndex])
                        .font(.title3)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(height: 100, alignment: .center)
                        .padding(.top, 50)
                        .onAppear {
                            startQuoteTimer()
                        }

                    Spacer()

                    // 🧱 Divider with shadow
                    ZStack {
                        Divider()
                            .background(Color.gray.opacity(0.3))
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 1)
                            .shadow(color: .black.opacity(0.1), radius: 4, y: 4)
                            .opacity(0.001)
                    }
                    
                    Spacer()

                    // 📋 Menu buttons
                    ScrollView {
                        VStack(spacing: 16) {
                            NavigationLink(destination: PerkalianDasarView()) {
                                modeButton(title: "Perkalian Dasar", subtitle: "Easy")
                            }

                            NavigationLink(destination: Perkalian1DigitView()) {
                                modeButton(title: "Perkalian 1 Digit", subtitle: "Medium")
                            }

                            NavigationLink(destination: Perkalian2DigitView()) {
                                modeButton(title: "Perkalian 2 Digit", subtitle: "Hard")
                            }

                            NavigationLink(destination: Perkalian3DigitView()) {
                                modeButton(title: "Perkalian 3 Digit", subtitle: "Super")
                            }

                            NavigationLink(destination: PerkalianAngka11View()) {
                                modeButton(title: "Perkalian Angka 11", subtitle: "Side Quest")
                            }

                            NavigationLink(destination: PerkalianAngka99View()) {
                                modeButton(title: "Perkalian Angka 99", subtitle: "Side Quest")
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    func startQuoteTimer() {
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            withAnimation {
                currentQuoteIndex = (currentQuoteIndex + 1) % quotes.count
            }
        }
    }

    // 🎨 Improved mode button
    func modeButton(title: String, subtitle: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.85))
            }
            Spacer() // biar kontennya tetap ke kiri, tapi tombol full lebar
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)],
                           startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(14)
        .shadow(color: .gray.opacity(0.4), radius: 6, x: 0, y: 4)
    }
}

#Preview {
    MainMenuView()
}
