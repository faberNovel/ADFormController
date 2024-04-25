source 'https://cdn.cocoapods.org/'

platform :ios, '13.0'
use_frameworks!

pod 'CocoaLumberjack/Swift', '~>  3.5', :inhibit_warnings => true

abstract_target 'Form' do
    pod 'ADFormController', :path => './'

    target 'FormDemo' do
      pod 'Alamofire', '~> 5.0'
      pod 'Watchdog', '~> 5.0'
      pod 'ADUtils', '~> 11.0'
    end

    target 'FormDemoTests' do
      pod 'Quick', '~> 7.0'
      pod 'Nimble', '~> 13.0'
      pod 'Nimble-Snapshots', '~> 9.3'
      pod 'OCMock', '~> 3.3'
      pod 'FBSnapshotTestCase', '~> 2.1'
    end

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            if target.name == 'Watchdog' || target.name == 'FBSnapshotTestCase'
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
                end
            end
        end
    end
end
