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

    private var player: AVAudioPlayer?

    public typealias Completion = (Error?) -> Void
    private var completion: Completion?

    public var playing: Bool {
        return player != nil
    }

    public required override init() {
        super.init()
    }

    public func play(url: AudioURL = .defaultURL,
                     completion: Completion? = nil) throws {
        guard !playing else { throw Errors.alreadyPlaying }
        
        let player = try! AVAudioPlayer(contentsOf: url.url)
        self.player = player

        player.delegate = self
        player.play()
        self.completion = completion
    }

    public func stop() {
        player?.stop()
        player = nil
    }

    private func callCompletion(with error: Error?) {
        completion?(error)
        completion = nil
        player = nil
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
}
