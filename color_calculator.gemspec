require_relative 'lib/color_calculator/version'

Gem::Specification.new do |gem|
  gem.authors = ['Nathan Seither']
  gem.email = ['nathanseither@gmail.com']
  gem.homepage = 'https://github.com/Supernats/color_calculator'
  gem.summary = 'Color math calculators and converters'
  gem.description = 'You can do color math now!'
  gem.license = 'MIT'
  gem.files = Dir['lib/**/**.rb', 'Gemfile', 'Rakefile']
  gem.name = 'color_calculator'
  gem.version = ColorCalculator::VERSION
  gem.required_ruby_version = '>= 2.6.0'
end
