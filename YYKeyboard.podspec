#
# Be sure to run `pod lib lint YYKeyboard.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YYKeyboard'
  s.version          = '0.1.0'
  s.summary          = '用YYLabel实现自定义键盘'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: 用YYLabel实现自定义键盘.逻辑简单，一看就会
                       DESC

  s.homepage         = 'https://github.com/jleisurely/YYKeyboard'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangyu1001@live.cn' => 'wangyu1001@live.cn' }
  s.source           = { :git => 'https://github.com/jleisurely/YYKeyboard.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'YYKeyboard/Classes/**/*'
  s.public_header_files = 'YYKeyboard/Classes/*.h'
  
  s.dependency 'YYKit'
   s.resource_bundles = {
     'YYKeyboard' => ['YYKeyboard/Assets/*.{png,xcassets,plist}']
   }
   
   s.prefix_header_contents =
   '#import "YYKit.h"'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
