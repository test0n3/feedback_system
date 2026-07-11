# frozen_string_literal: true

# require 'sinatra'
# require 'sass-embedded'
# require 'rack/unreloader'
# require './app'

# Sassc
# template = File.read('stylesheets/style.scss')
#
# options = { style: :compressed,
#             filename: 'style.scss',
#             output_path: 'style.css',
#             source_map_file: 'style.css.map',
#             load_path: ['stylesheets'],
#             source_map_contents: true }
#
# engine = SassC::Engine.new(template, options)
#
# css_content = engine.render
# File.write('public/css/style.css', css_content)
#
# map = engine.source_map
# File.write('public/css/style.css.map', map)
# # Or, use compressed output
# compressed = Sass.compile('views/style.scss', style: :compressed)
# File.write('public/style.css', compressed.css)

# Using sass-embedded
# compressed = Sass.compile('stylesheets/style.scss', style: :compressed)
# File.write('public/style.css', compressed.css)

# system('./tailwindcss -i stylesheets/input.css -o public/styles.css')
#
# if ENV['RACK_ENV'] != 'production'
#   Thread.new do
#     system('./tailwindcss -i stylesheets/input.css -o public/styles.css --watch')
#   end
# end

# run App

# using rack-unreloader only for development environment
if ENV['RACK_ENV'] == 'development'
  require 'rack/unreloader'
  Unreloader = Rack::Unreloader.new { App }
  Unreloader.require './app.rb'
  run Unreloader
else
  require_relative 'app'
  run App
end
