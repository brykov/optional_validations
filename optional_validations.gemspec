Gem::Specification.new do |spec|
  spec.name        = 'optional_validations'
  spec.version     = '0.1.2'
  spec.date        = '2015-09-24'
  spec.summary     = 'Provides ability to choose ActiveModel fields to be validated'
  spec.description = 'Introduces new ActiveModel::Validations methods — validate_only and validate_except'
  spec.author      = 'Ivan Brykov'
  spec.files       = Dir['lib/*.rb'] + Dir['test/**/*'] + ['Rakefile']
  spec.homepage    =
      'https://github.com/brykov/optional_validations'
  spec.license       = 'MIT'
  spec.add_development_dependency 'minitest', '~> 5'
  spec.add_runtime_dependency 'activesupport', '~> 4'
  spec.add_runtime_dependency 'activemodel', '~> 4'
end