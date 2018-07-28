//
//  VoiceChangerViewController.swift
//  Example
//
//  Created by Tatsuya Tanaka on 20180728.
//  Copyright © 2018年 tattn. All rights reserved.
//

import Foundation
import VoiceKit

class VoiceChangerViewController: UIViewController {

    var player: SpeechPlayer!
    var configuration = SpeechPlayer.Configuration()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func didTapPlayButton(_ sender: UIButton) {
        let path = Bundle.main.url(forResource: "SampleVoice", withExtension: "m4a")!
        do {
            player = try SpeechPlayer(url: .fullPath(path))
            try player.play(with: configuration)
        } catch {
            print(error)
        }

    }

    @IBAction func didChangePlalybackRate(_ sender: UISlider) {
        configuration.playBackRate = sender.value
    }
}
