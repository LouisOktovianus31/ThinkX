import SpriteKit
import Combine
import AVFoundation

class GenericGameScene: SKScene, SKPhysicsContactDelegate {
    var status: GameStatus
    let mode: GameMode
    var correctAnswer = 0
    var gameIsOver = false
    var spawnCount = 0

    // Audio
    var bgMusicPlayer: AVAudioPlayer?
    var winSoundPlayer: AVAudioPlayer?
    var loseSoundPlayer: AVAudioPlayer?
    var correctSoundPlayer: AVAudioPlayer?
    var wrongSoundPlayer: AVAudioPlayer?

    // UI
    let soalNode = SKSpriteNode(color: .white, size: CGSize(width: 120, height: 36))
    let soalLabel = SKLabelNode(fontNamed: "Helvetica-Bold")

    init(size: CGSize, status: GameStatus, mode: GameMode) {
        self.status = status
        self.mode = mode
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        playBackgroundMusic()

        // Gradient background
        let image = makeGradientImage(size: size)
        let texture = SKTexture(image: image)
        let gradient = SKSpriteNode(texture: texture)
        gradient.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gradient.zPosition = -100
        addChild(gradient)

        physicsWorld.gravity = CGVector(dx: 0, dy: -2.5)
        physicsWorld.contactDelegate = self

        setupCatchLine()
        setupSoalNode()
        startGame()
    }

    func setupCatchLine() {
        let catchLine = SKNode()
        catchLine.position = CGPoint(x: 0, y: 160)
        catchLine.physicsBody = SKPhysicsBody(edgeFrom: .zero, to: CGPoint(x: size.width, y: 0))
        catchLine.physicsBody?.categoryBitMask = 2
        catchLine.physicsBody?.contactTestBitMask = 1
        catchLine.physicsBody?.collisionBitMask = 0
        addChild(catchLine)
    }

    func setupSoalNode() {
        soalNode.removeFromParent()
        soalNode.alpha = 0.95
        soalNode.position = CGPoint(x: size.width / 2, y: 120)
        soalNode.name = "soalNode"
        soalNode.zPosition = 1

        soalNode.physicsBody = SKPhysicsBody(rectangleOf: soalNode.size)
        soalNode.physicsBody?.isDynamic = false
        soalNode.physicsBody?.categoryBitMask = 2
        soalNode.physicsBody?.contactTestBitMask = 1
        soalNode.physicsBody?.collisionBitMask = 0

        let border = SKShapeNode(rectOf: soalNode.size, cornerRadius: 8)
        border.strokeColor = .gray
        border.lineWidth = 1.5
        border.zPosition = -1
        border.fillColor = .clear
        soalNode.addChild(border)

        soalLabel.fontSize = 20
        soalLabel.fontColor = .black
        soalLabel.verticalAlignmentMode = .center
        soalLabel.horizontalAlignmentMode = .center
        soalLabel.zPosition = 2
        soalLabel.removeFromParent()
        soalNode.addChild(soalLabel)

        addChild(soalNode)
    }

    func startGame() {
        gameIsOver = false
        status.totalCorrect = 0
        status.wrongCount = 0
        status.gameOverText = nil
        spawnCount = 0

        removeAllChildren()
        let image = makeGradientImage(size: size)
        let texture = SKTexture(image: image)
        let gradient = SKSpriteNode(texture: texture)
        gradient.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gradient.zPosition = -100
        addChild(gradient)

        setupCatchLine()
        setupSoalNode()
        generateQuestion()
    }

    func generateQuestion() {
        let (soal, jawaban) = QuestionGenerator.generate(for: mode)
        correctAnswer = jawaban
        soalLabel.text = soal
        status.currentQuestion = soal
    }

    func handlePan(at point: CGPoint) {
        let converted = convertPoint(fromView: point)
        soalNode.position.x = converted.x
    }

    func spawnAnswer() {
        let isCorrect = Bool.random()
        let value = isCorrect ? correctAnswer : randomWrongAnswer()
        let node = SKLabelNode(text: "\(value)")
        node.name = "\(value)"
        node.fontName = "Helvetica"
        node.fontSize = 22
        node.fontColor = .black
        node.position = CGPoint(x: CGFloat.random(in: 40...(size.width - 40)), y: size.height)
        node.physicsBody = SKPhysicsBody(circleOfRadius: 18)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.categoryBitMask = 1
        node.physicsBody?.contactTestBitMask = 2
        node.physicsBody?.collisionBitMask = 0
        node.zRotation = .pi / 60
        addChild(node)
    }

    func randomWrongAnswer() -> Int {
        var wrong = correctAnswer
        while wrong == correctAnswer {
            wrong = Int.random(in: 1...9999)
        }
        return wrong
    }

    override func update(_ currentTime: TimeInterval) {
        guard !gameIsOver else { return }

        spawnCount += 1
        if spawnCount % 60 == 0 {
            spawnAnswer()
        }

        for node in children where node.position.y < -100 {
            node.removeFromParent()
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard !gameIsOver else { return }

        let otherNode = contact.bodyA.node?.name == "soalNode" ? contact.bodyB.node : contact.bodyA.node
        guard let answerNode = otherNode, let value = Int(answerNode.name ?? "") else { return }

        answerNode.removeFromParent()

        if value == correctAnswer {
            status.totalCorrect += 1
            playCorrectSound()
        } else {
            status.wrongCount += 1
            playWrongSound()
        }

        if status.totalCorrect >= 10 {
            endGame(with: "🎉 You Win!")
        } else if status.wrongCount >= 3 {
            endGame(with: "💀 Game Over")
        } else {
            generateQuestion()
        }
    }

    func endGame(with message: String) {
        gameIsOver = true
        status.gameOverText = message

        bgMusicPlayer?.stop()
        if message.contains("Win") {
            playWinSound()
        } else {
            playLoseSound()
        }
    }

    func playBackgroundMusic() {
        if let url = Bundle.main.url(forResource: "bg_music", withExtension: "mp3") {
            bgMusicPlayer = try? AVAudioPlayer(contentsOf: url)
            bgMusicPlayer?.numberOfLoops = -1
            bgMusicPlayer?.volume = 0.5
            bgMusicPlayer?.play()
        }
    }

    func playWinSound() {
        if let url = Bundle.main.url(forResource: "win_sound", withExtension: "mp3") {
            winSoundPlayer = try? AVAudioPlayer(contentsOf: url)
            winSoundPlayer?.play()
        }
    }

    func playLoseSound() {
        if let url = Bundle.main.url(forResource: "lose_sound", withExtension: "mp3") {
            loseSoundPlayer = try? AVAudioPlayer(contentsOf: url)
            loseSoundPlayer?.play()
        }
    }

    func playCorrectSound() {
        if let url = Bundle.main.url(forResource: "correct_hit", withExtension: "mp3") {
            correctSoundPlayer = try? AVAudioPlayer(contentsOf: url)
            correctSoundPlayer?.play()
        }
    }

    func playWrongSound() {
        if let url = Bundle.main.url(forResource: "wrong_hit", withExtension: "mp3") {
            wrongSoundPlayer = try? AVAudioPlayer(contentsOf: url)
            wrongSoundPlayer?.play()
        }
    }

    func makeGradientImage(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let context = ctx.cgContext
            let colors = [
                UIColor(red: 1.0, green: 0.65, blue: 0.0, alpha: 1).cgColor,
                UIColor(red: 1.0, green: 0.9, blue: 0.6, alpha: 1).cgColor
            ] as CFArray

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!
            context.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: size.width, y: size.height), options: [])
        }
    }
}
