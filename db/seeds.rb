# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'
require 'date'
require 'time'

csv_file_name = Rails.root.join("db", "IIP_2014IcebergSeason.csv").to_s
MAX_ROWS = 10000

puts "Now populating icebergs database..."

csv_text = File.read(csv_file_name)
csv = CSV.parse(csv_text, :headers => true)
step_size = (csv.by_row!.size / MAX_ROWS.to_f).ceil

ActiveRecord::Base.transaction do

	# Create database entries
	csv.by_row!.each_slice(step_size) do |chunk|
		row = chunk[0]
		berg_number = row[1].to_i
		date = Date.strptime(row[2], "%m/%d/%Y")
		latitude = row[4].to_f
		longitude = row[5].to_f
		size = row[7]
		shape = row[8]

		Iceberg.create(
			berg_number: berg_number,
			date: date,
			latitude: latitude,
			longitude: longitude,
			size: size,
			shape: shape );
	end

end

puts "Adding dummy user to users database..."
ActiveRecord::Base.transaction do
	user1 = User.new :name => "user_1",:user_name => "azimuth_user_1", :user_id => 3097444134, :profile_image_url => "http://pbs.twimg.com/profile_images/578475341674483712/WC7EOrl_.jpeg"
	user1.build_authorization :secret => "VujS31mFfrnSZR4rp991EjWYiPSlANQuQZRylbsejeONh", :token => "3097444134-RnOqYmq7BHkkl574n1fu1hK1lGVlmxeNggbNb6K"
	user1.build_preference 
	user1.save!
end
Tweet.update_all_users_aux


