class Iceberg < ActiveRecord::Base
  validates :ice_year, presence: true
  validates :berg_number, presence: true
  validates :date, presence: true
  validates: :time, presence: true
  validates: :latitude, presence: true
  validates :longitude, presence: true
  validates :method, presence: true
  validates :size, presence: true
  validates :shape, presence: true
  validates :source, presence: true
end

