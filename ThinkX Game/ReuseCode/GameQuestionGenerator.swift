import Foundation

struct QuestionGenerator {
    static func generate(for mode: GameMode) -> (soal: String, jawaban: Int) {
        var a = 0
        var b = 0

        switch mode {
        case .dasar:
            a = Int.random(in: 1...10)
            b = Int.random(in: 1...10)

        case .satuDigit:
            a = Int.random(in: 11...99)
            b = Int.random(in: 1...9)

        case .duaDigit:
            a = Int.random(in: 11...99)
            b = Int.random(in: 11...99)

        case .tigaDigit:
            a = Int.random(in: 111...999)
            b = Int.random(in: 111...999)

        case .angka11:
            a = 11
            b = Int.random(in: 1...99)

        case .angka99:
            a = 99
            b = Int.random(in: 1...99)
        }

        let soal = "\(a) × \(b)"
        let jawaban = a * b
        return (soal, jawaban)
    }
}
