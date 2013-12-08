require 'yaml'

HipchatConfig = Struct.new(:token_id, :room_id)

def hipchat_config
  @hipchat_config ||= begin
    yml_conf = YAML.load_file("#{CONFIG_FOLDER}/jabber.yml")
    HipchatConfig.new(yml_conf["token_id"], yml_conf["room_id"])
  end
end
