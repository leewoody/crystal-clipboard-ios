source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'

use_frameworks!

plugin 'cocoapods-keys', {
  project: 'CrystalClipboard',
  keys: %w[
    CrystalClipboardStagingAdminAuthToken
    CrystalClipboardProductionAdminAuthToken
  ]
}

target 'CrystalClipboard' do
  pod 'Moya/ReactiveSwift', '~> 8.0'
  pod 'Starscream', '~> 2.1'
  pod 'SwiftyJSON', '~> 3.1'
  target 'CrystalClipboardTests'
  target 'CrystalClipboardUITests'
end
