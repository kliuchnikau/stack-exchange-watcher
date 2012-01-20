require 'yaml'

def blather_daemon_credentials
	xmpp_config = YAML.load_file("#{CONFIG_FOLDER}/jabber.yml")
	daemon_id = xmpp_config['daemon_jabber_id']
	daemon_pass = xmpp_config['daemon_jabber_pass']
  [daemon_id, daemon_pass]
end

def get_xmpp_client_id
	YAML.load_file("#{CONFIG_FOLDER}/jabber.yml")['client_jabber_id']
end