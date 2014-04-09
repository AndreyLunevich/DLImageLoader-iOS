Pod::Spec.new do |s|

  s.name         = "DLImageLoader"
  s.version      = "1.0.0"
  s.summary      = "DLImageLoader is a reusable instrument for asynchronous image loading and caching."

  s.description  = <<-DESC
                   A longer description of DLImageLoader in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/AndreyLunevich/DLImageLoader-iOS"
  s.license      = "Apache License, Version 2.0"
  s.author             = { "Andrew Lunevich" => "andrey.lunevich@gmail.com" }
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/AndreyLunevich/DLImageLoader-iOS.git", :tag => "1.0.0" }
  s.source_files  = "DLImageLoader", "DLImageLoader/**/*.{h,m}"
end