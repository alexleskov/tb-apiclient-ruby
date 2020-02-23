class AppConfigurator

  def initialize
    @load_config_file = IO.read('config/secrets.yml')
  end

  def rest_client
    YAML.safe_load(@load_config_file)['rest_client']
  end

  def lms_host
    YAML.safe_load(@load_config_file)['lms_host']
  end

  def client_id
    YAML.safe_load(@load_config_file)['api_client_id']
  end

  def client_secret
    YAML.safe_load(@load_config_file)['api_client_secret']
  end

  def account_id
    YAML.safe_load(@load_config_file)['api_account_id']
  end

  def token_expiration_time
    YAML.safe_load(@load_config_file)['token_expiration_time']
  end
end
