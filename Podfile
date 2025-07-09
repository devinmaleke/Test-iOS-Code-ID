# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Test_Code_ID' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Test_Code_ID
  pod 'Kingfisher'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'XLPagerTabStrip'
  pod 'IQKeyboardManagerSwift'
  pod 'Alamofire'
  pod 'RxSwift', '6.9.0'
  pod 'RxCocoa', '6.9.0'

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end
  target 'Test_Code_IDTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Test_Code_IDUITests' do
    # Pods for testing
  end

end
