class Image
  include DataMapper::Resource

  property :id, Serial
  property :title, Text, :required=>true, :length=>50
  property :filename, String
  property :type, String
  property :size, Integer
  property :data, Blob
  property :summary, Text
  property :latitude, Float
  property :longitude, Float
  property :created_at, DateTime
  property :updated_at, DateTime

  def attachment=(file)
    self.filename = file[:filename]
    self.type = file[:type]
    self.size = file[:tempfile].size
    self.data = file[:tempfile].read

    begin
      sio = StringIO.new(self.data)
      o = EXIFR::JPEG::new(sio)
      la = o.to_hash[:gps_latitude]
      lo = o.to_hash[:gps_longitude]
      if la && lo
        self.latitude = (la[0]+la[1]/60+la[2]/3600).to_f
        self.longitude = (lo[0]+lo[1]/60+lo[2]/3600).to_f
      end
    rescue
    end
  end
end

module AppEngine
  module Images
    class Image
      def scale(factor)
        # make sure width and height are > 0 
        resize([(width * factor).to_i, 1].max, [(height * factor).to_i, 1].max)
      end

      def clip(factor)
        crop(factor, factor, 1.0 - factor, 1.0 - factor)
      end
    end
  end
end
