Pod::Spec.new do |s|
    s.name         = "SHScrollView"
    s.version      = "1.0.4"
    s.summary      = "轮播图"
    s.license      = "MIT"
    s.authors      = { "CSH" => "624089195@qq.com" }
    s.platform     = :ios, "7.0"
    s.requires_arc = true
    s.homepage     = "https://github.com/CCSH/SHScrollView"
    s.source       = { :git => "https://github.com/CCSH/SHScrollView.git", :tag => s.version }
    s.source_files = "SHScrollView/*.{h,m}"
    s.dependency     "SDWebImage"
end
