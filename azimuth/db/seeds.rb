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

puts "Checkpoint 1"

csv_text = File.read(csv_file_name)
csv = CSV.parse(csv_text, :headers => true)

iceberg_array = Array.new

ActiveRecord::Base.transaction do

	# Create database entries
	csv.each do |row|
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
