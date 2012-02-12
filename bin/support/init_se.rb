def get_se_client
	require 'yaml'
	config = YAML.load_file("#{CONFIG_FOLDER}/stack_exchange.yml")

	require 'rubyoverflow'
  # TODO: parametrize this method with host and get only api_key from the config
	Rubyoverflow::Client.new({host: config['host'], version: config['api_version'], api_key: config['api_key']})
end