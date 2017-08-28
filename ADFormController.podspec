Pod::Spec.new do |spec|
  spec.name         = 'ADFormController'
  spec.version      = '3.0.2'
  spec.authors      = 'Applidium'
  spec.license      = 'none'
  spec.homepage     = 'http://applidium.com'
  spec.summary      = 'Applidium\'s form controller'
  spec.platform     = 'ios', '8.0'
  spec.license      = { :type => 'Commercial', :text => 'Created and licensed by Applidium. Copyright 2016 Applidium. All rights reserved.' }
  spec.source       = { :git => 'ssh://git@gerrit.applidium.net:29418/ADFormController', :tag => "v#{spec.version}" }
  spec.source_files = 'Modules/ADFormController/Classes/*.{h,m,swift}'
  spec.resource_bundle = {'ADFormController' => 'Modules/ADFormController/Ressources/InputAccessoryView.xcassets'}
  spec.framework    = 'Foundation', 'UIKit'
  spec.requires_arc = true
  spec.dependency 'ADKeyboardManager', '~> 2.0'
end
