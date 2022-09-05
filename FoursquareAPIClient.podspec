#
# Be sure to run `pod lib lint FoursquareAPIClient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FoursquareAPIClient"
  s.version          = "5.0.2"
  s.summary          = "Very simple Swift networking library for Foursquare API v2"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = "FoursquareAPIClient is very simple Swift networking library for Foursquare API v2"
  s.homepage         = "https://github.com/koogawa/FoursquareAPIClient"
  s.screenshots     = "https://raw.githubusercontent.com/koogawa/FoursquareAPIClient/master/screen.png"
  s.license          = 'MIT'
  s.author           = { "koogawa" => "koogawa.app@gmail.com" }
  s.source           = { :git => "https://github.com/koogawa/FoursquareAPIClient.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/koogawa'

  s.platform     = :ios, '12.0'
  s.requires_arc = true
  s.swift_versions = ['4.2', '5']

  s.source_files = 'FoursquareAPIClient/*.swift'
  # s.resource_bundles = {
  #   'FoursquareAPIClient' => ['Pod/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.pod_target_xcconfig =  {
    'SWIFT_VERSION' => '5.0'
  }
end
