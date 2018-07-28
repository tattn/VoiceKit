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

    private let player: AVAudioPlayer

    public typealias Completion = (Error?) -> Void
    private var completion: Completion?

    public var isPlaying: Bool {
        return player.isPlaying
    }

    public required init(url: AudioURL = .defaultURL) throws {
        player = try AVAudioPlayer(contentsOf: url.url)
        super.init()
        player.enableRate = true
        player.delegate = self
    }

    public func play(with configuration: Configuration = .init(), completion: Completion? = nil) throws {
        stop()

        player.rate = configuration.playBackRate
        player.play()
        self.completion = completion
    }

    public func stop() {
        player.stop()
    }

    private func callCompletion(with error: Error?) {
        completion?(error)
        completion = nil
    }
}

extension SpeechPlayer: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        callCompletion(with: flag ? Errors.unknown : nil)
    }

    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        callCompletion(with: error)
    }
}

extension SpeechPlayer {
    public enum Errors: Error {
        case alreadyPlaying
        case unknown
    }

    public struct Configuration {
        public var playBackRate: Float
    }
}

extension SpeechPlayer.Configuration {
    public init() {
        self.init(playBackRate: 1.0)
    }
}
