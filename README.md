VoiceKit
===

# Record

```swift
let speechRecorder = SpeechRecorder()
try! speechRecorder.record()
speechRecorder.stop()
```

```swift
try! speechRecorder.record(to: .document(filePath: "voice"))
try! speechRecorder.record(to: .temporary(filePath: "voice"))
```

# Play

```swift
let speechPlayer = SpeechPlayer()
try! speechPlayer.play { _ in
    print("finished")
}
speechPlayer.stop()
```

```swift
try! speechPlayer.play(url: .web(url: "https://hoge.com"))
try! speechPlayer.record(url: .document(filePath: "voice"))
```

# Speech Recognition

```swift
let speechRecognizer = SpeechRecognizer(locale: .init(identifier: "ja_JP"))!
try! speechRecognizer.recognize(url: .defaultURL) { (text, isFinal, error) in
    if isFinal || error != nil {
        print("finished")
    }
    self.textView.text = text
}
speechRecognizer.stop()
```

# Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

# License

VoiceKit is released under the MIT license. See LICENSE for details.
