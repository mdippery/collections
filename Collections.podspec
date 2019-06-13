Pod::Spec.new do |s|
  s.name         = "Collections"
  s.version      = "0.1.3"
  s.summary      = "Bringing Smalltalk and Ruby collections methods to Objective-C since 2011"
  s.description  = <<-DESC
                   **libCollections** is an Objective-C library that brings
                   methods from Smalltalk's collection protocol and Ruby's
                   Enumerable mixin to Objective-C. It adds these methods
                   as categories to the Foundation framework's collections
                   and string classes.

                   In a nutshell, libCollections seeks to add some a
                   functional programming flair to the standard collections
                   and string classes on OS X and iOS.
                   DESC
  s.homepage     = "https://github.com/mdippery/collections"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Michael Dippery" => "michael@monkey-robot.com" }
  s.source       = { :git => "https://github.com/mdippery/collections.git", :tag => "v#{s.version}" }
  s.source_files = "Source"

  s.requires_arc = false

  s.ios.deployment_target = "5.1"
  s.osx.deployment_target = "10.7"
end
