Pod::Spec.new do |s|
  s.name         = "Datajiexi"
  s.version      = "0.0.1"
  s.summary      = "shujujiexi"
  s.description  = <<-DESC
                   shujujiexi
                   DESC
  s.homepage     = "http://baidu.com"
  s.ios.deployment_target = '7.0'
  s.license      = "MIT"
  s.author       = { "hlq" => "zhiyuan370784@163.com" }#
  s.source       = { :git => "https://github.com/SayHelloWorld/shujujiexi.git", :tag => "#{s.version}" }
  s.source_files  = "shujujiexi/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
end
