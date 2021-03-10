#
# Be sure to run `pod lib lint MJRequest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
  spec.name              = "MJRequest"
  spec.version           = '1.0.0'
  spec.swift_versions    = '5.0'
  spec.license           = { :type => 'MIT', :text => <<-LICENSE
                              Copyright 2019
                              LICENSE
                            }
  spec.summary           = "基础请求"
  spec.description       = <<-DESC
                            基础请求
                            DESC
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage          = 'https://github.com/chenminjie92/MJRequest'
  spec.author            = { "chenminjie" => "chenminjie92@126.com" }

  spec.source            = { :git => "https://github.com/chenminjie92/MJRequest.git", :tag => "#{spec.version}" }
  spec.platform          = :ios, "10.0"
  spec.static_framework  = true

  spec.source_files      = 'MJRequest/**/*.{h,m,swift}'
  spec.dependency 'Moya'  
end
