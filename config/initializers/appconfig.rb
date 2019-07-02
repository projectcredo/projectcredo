require 'yaml'

AppConfig = YAML.load_file("#{Rails.root}/config/config.yml") || {}
