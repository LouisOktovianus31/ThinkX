import SwiftUI
import SpriteKit

struct GenericGameView: View {
    let mode: GameMode
    @StateObject private var status = GameStatus()
    @State private var skScene: GenericGameScene?
    @State private var sceneID = UUID()

    var scene: GenericGameScene {
        let sc = GenericGameScene(size: CGSize(width: 390, height: 844), status: status, mode: mode)
        return sc
    }

    var body: some View {
        ZStack {
            // 🎨 Background gradient (SwiftUI layer)
            LinearGradient(colors: [Color.orange.opacity(0.9), Color.yellow.opacity(0.7)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            // 🎮 Game Scene
            SpriteView(scene: skScene ?? scene)
                .id(sceneID)
                .ignoresSafeArea()
                .allowsHitTesting(false)
                .onAppear {
                    skScene = scene
                }

            // ✋ Drag gesture
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    DragGesture().onChanged { value in
                        skScene?.handlePan(at: value.location)
                    }
                )

            VStack {
                Spacer()

                Divider()
                    .frame(height: 2)
                    .background(Color.gray.opacity(0.3))
                    .padding(.horizontal)
                    .padding(.bottom, 12)

                HStack {
                    HStack(spacing: 6) {
                        ForEach(0..<3, id: \.self) { index in
                            Image(systemName: index < status.wrongCount ? "heart.slash.fill" : "heart.fill")
                                .foregroundColor(index < status.wrongCount ? .gray : .red)
                        }
                    }

                    Spacer()

                    Text("Total Benar: \(status.totalCorrect)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }

            // 🪦 Game Over overlay
            if let gameOverText = status.gameOverText {
                VStack(spacing: 12) {
                    Text(gameOverText)
                        .font(.title2.bold())
                    Text("Tap to Play Again")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    let newScene = GenericGameScene(size: CGSize(width: 390, height: 844), status: status, mode: mode)
                    skScene = newScene
                    sceneID = UUID()
                }
            }
        }
    }
}
