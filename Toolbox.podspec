Pod::Spec.new do |s|
  s.name             = 'Toolbox'
  s.version          = '0.1.1'
  s.license          = { :type => 'Apache', :file => 'LICENSE' }

  s.summary          = 'Swift util code.'
  s.homepage         = 'https://github.com/lijunzz/Toolbox-iOS'
  s.social_media_url = 'https://github.com/lijunzz'
  s.author           = { 'LiJun' => '29483147+lijunzz@users.noreply.github.com' }

  s.source           = { :git => 'https://github.com/lijunzz/Toolbox-iOS.git', :tag => s.version.to_s }
  s.source_files = 'Sources/**/*.swift'

  s.swift_version = '4.1'

  s.ios.deployment_target = '9.0'
  s.resource_bundles = {
    'Toolbox' => ['Toolbox/Assets/*.png']
  }
end
