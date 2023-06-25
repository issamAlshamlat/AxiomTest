# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'AxiomTestApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      end
    end
  end
  
# Pods for AxiomTestApp
pod 'SnapKit'
pod 'Swinject'
pod 'ReachabilitySwift'
pod 'Alamofire', '~> 4.9.1'
pod 'SDWebImage', '~> 5.0'
end
