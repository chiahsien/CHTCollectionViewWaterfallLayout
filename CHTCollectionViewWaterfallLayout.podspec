Pod::Spec.new do |s|
  s.name         = "CHTCollectionViewWaterfallLayout"
  s.version      = "0.9.6"
  s.summary      = "The waterfall (i.e., Pinterest-like) layout for UICollectionView."
  s.homepage     = "https://github.com/chiahsien/CHTCollectionViewWaterfallLayout"
  s.screenshots  = "https://raw.github.com/chiahsien/UICollectionViewWaterfallLayout/master/Screenshots/2-columns.png"
  s.license      = 'MIT'
  s.author       = { "Nelson" => "chiahsien@gmail.com" }
  s.source       = { :git => "https://github.com/chiahsien/CHTCollectionViewWaterfallLayout.git", :tag => "#{s.version}" }
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.tvos.deployment_target = '9.0'

  s.default_subspec = 'ObjC'

  s.subspec 'ObjC' do |ss|
    ss.ios.deployment_target = '6.0'
    ss.source_files = '*.{h,m}'
  end

  s.subspec 'Swift' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.source_files = '*.swift'
  end
end
