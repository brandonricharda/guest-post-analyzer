class GoogleDriveSession
    require 'google_drive'
    attr_accessor :session
    def initialize
        @session = GoogleDrive::Session.from_config("config/guest-post-analyzer-1c251269e2f9.json")
    end
end