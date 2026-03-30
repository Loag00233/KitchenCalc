//
//  SlapDetector.swift
//  KitchenCalc
//

import CoreMotion
import AVFoundation

final class SlapDetector {
    private let motionManager = CMMotionManager()
    private var audioPlayer: AVAudioPlayer?
    private var lastTriggerTime: Date = .distantPast
    private let cooldown: TimeInterval = 0.75
    private let threshold: Double = 2.5

    init() {
        prepareAudio()
        start()
    }

    private func prepareAudio() {
        guard let url = Bundle.main.url(forResource: "-click-nice_3", withExtension: "mp3") else { return }
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.prepareToPlay()
    }

    private func start() {
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.accelerometerUpdateInterval = 0.01
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self, let data else { return }
            let a = data.acceleration
            let magnitude = sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
            guard magnitude > self.threshold else { return }
            let now = Date()
            guard now.timeIntervalSince(self.lastTriggerTime) > self.cooldown else { return }
            self.lastTriggerTime = now
            self.audioPlayer?.currentTime = 0
            self.audioPlayer?.play()
        }
    }

    func stop() {
        motionManager.stopAccelerometerUpdates()
    }
}
