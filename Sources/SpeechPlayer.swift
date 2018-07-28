//
//  SpeechPlayer.swift
//  VoiceKit
//
//  Created by Tatsuya Tanaka on 20180401.
//  Copyright © 2018年 tattn. All rights reserved.
//

import Foundation
import AVFoundation

public final class SpeechPlayer: NSObject {

    private var audioEngine = AVAudioEngine()
    private let audioPlayerNode = AVAudioPlayerNode()
    private var audioFile: AVAudioFile
    private var pitchNode = AVAudioUnitTimePitch()

    public typealias Completion = (Error?) -> Void
    private var completion: Completion?

    public var isPlaying: Bool {
        return audioPlayerNode.isPlaying
    }

    public required init(url: AudioURL = .defaultURL) throws {
        audioFile = try AVAudioFile(forReading: url.url)
        super.init()
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(pitchNode)

        audioEngine.connect(audioPlayerNode, to: pitchNode, format: nil)
        audioEngine.connect(pitchNode, to: audioEngine.outputNode, format: nil)

    }

    public func play(with configuration: Configuration = .init(), completion: Completion? = nil) throws {
        stop()

        audioPlayerNode.rate = configuration.playBackRate
        pitchNode.pitch = configuration.pitch

        audioPlayerNode.scheduleFile(audioFile, at: nil) { [weak self] in
            self?.callCompletion(with: nil)
        }

        try audioEngine.start()
        audioPlayerNode.play()

        self.completion = completion
    }

    public func stop() {
        audioPlayerNode.stop()
    }

    private func callCompletion(with error: Error?) {
        completion?(error)
        completion = nil
    }
}

extension SpeechPlayer {
    public enum Errors: Error {
        case alreadyPlaying
        case unknown
    }

    public struct Configuration {
        public var playBackRate: Float
        public var pitch: Float // from -2400 to 2400
    }
}

extension SpeechPlayer.Configuration {
    public init() {
        self.init(playBackRate: 1.0, pitch: 0)
    }
}
