require 'active_record'
require 'sqlite3'
require 'yaml'

config_path = File.join(__dir__, 'database.yml')
ActiveRecord::Base.configurations = YAML.load_file(config_path)
ActiveRecord::Base.establish_connection(:development)

# Loads all models
Dir["#{__dir__}/../models/*.rb"].each { |model_file| require model_file }

# Loads all helpers
Dir["#{__dir__}/../helpers/*.rb"].sort.each { |helper_file| require helper_file}
