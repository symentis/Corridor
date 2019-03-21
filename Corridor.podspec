#
# Be sure to run `pod lib lint Corridor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Corridor'
  s.version          = '1.0.1'
  s.summary          = 'A Coreader-like Dependency Injection μFramework'

  s.description      = <<-DESC
A Coreader-like Dependency Injection μFramework
                       DESC

  s.homepage         = 'https://github.com/symentis/Corridor'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors            = { "symentis GmbH" => "github@symentis.com" }
  s.source           = { :git => 'https://github.com/symentis/Corridor.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.watchos.deployment_target = '4.0'
  s.source_files = 'Sources/**/*'
  

end
