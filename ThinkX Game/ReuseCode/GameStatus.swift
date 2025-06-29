import Foundation

class GameStatus: ObservableObject {
    @Published var currentQuestion: String = ""
    @Published var wrongCount: Int = 0
    @Published var totalCorrect: Int = 0
    @Published var gameOverText: String? = nil
}
