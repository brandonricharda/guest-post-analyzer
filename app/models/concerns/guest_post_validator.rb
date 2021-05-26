class GuestPostValidator < ActiveModel::Validator
    EXCEPTIONS = [GoogleDrive::Error, URI::InvalidURIError]

    def validate(record)
        session = GoogleDriveSession.new.session
        begin
            file = session.file_by_url(record.url)
        rescue GoogleDrive::Error => e
            record.errors.add(:url, "not found in Google Drive") if e.message.include?("The given URL is not a known Google Drive URL")
        rescue URI::InvalidURIError => e
            record.errors.add(:url, "not a valid URL") if e.message.include?("bad URI(is not URI?)")
        end
    end

end