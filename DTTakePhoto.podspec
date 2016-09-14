Pod::Spec.new do |s|
    s.name         = 'DTTakePhoto'
    s.version      = '1.1'
    s.summary      = 'An easy way to use photo'
    s.homepage     = 'https://github.com/veamia/DTTakePhoto'
    s.license      = 'MIT'
    s.authors      = {'veamia' => 'veamia@163.com'}
    s.source       = {:git => 'https://github.com/veamia/DTTakePhoto.git', :tag => s.version}
	s.source_files = "DTTakePhoto", "*.{h,m}"
	s.ios.deployment_target = '8.0'
    s.requires_arc = true
end
