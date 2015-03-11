=begin
require 'net/ftp'

iceberg_data = "IIP_2014IcebergSeason.csv"

ftp = Net::FTP.new("sidads.colorado.edu")
ftp.login
ftp.chdir("pub/DATASETS/NOAA/G00807/")
ftp.getbinaryfile(iceberg_data, Rails.root.join("db", iceberg_data).to_s)
=end
