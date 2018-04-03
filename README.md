<h1 align="center">VoiceKit</h1>

<h5 align="center">It's a toolkit that includes a convenient implementation of voice related.</h5>

<div align="center">
  <a href="https://github.com/Carthage/Carthage">
    <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" />
  </a>
  <a href="http://cocoapods.org/pods/VoiceKit">
    <img src="https://img.shields.io/cocoapods/v/VoiceKit.svg" alt="CocoaPods" />
  </a>
  <a href="http://cocoapods.org/pods/VoiceKit">
    <img src="https://img.shields.io/cocoapods/p/VoiceKit.svg" alt="Platform" />
  </a>
  <a href="https://developer.apple.com/swift">
    <img src="https://img.shields.io/badge/Swift-4-F16D39.svg" alt="Swift Version" />
  </a>
  <a href="./LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-green.svg?style=flat-square" alt="license:MIT" />
  </a>
</div>

<br />

# Installation

## Carthage

```ruby
github "tattn/VoiceKit"
```

## CocoaPods

```ruby
pod 'VoiceKit'
```

# Feature

## Record

```swift
let speechRecorder = SpeechRecorder()
try! speechRecorder.record()
speechRecorder.stop()
```

```swift
try! speechRecorder.record(to: .document(filePath: "voice/song.m4a"))
try! speechRecorder.record(to: .temporary(filePath: "voice/song.m4a"))
```

## Play

```swift
let speechPlayer = SpeechPlayer()
try! speechPlayer.play { _ in
    print("finished")
}
speechPlayer.stop()
```

```swift
try! speechPlayer.play(url: .web(url: "https://foo.com/song.m4a"))
try! speechPlayer.play(url: .document(filePath: "voice/song.m4a"))
```

## Speech Recognition

```swift
let speechRecognizer = SpeechRecognizer(locale: .init(identifier: "ja_JP"))!
try! speechRecognizer.recognize { (text, isFinal, error) in
    if isFinal || error != nil {
        print("finished")
    }
    self.textView.text = text
}
speechRecognizer.stop()
```

### Speech Recognition from an audio file

```swift
try! speechRecognizer.recognize(url: .defaultURL) { (text, isFinal, error) in
	if isFinal || error != nil {
		print("finished")
	}
	self.textView.text = text
}
```

# Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

# License

VoiceKit is released under the MIT license. See LICENSE for details.
