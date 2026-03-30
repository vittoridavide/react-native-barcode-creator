require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-barcode-creator"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/VittoriDavide/react-native-barcode-creator.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,swift}"
  s.swift_version = "5.0"
  s.pod_target_xcconfig = {
    "DEFINES_MODULE" => "YES"
  }

  if respond_to?(:install_modules_dependencies, true)
    install_modules_dependencies(s)
  elsif respond_to?(:install_module_dependencies, true)
    install_module_dependencies(s)
  else
    s.dependency "React-Core"
  end
end
