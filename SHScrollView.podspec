Pod::Spec.new do |s|
    s.name         = "SHScrollView"
    s.version      = "2.8.1"
    s.summary      = "视图轮播，定时滚动"
    s.license      = "MIT"
    s.authors      = { "CCSH" => "624089195@qq.com" }
    s.platform     = :ios, "7.0"
    s.requires_arc = true
    s.homepage     = "https://github.com/CCSH/SHScrollView"
    s.source       = { :git => "https://github.com/CCSH/SHScrollView.git", :tag => s.version }
    s.source_files = "SHScrollView/*.{h,m}"
    s.dependency     "SDWebImage"
end
