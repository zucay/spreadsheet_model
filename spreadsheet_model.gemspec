# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spreadsheet_model/version'

Gem::Specification.new do |spec|
  spec.name          = "spreadsheet_model"
  spec.version       = SpreadsheetModel::VERSION
  spec.authors       = ["zucay"]
  spec.email         = ["y.kawarazuka@gmail.com"]

  spec.summary       = 'model-like class without database using google spreadsheet'
  spec.description   = 'model-like class without database using google spreadsheet'
  spec.homepage      = 'https://github.com/zucay/spreadsheet_model'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'google_drive', '~> 1.0'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'activemodel'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
