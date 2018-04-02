//
//  ViewController.swift
//  Example
//
//  Created by Tatsuya Tanaka on 20180401.
//  Copyright © 2018年 tattn. All rights reserved.
//

import UIKit
import VoiceKit

class ViewController: UIViewController {
    @IBOutlet private weak var recordButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var textView: UITextView!

    private let speechRecorder = SpeechRecorder()
    private let speechPlayer = SpeechPlayer()
    private let speechRecognizer = SpeechRecognizer(locale: .init(identifier: "ja_JP"))!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        if speechPlayer.playing {
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
            try! speechRecognizer.recognize(url: .defaultURL) { (text, isFinal, error) in
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

