$: << File.expand_path('..', __FILE__)

CONFIG_FOLDER = File.expand_path('../../config', __FILE__)

require 'yaml'
config = YAML.load_file("#{CONFIG_FOLDER}/stack_exchange.yml")

require 'rubyoverflow'
Rubyoverflow::Client.config do |options|
  options.host = config['host']
  options.api_key = config['api_key']
  options.version = config['api_version']
end