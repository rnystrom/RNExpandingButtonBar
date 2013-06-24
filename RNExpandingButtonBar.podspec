Pod::Spec.new do |s|
  s.name         = "RNExpandingButtonBar"
  s.version      = "0.0.1"
  s.summary      = "iOS UI widget that mimics the famous button used by the app Path."
  s.description  = <<-DESC
                      RNExpandingButtonBar is a simple iOS widget created by Ryan Nystrom.
                      The widget is designed to be highly portable and customizable.
                      There are no default images or buttons.
                      Everything that you want to use as buttons should be customly made.
                   DESC
  s.homepage     = "https://github.com/rnystrom/RNExpandingButtonBar"
  s.license      = 'MIT'
  s.author       = { "Ryan Nystrom" => "rnystrom@whoisryannystrom.com" }
  s.source       = { :git => "https://github.com/jurre/RNExpandingButtonBar.git" }
  s.platform     = :ios, '5.0'
  s.source_files = '*.{h,m}'
end
