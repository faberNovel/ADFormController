source 'git@scm.applidium.net:CocoaPodsSpecs.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'
use_frameworks!

pod 'CocoaLumberjack/Swift', '~>  2.0', :inhibit_warnings => true
pod 'ADDynamicLogLevel', '~>  1.1', :inhibit_warnings => true

target 'FormDemo' do
  pod 'Alamofire', '~> 3.0'
  pod 'HockeySDK', '~> 3.8', :subspecs => ['CrashOnlyLib']
  pod 'Watchdog', '~> 1.0'
  pod 'ADFormController', :path => './'
end

target 'FormDemoTests' do
  pod 'Quick', '~> 0.9'
  pod 'Nimble', '~> 4.0'
  pod 'Nimble-Snapshots', '~> 4.1'
  pod 'OCMock', '~> 3.3'
  pod 'FBSnapshotTestCase', '~> 2.1'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        end
    end
end
