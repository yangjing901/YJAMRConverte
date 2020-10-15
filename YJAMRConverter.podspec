#
# Be sure to run `pod lib lint YJAMRConverter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YJAMRConverter'
  s.version          = '0.0.1'
  s.summary          = 'AMR<->WAV 格式转换器'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                            基于opencore-arm的 AMR<->WAV 格式转换器
                       DESC

  s.homepage         = 'https://github.com/yangjing901/YJAMRConverte.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangjing901' => 'yangjing901@qq.com' }
  s.source           = { :git => 'https://github.com/yangjing901/YJAMRConverte.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.static_framework = true

  s.subspec 'lib' do |lib|
      lib.source_files = 'YJAMRConverter/OpenCore/opencore-amrnb/*'
      lib.vendored_libraries = 'YJAMRConverter/OpenCore/lib/*.a'

  end
  
  s.subspec 'wapper' do |wapper|
      wapper.source_files = 'YJAMRConverter/OpenCore/amrwapper/*'
      wapper.compiler_flags = '-fno-objc-arc'
      wapper.dependency 'YJAMRConverter/lib'

  end

  s.subspec 'core' do |core|
      core.source_files = 'YJAMRConverter/Classes/**/*'
      core.dependency 'YJAMRConverter/lib'
      core.dependency 'YJAMRConverter/wapper'
  end
end
