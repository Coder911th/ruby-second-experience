module Constants
  PATH_TO_DATA = File.expand_path("#{File.dirname(__FILE__)}/../../data")
  PATH_TO_DATABASE = "#{Constants::PATH_TO_DATA}/database.csv".freeze
end
