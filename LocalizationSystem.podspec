Pod::Spec.new do |s|
	s.name         = "LocalizationSystem"
  	s.version      = "0.0.1"
  	s.summary      = "Internal library for more complex localization than built in to Cocoa."
  	s.description  = <<-DESC
  	Internal library for mode complex localization than what Cocoa's built in system can deal with.
   	                 DESC
  	s.homepage     = "http://EXAMPLE/LocalizationSystem"
  	s.license      = 'None'
  	s.author       = { "Andy Molloy" => "asmolloy@me.com" }
  	s.source       = { :git => "ssh://git@bitbucket.org/amolloy/localizationsystem.git",
  					   :tag => "0.0.1" }
  	s.source_files = 'LocalizationSystem/**/*.{h,m}'
  	s.requires_arc = true
  	s.platform     = :ios
end
