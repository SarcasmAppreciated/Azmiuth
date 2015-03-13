class Iceberg < ActiveRecord::Base

  def self.query_by_month_day(m, d)
  	if Rails.env.production?
    	where("extract(month from date) = ? and extract(day from date) = ?", m, d)
    elsif Rails.env.development?
    	where("strftime('%m', date) = ? and strftime('%d', date) = ?", m, d)
    end
  end
end
