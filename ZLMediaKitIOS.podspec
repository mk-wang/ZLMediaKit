# run ios_build.sh to build ios_output

Pod::Spec.new do |s|
  s.name         = "ZLMediaKitIOS"
  s.version      = "8.0"
  s.summary      = "WebRTC/RTSP/RTMP/HTTP/HLS/HTTP-FLV/WebSocket-FLV/HTTP-TS/HTTP-fMP4/WebSocket-TS/WebSocket-fMP4/GB28181/SRT server and client framework based on C++11"
  s.homepage     = "https://docs.zlmediakit.com"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "ZLMediaKitIOS" => "1213642868@qq.com" }
  s.platform     = :ios, "12.0"
  s.source       = { :git => "https://github.com/ZLMediaKit/ZLMediaKit.git", :tag => "#{s.version}" }
  s.source_files  = "ios_output/include/**/*.h" 
  s.public_header_files = ['ios_output/include/**/*.h',"ios_output/MediaServer/**/*.h"]
  s.frameworks = "VideoToolbox", "AudioToolbox","AVFoundation","Foundation"
  s.libraries = "c++", "z", "pthread"
  s.vendored_libraries = "ios_output/lib/*.a"
  s.requires_arc = true
end
