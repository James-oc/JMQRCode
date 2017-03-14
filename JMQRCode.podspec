Pod::Spec.new do |s|

  s.name          = "JMQRCode"
  s.version       = "1.0.0"
  s.license       = "MIT"
  s.summary       = "A qr code generation and scanning tools using Objective-C."
  s.homepage      = "https://github.com/James-oc/JMQRCode"
  s.author        = { "xiaobs" => "1007785739@qq.com" }
  s.source        = { :git => "https://github.com/James-oc/JMQRCode.git", :tag => "1.0.0" }
  s.requires_arc  = true
  s.description   = <<-DESC
                   JMQRCode - A qr code generation and scanning tools using Objective-C.
                   DESC
  s.source_files  = "JMQRCode/*"
  s.platform      = :ios, '8.0'
  s.framework     = 'Foundation', 'UIKit'  

end