class GoogleDriveSession
    attr_accessor :session
    def initialize
        @session = GoogleDrive::Session.from_config("google-credentials.json")
    end
end