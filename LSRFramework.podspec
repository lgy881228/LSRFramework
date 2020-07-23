
Pod::Spec.new do |s|


  
    s.name         = "LSRFramework"
    s.version      = "1.1.2"
    s.summary      = "UI Framework for LSRTeam."

	s.description  = <<-DESC
	LSRFramework is a simple framework for building ui interfaces, after you have configured the appropriate interface properties (especially the navigation bar), you don't have to worry about whether other interface modifications will have a negative impact on the interface. In fact, the interface will restore itself to its original appearance.
	DESC

    s.homepage     = "https://github.com/lgy881228/LSRFramework"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "lgy881228" => "510687394@qq.com" }
    s.source       = { :git => "https://github.com/lgy881228/LSRFramework.git", :tag => s.version }

    s.platform     = :ios
    s.platform     = :ios, "11.0"
    s.ios.deployment_target = "11.0"
	
    s.requires_arc = true
    
    s.xcconfig     = { "GCC_PREPROCESSOR_DEFINITIONS" => 'TTTFRAMEWORK=1' }

    s.preserve_paths = "LSRFramework/Classes/**/*", "LSRFramework/Assets/**/*", #{s.name}/Framework/**/*", "#{s.name}/Archive/**/*"

    s.source_files        = "LSRFramework/Classes/**/*.{h,m,mm,c,cpp,cc}"
    s.public_header_files = "LSRFramework/Classes/**/*.h"
    # s.vendored_frameworks = "LSRFramework/Assets/**/*.framework"

    s.resources    = "LSRFramework/Assets/TTTFramework.bundle"

    s.frameworks   =  'SystemConfiguration', 'WebKit', 'AVFoundation', 'Photos'

    s.dependency 'MBProgressHUD'
    s.dependency 'Masonry'
   


end
