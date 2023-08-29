# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'CoWorkMobileApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CoWorkMobileApp
  pod 'RealmSwift', '~> 10.33.0'
  pod 'Cartography'
  pod 'Alamofire'
  pod 'NotificationBannerSwift'
  
  target 'CoWorkMobileAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CoWorkMobileAppUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    target_version = '11.0'
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = target_version
      end
    end
  end

end
