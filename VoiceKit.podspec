Pod::Spec.new do |s|
  s.name             = 'VoiceKit'
  s.version          = '0.0.1'
  s.summary          = "It's a toolkit that includes a convenient implementation of voice related."

  s.description      = <<-DESC
It's a toolkit that includes a convenient implementation of voice related.
It contains SpeechRecorder, SpeechPlayer, SpeechRecognizer and so on...
                       DESC

  s.homepage         = 'https://github.com/tattn/VoiceKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'git' => 'tanakasan2525@gmail.com' }
  s.source           = { :git => 'https://github.com/tattn/VoiceKit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/tanakasan2525'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Sources/**/*'
  
  s.public_header_files = 'Sources/**/*.h'
  s.frameworks = ['Foundation', 'AVFoundation', 'Speech']
end
