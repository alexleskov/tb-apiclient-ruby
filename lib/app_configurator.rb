require "yaml"

class AppConfigurator

  def get_api_client_id
    YAML.safe_load(IO.read('config/secrets.yml'))['api_client_id']
  end

  def get_api_client_secret
    YAML.safe_load(IO.read('config/secrets.yml'))['api_client_secret']
  end

  def get_api_accountid
    YAML.safe_load(IO.read('config/secrets.yml'))['api_accountid']
  end

  def get_logger
    Logger.new(STDOUT, Logger::DEBUG)
  end
end
