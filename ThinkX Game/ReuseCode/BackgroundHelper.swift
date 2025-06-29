import Foundation
import SpriteKit
import UIKit

struct BackgroundHelper {
    static func addGradientBackground(to scene: SKScene) {
        // Hapus background lama (kalau ada)
        scene.childNode(withName: "background")?.removeFromParent()

        let size = scene.size
        let image = makeGradientImage(size: size)
        let texture = SKTexture(image: image)
        let background = SKSpriteNode(texture: texture)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -100
        background.name = "background"
        scene.addChild(background)
    }

    private static func makeGradientImage(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let context = ctx.cgContext

            let colors = [
                UIColor(red: 1.0, green: 0.65, blue: 0.0, alpha: 1).cgColor,
                UIColor(red: 1.0, green: 0.9, blue: 0.6, alpha: 1).cgColor
            ] as CFArray

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!

            context.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )
        }
    }
}
