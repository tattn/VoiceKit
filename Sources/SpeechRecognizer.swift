//
//  SpeechRecognizer.swift
//  VoiceKit
//
//  Created by Tatsuya Tanaka on 20180401.
//  Copyright © 2018年 tattn. All rights reserved.
//

import Foundation
import Speech

public final class SpeechRecognizer: NSObject {
    private let speechRecognizer: SFSpeechRecognizer
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    public static var authorizationStatus: SFSpeechRecognizerAuthorizationStatus {
        return SFSpeechRecognizer.authorizationStatus()
    }

    public typealias RequestHandler = (_ text: String, _ isFinal: Bool, _ error: Error?) -> Void
    private var handler: RequestHandler?

    public typealias AuthorizationObserver = (_ available: Bool) -> Void
    private var authorizationObserver: AuthorizationObserver?

    public var recognizing: Bool {
        return recognitionTask != nil
    }

    public required init?(locale: Locale) {
        if let speechRecognizer = SFSpeechRecognizer(locale: locale) {
            self.speechRecognizer = speechRecognizer
        } else {
            return nil
        }
        super.init()
        speechRecognizer.delegate = self
    }

    public static func requestAuthorization(handler: @escaping (SFSpeechRecognizerAuthorizationStatus) -> Void) {
        SFSpeechRecognizer.requestAuthorization(handler)
    }

    public func observeAuthorizationStatus(observer: @escaping AuthorizationObserver) {
        authorizationObserver = observer
    }

    public func recognize(session: AVAudioSession? = nil,
                          handler: @escaping RequestHandler) throws {
        guard !audioEngine.isRunning else { throw Errors.alreadyRecording }

        let audioSession: AVAudioSession
        if let session = session {
            audioSession = session
        } else {
            audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
        }
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)

        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        self.recognitionRequest = recognitionRequest
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        try recognize(request: recognitionRequest, handler: handler)

        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }

    public func recognize(url: AudioURL, handler: @escaping RequestHandler) throws {
        let recognitionRequest = SFSpeechURLRecognitionRequest(url: url.url)
        try recognize(request: recognitionRequest, handler: handler)
    }

    public func recognize(request: SFSpeechRecognitionRequest, handler: @escaping RequestHandler) throws {
        guard SpeechRecognizer.authorizationStatus == .authorized else {
            SpeechRecognizer.requestAuthorization { authStatus in
                guard authStatus == .authorized else { return }
                do {
                    try self.recognize(request: request, handler: handler)
                } catch {
                    handler("", false, error)
                }
            }
            return
        }

        recognitionTask?.cancel()

        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                self.handler?(result.bestTranscription.formattedString, result.isFinal, nil)
                if result.isFinal {
                    self.stop()
                }
            } else if let error = error {
                self.handler?("", false, error)
                self.stop()
            }
        }

        self.handler = handler
    }

    public func stop() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest = nil
        recognitionTask = nil
    }

    private func buildAudioPath(fileName: String) -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        return docsDirect.appendingPathComponent(fileName)
    }
}

extension SpeechRecognizer: SFSpeechRecognizerDelegate {
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        authorizationObserver?(available)
    }
}


extension SpeechRecognizer {
    public enum Errors: Error {
        case alreadyRecording
        case unknown
    }
}
