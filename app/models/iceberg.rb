class Iceberg < ActiveRecord::Base

  def self.query_by_month_day(m, d)
    where("extract(month from date) = ? and extract(day from date) = ?", m, d)
  end
end
