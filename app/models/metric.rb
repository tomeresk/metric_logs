class Metric < ActiveRecord::Base
  attr_accessible :name, :value, :metric_type, :timestamp, :driver_id, :latitude, :longitude
end
