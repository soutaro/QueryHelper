Pod::Spec.new do |s|
  s.name         = "QueryHelper"
  s.version      = "1.0.0"
  s.summary      = "Image cropping library for iOS, similar to the Photos.app UI."
  s.homepage     = "https://github.com/ubiregiinc/QueryHelper"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "soutaro" => "matsumoto@ubiregi.com" }
  s.authors      = { "soutaro" => "matsumoto@ubiregi.com" }
  s.source       = { :git => "https://github.com/ubiregiinc/QueryHelper.git", :tag => "v1.0.0" }
  s.ios.deployment_target = '5.0'
  s.source_files = 'QueryHelper/**.{h,m}'
  s.framework  = 'CoreData'
  s.requires_arc = true
end
