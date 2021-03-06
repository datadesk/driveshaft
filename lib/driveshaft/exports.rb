Dir.glob(File.expand_path('../exports/*.rb', __FILE__)).each do |f|
  require f
end

module Driveshaft
  module Exports
    FORMATS = (Driveshaft::Exports.methods - Object.methods)

    def self.export(file, format, *clients)
      # Try multiple clients (first a server client if available, then user's
      # browser session).
      error = nil

      clients.each do |client|
        begin
          return Driveshaft::Exports.send(format.to_sym, file, client)
        rescue Exception => e
          error = e
        end
      end

      raise error if error
    end

    def self.default_format_for(file)
      {
        'application/vnd.google-apps.spreadsheet' => 'spreadsheet',
        'application/vnd.google-apps.document' => 'archieml'
      }[file['mimeType']]
    end
  end
end
