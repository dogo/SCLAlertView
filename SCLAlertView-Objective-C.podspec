Pod::Spec.new do |spec|
  spec.name         = "SCLAlertView-Objective-C"
  spec.version      = "0.1.2"
  spec.summary      = "Beautiful animated Alert View. Written in Swift but ported to Objective-C"
  spec.homepage     = "https://github.com/dogo/SCLAlertView"
  spec.screenshots  = "https://raw.githubusercontent.com/dogo/SCLAlertView/master/ScreenShots/ScreenShot.png", "https://raw.githubusercontent.com/dogo/SCLAlertView/master/ScreenShots/ScreenShot2.png"

  spec.license            = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Diogo Autilio" => "diautilio@gmail.com" }
  spec.social_media_url   = "http://twitter.com/di_autilio"
  spec.platform           = :ios
  spec.ios.deployment_target = '7.0'
  spec.source             = { :git => "https://github.com/dogo/SCLAlertView.git", :tag => "0.1.2" }
  spec.source_files       = "SCLAlertView/*"
  spec.requires_arc       = true
end
