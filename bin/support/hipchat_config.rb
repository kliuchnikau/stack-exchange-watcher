require 'yaml'

HipchatConfig = Struct.new(:token, :room)

def hipchat_config
  @hipchat_config ||= begin
    yml_conf = YAML.load_file("#{CONFIG_FOLDER}/hipchat.yml")
    HipchatConfig.new(yml_conf["token"], yml_conf["room"])
  end
end
