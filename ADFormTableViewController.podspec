Pod::Spec.new do |spec|
  spec.name         = 'ADFormTableViewController'
  spec.version      = '1.0.0'
  spec.authors      = 'Applidium'
  spec.license      = 'none'
  spec.homepage     = 'http://applidium.com'
  spec.summary      = 'Applidium\'s form controller'
  spec.platform     = 'ios', '7.0'
  spec.license      = { :type => 'Commercial', :text => 'Created and licensed by Applidium. Copyright 2014 Applidium. All rights reserved.' }
  spec.source       = { :git => 'ssh://git@gerrit.applidium.net:29418/ADFormTableViewController_iOS', :tag => "v#{spec.version}" }
  spec.source_files = 'Modules/ADFormTableViewController/*.{h,m}'
  spec.resources = 'Ressources/Defaults/InputAccessoryView.xcassets'
  spec.framework    = 'Foundation', 'UIKit'
  spec.requires_arc = true
  spec.dependency 'ADKeyboardManager', '~> 2.0'
end
