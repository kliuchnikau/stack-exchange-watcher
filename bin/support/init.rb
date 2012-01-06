$LOAD_PATH.unshift File.expand_path('../../../lib/', __FILE__)
require 'stack_exchange'
require 'view_cli'

CONFIG_FOLDER = File.expand_path('../../../config', __FILE__)
def get_se_client
  require 'yaml'
  config = YAML.load_file("#{CONFIG_FOLDER}/stack_exchange.yml")

  require 'rubyoverflow'
  Rubyoverflow::Client.new( {host: config['host'], version: config['api_version'], api_key: config['api_key']})
end