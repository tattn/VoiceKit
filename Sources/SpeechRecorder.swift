//
//  SpeechRecorder.swift
//  VoiceKit
//
//  Created by Tatsuya Tanaka on 20180401.
//  Copyright © 2018年 tattn. All rights reserved.
//

import Foundation
import AVFoundation

public final class SpeechRecorder: NSObject {
    private var recorder: AVAudioRecorder?

    public typealias Completion = (Error?) -> Void
    private var completion: Completion?

    public var recording: Bool {
        return recorder != nil
    }

    public required override init() {
        super.init()
    }

    public func record(to url: AudioURL = .defaultURL,
                       session: AVAudioSession? = nil,
                       settings: [String: Any] = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                                                  AVSampleRateKey: 44100,
                                                  AVNumberOfChannelsKey: 2,
                                                  AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue],
                       completion: Completion? = nil) throws {
        guard !recording else { throw Errors.alreadyRecoding }

        let audioSession: AVAudioSession
        if let session = session {
            audioSession = session
        } else {
            audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        }
        try audioSession.setActive(true)

        try createDirectoryIfNeeded(url: url)

        let recorder = try AVAudioRecorder(url: url.url, settings: settings)
        self.recorder = recorder
        recorder.delegate = self
        recorder.record()
        
        self.completion = completion
    }

    public func stop() {
        recorder?.stop()
        recorder = nil
    }

    private func callCompletion(with error: Error?) {
        completion?(error)
        completion = nil
        self.recorder = nil
    }
}

extension SpeechRecorder: AVAudioRecorderDelegate {

    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        callCompletion(with: flag ? Errors.unknown : nil)
    }

    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        callCompletion(with: error)
    }
 }

extension SpeechRecorder {
    public enum Errors: Error {
        case alreadyRecoding
        case unknown
    }
}
