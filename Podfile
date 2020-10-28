source 'ssh://git@codereview.technologies.fabernovel.com:29418/CocoaPodsSpecs'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!

pod 'CocoaLumberjack/Swift', '~>  3.5', :inhibit_warnings => true
pod 'ADDynamicLogLevel', '~>  2.0', :inhibit_warnings => true

abstract_target 'Form' do
    pod 'ADFormController', :path => './'

    target 'FormDemo' do
      pod 'Alamofire', '~> 4.8'
      pod 'Watchdog', '~> 4.0'
      pod 'ADUtils', '~> 9.3'
    end

    target 'FormDemoTests' do
      pod 'Quick', '~> 2.1'
      pod 'Nimble', '~> 8.0'
      pod 'Nimble-Snapshots', '~> 4.3.0'
      pod 'OCMock', '~> 3.3'
      pod 'FBSnapshotTestCase', '~> 2.1'
    end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = "5.0"

      # Change the Optimization level for each target/configuration
      if !config.name.include?("Distribution")
        config.build_settings['GCC_OPTIMIZATION_LEVEL'] = '0'
      end

      # Disable Pod Codesign
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
    end
  end
end
