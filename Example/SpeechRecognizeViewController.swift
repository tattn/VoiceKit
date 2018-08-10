//
//  SpeechRecognizeViewController.swift
//  Example
//
//  Created by Tatsuya Tanaka on 20180401.
//  Copyright © 2018年 tattn. All rights reserved.
//

import UIKit
import VoiceKit

class SpeechRecognizeViewController: UIViewController {
    @IBOutlet private weak var recordButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var textView: UITextView!

    private let speechRecorder = SpeechRecorder()
    private var speechPlayer: SpeechPlayer?
    private let speechRecognizer = SpeechRecognizer(locale: .init(identifier: "ja_JP"))!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechRecorder.isMeteringEnabled = true
        let timer = Timer.init(timeInterval: 0.1, repeats: true) { _ in
            print(self.speechRecorder.currentAveragePower)
        }
        RunLoop.main.add(timer, forMode: .commonModes)
    }

    @IBAction func didTapRecordButton(_ sender: UIButton) {
        if speechRecorder.recording {
            speechRecorder.stop()
            sender.setTitle("Record", for: .normal)
        } else {
            try! speechRecorder.record(to: .document(filePath: "voice"))
            sender.setTitle("Stop", for: .normal)
        }
    }

    @IBAction func didTapPlayButton(_ sender: UIButton) {
        guard let speechPlayer = try? SpeechPlayer() else { return }
        self.speechPlayer = speechPlayer
        if speechPlayer.isPlaying {
            speechPlayer.stop()
            sender.setTitle("Play", for: .normal)
        } else {
            try! speechPlayer.play { _ in
                sender.setTitle("Play", for: .normal)
            }
            sender.setTitle("Stop", for: .normal)
        }
    }

    @IBAction func didTapRecognizeButton(_ sender: UIButton) {
        if speechRecognizer.recognizing {
            speechRecognizer.stop()
            sender.setTitle("Recognize", for: .normal)
        } else {
            try! speechRecognizer.recognize { (text, isFinal, error) in
                if isFinal || error != nil {
                    sender.setTitle("Recognize", for: .normal)
                }
                self.textView.text = text
            }
            sender.setTitle("Stop", for: .normal)
        }
    }

    @IBAction func didTapRecognizeAudioFileButton(_ sender: UIButton) {
        if speechRecognizer.recognizing {
            speechRecognizer.stop()
            sender.setTitle("Recognize", for: .normal)
        } else {
            try! speechRecognizer.recognize(url: .defaultURL) { (text, isFinal, error) in
                if isFinal || error != nil {
                    sender.setTitle("Recognize", for: .normal)
                }
                self.textView.text = text
            }
            sender.setTitle("Stop", for: .normal)
        }
    }
}

