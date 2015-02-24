desc "Save infographic json to s3"
task :update_infographic => :environment do
  puts "Updating infographic..."
  UpdateInfographic.perform
  puts "done."
end
