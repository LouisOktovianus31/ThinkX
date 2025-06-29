import Foundation
import AVFoundation

class MusicManager {
    static let shared = MusicManager()

    private var bgPlayer: AVAudioPlayer?
    private var sfxPlayer: AVAudioPlayer?

    func playBackgroundMusic() {
        playMusic(filename: "bg_music", loop: true)
    }

    func stopBackgroundMusic() {
        bgPlayer?.stop()
        bgPlayer = nil
    }

    func playWinSound() {
        playSFX(filename: "win_sound")
    }

    func playLoseSound() {
        playSFX(filename: "lose_sound")
    }

    func playCorrectHit() {
        playSFX(filename: "correct_hit")
    }

    func playWrongHit() {
        playSFX(filename: "wrong_hit")
    }

    private func playMusic(filename: String, loop: Bool = false) {
        if let url = Bundle.main.url(forResource: filename, withExtension: "mp3") {
            do {
                bgPlayer = try AVAudioPlayer(contentsOf: url)
                bgPlayer?.numberOfLoops = loop ? -1 : 0
                bgPlayer?.play()
            } catch {
                print("Failed to play background music: \(error.localizedDescription)")
            }
        }
    }

    private func playSFX(filename: String) {
        if let url = Bundle.main.url(forResource: filename, withExtension: "mp3") {
            do {
                sfxPlayer = try AVAudioPlayer(contentsOf: url)
                sfxPlayer?.play()
            } catch {
                print("Failed to play SFX: \(error.localizedDescription)")
            }
        }
    }
}
