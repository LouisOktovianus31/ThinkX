import Foundation

enum GameMode {
    case dasar        // 1×1 sampai 10×10
    case satuDigit    // 11×1 sampai 99×9
    case duaDigit     // 11×11 sampai 99×99
    case tigaDigit    // 111×111 sampai 999×999
    case angka11      // 11×1 sampai 11×99
    case angka99      // 99×1 sampai 99×99

    var displayName: String {
        switch self {
        case .dasar: return "Perkalian Dasar"
        case .satuDigit: return "Perkalian 1 Digit"
        case .duaDigit: return "Perkalian 2 Digit"
        case .tigaDigit: return "Perkalian 3 Digit"
        case .angka11: return "Perkalian Angka 11"
        case .angka99: return "Perkalian Angka 99"
        }
    }
}
