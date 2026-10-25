# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

# Load custom Gemfile configuration if it exists
custom_gemfile = File.join(__dir__, 'Gemfile.custom')
eval_gemfile(custom_gemfile) if File.exist?(custom_gemfile)
