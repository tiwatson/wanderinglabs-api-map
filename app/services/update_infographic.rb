class UpdateInfographic

  def self.perform

    url = 'http://wanderinglabs-api-map.herokuapp.com/api/v1/maps/1/infographic.json'
    require 'open-uri'
    content = open(url).read

    require 'aws-sdk-core'
    Aws.config = {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET'],
      :region => 'us-east-1'
    }

    s3 = Aws::S3::Client.new
    resp = s3.put_object(
      :bucket => "live.watsonswander.com",
      :key => "data.json",
      :acl => 'public-read',
      :body => content
    )

  end

end
