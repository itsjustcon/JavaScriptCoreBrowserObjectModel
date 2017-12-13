#
# Be sure to run `pod lib lint JavaScriptCoreBrowserObjectModel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JavaScriptCoreBrowserObjectModel'
  s.version          = '0.1.0'
  s.summary          = 'A short description of JavaScriptCoreBrowserObjectModel.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/itsjustcon/JavaScriptCoreBrowserObjectModel'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Connor Grady' => 'conair360@gmail.com' }
  s.source           = { :git => 'https://github.com/itsjustcon/JavaScriptCoreBrowserObjectModel.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/itsjustcon'

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'Source/*.swift'

  # s.resource_bundles = {
  #   'JavaScriptCoreBrowserObjectModel' => ['JavaScriptCoreBrowserObjectModel/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'JavaScriptCore'
  # s.dependency 'AlamoFire', '~> 4.6'
end
