#
# Be sure to run `pod lib lint STNavigationBarAutoHide.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'STNavigationBarAutoHide'
  s.version          = '0.0.2'
  s.summary          = 'NavigationBar automatically hides when scrolling, same as twitter.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  NavigationBar automatically hides when scrolling, same as twitter. When scrolling up, the NavigationBar will be hidden, and more content can be displayed after hiding. When you swipe down, the navigation bar will appear. The most important thing is that you only need to write one line of code to achieve this function.
                       DESC

  s.homepage         = 'https://github.com/Talon2333/STNavigationBarAutoHide'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'talon' => 'talon23333@gmail.com' }
  s.source           = { :git => 'https://github.com/Talon2333/STNavigationBarAutoHide.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'STNavigationBarAutoHide/Classes/**/*'
  
  # s.resource_bundles = {
  #   'STNavigationBarAutoHide' => ['STNavigationBarAutoHide/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
