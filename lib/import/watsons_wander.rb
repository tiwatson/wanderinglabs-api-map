module Import
class WatsonsWander

=begin

40.178833, -105.889770
40.376924, -106.730487

  MapPlace.create(map_id: 1, title: 'Forest Rd 296', arrived: Date.parse('11-06-2017'), latitude: 40.376924, longitude: -106.730487, price: 0, category: 'NFB')
  load('import/watsons_wander.rb') && Import::WatsonsWander.import('11-06-2017')

  MapPlace.find_each { |m| m.save }; UpdateInfographic.perform

  curl https://wanderinglabs-api-map.herokuapp.com/api/v1/maps/1.json > track_points.json
  curl https://wanderinglabs-api-map.herokuapp.com/api/v1/maps/1/d3_current.json > current.json
=end

  def parse_out_descriptions
    MapPlace.find_each do |mp|
      d = Nokogiri::HTML(mp.description)

      d.css('a').each do |link|
        if link['href'].present?
          MapPlaceLink.create(map_place_id: mp.id, url: link['href'], title: link.text)
        end
      end
    end

  end


  # Day - Month - Year
  def self.import(arrived = '13-12-2014')
    require 'zip'

    xml = ''
    Zip::File.open("#{Rails.root}/public/import/#{arrived}.kmz") do |zip_file|
      entry = zip_file.glob('*.kml').first
      xml = entry.get_input_stream.read
    end

    doc = Nokogiri::XML(xml)
    doc.remove_namespaces!

    placemark = doc.xpath('//Document/Placemark').select { |p| p.xpath('LineString').present? }.first
    path = placemark.xpath('LineString')[0].xpath('coordinates')[0].text.split(' ').collect { |p| p.split(',')[0..1] }

    map_item = MapPlace.where(arrived: Date.parse(arrived)).first
    map_item.arrival_path = path
    map_item.save

  end


  def self.import_json
    json = JSON.parse(IO.read("#{Rails.root}/tmp/google/track_points.json"))
    year_2 = json['points'].select { |p| p['properties']['year'] == 2 }.reverse

    year_2.each do |p|
      pp = p['properties']

      travel_date = pp['date_i']
      travel_date_parse = "#{travel_date.split('-')[1]}-#{travel_date.split('-')[0]}-#{travel_date.split('-')[2]}"
      travel_date_date = Date.parse(travel_date_parse)
      Rails.logger.debug travel_date_parse

      map_item = MapPlace.find_or_initialize_by(map_id: 1, longitude: p['geometry']['coordinates'][0], latitude: p['geometry']['coordinates'][1], arrived: travel_date_date)

      map_item.description = pp['description'] || ''
      map_item.title = pp['name']
      map_item.price = pp['price'].gsub('$','')
      map_item.city = pp['city']
      map_item.state = pp['state']

      map_item.arrival_path = []
      park_type = pp['park_type'].gsub('Campground', '').strip
      map_item.category = MapPlace::CATEGORY_NAMES.key( park_type )
      Rails.logger.debug "CAT -#{park_type}- #{MapPlace::CATEGORY_NAMES.key( park_type )}"
      map_item.save
    end


  end


  def self.import_kml(id)

    Rails.logger.debug "-#-#-#-#-#-#-# IMPORT #{id} -#-#-#-#-#-#-#-#-#-#-#"

    require 'open-uri'

    imported = Time.now

    doc = Nokogiri::XML(IO.read("#{Rails.root}/tmp/google/#{id}.kml"))
    doc.remove_namespaces!


    ##### POINTS #####
    travel_date = '6-14-2012'
    travel_date_year = 2012
    track = []

    doc.xpath('//Document/Placemark').each do |i|
      Rails.logger.debug "---------------- #{i.xpath('name').text} -----------"
      if i.xpath('Point')[0].nil?

        travel_date = i.xpath('name').text
        if travel_date.split('-').size == 3
          travel_date_year = travel_date.split('-')[2]
        else
          travel_date << "-#{travel_date_year}"
        end

        track = i.xpath('LineString/coordinates').map do |i|
          i.children[0].to_s.gsub(',0.000000','').split("\n").collect { |x| x.split(',').collect{ |n| n.to_f }}.reject{ |y| y.size <= 1}
        end
        track = track.flatten(1)

        Rails.logger.debug "TRACK - #{track.size} - #{travel_date}"
        if track.size > 10
          track = track.select_with_index { |v,i| (i % (track.size / 10) == 0) }
        end

        next
      end

      i_points = i.xpath('Point/coordinates').text.gsub(',0.000000','').split(',').map{ |n| n.to_f }

      # dc_i = i_points.join('')
      # begin
      #   gc = @diskcache.get( dc_i )
      #   logger.debug "CACHED #{dc_i}"
      # rescue Diskcached::NotFound
      #   logger.debug "NF #{dc_i}"
      #   gc = Geocoder.search("#{i_points[1]},#{i_points[0]}")
      #   @diskcache.set(dc_i, gc) unless gc.nil?
      # end

      # if gc.first.nil?
      #   logger.debug "BAD GC #{gc.inspect}"
      #   next
      # end


      travel_date_parse = "#{travel_date.split('-')[1]}-#{travel_date.split('-')[0]}-#{travel_date.split('-')[2]}"
      travel_date_date = Date.parse(travel_date_parse)
      Rails.logger.debug travel_date_parse
      travel_date_dt = DateTime.parse(travel_date_parse).strftime('%b %e')


      description = i.xpath('description').text
      description.sub!(/#(\w+)/,'')
      type_key = $1
      # park_type = ''
      # park_type = park_type_hash[type_key.to_sym] unless type_key.nil?

      description.sub!(/(\$\d+)/,'')
      price = $1
      if price.nil?
        description.sub!(/(\$\d+\.\d\d)/,'')
        price = $1
      end

      price.gsub!('$','')
      price = '' if price.nil?

        # {
        #   :type => "Feature",
        #   :properties => {:name => i.xpath('name').text, :description => description, :city => gc.first.city, :state => gc.first.state, :date => travel_date_dt, :date_i => travel_date, :park_type => park_type, :price => price, :year => year},
        #   :geometry => {:type => 'Point', :coordinates => i_points}
        # }

      map_item = MapPlace.find_or_initialize_by(map_id: 1, longitude: i_points[0], latitude: i_points[1], arrived: travel_date_date)
      Rails.logger.debug "MI NEW? #{map_item.new_record?}"
      #logger.debug map_item.inspect

      map_item.description = description
      map_item.title = i.xpath('name').text
      map_item.price = price

      map_item.arrival_path = track || []
      map_item.category = type_key
      #logger.debug map_item.inspect

      map_item.save

    end

    # MapPlace.where('map_import_timestamp != ?', imported).find_each do |mi|
    #   mi.destroy
    # end

  end


end
end
