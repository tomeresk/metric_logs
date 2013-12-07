class Metric < ActiveRecord::Base
  attr_accessible :name, :value, :metric_type, :timestamp, :driver_id, :latitude, :longitude

  scope :distinct_names, select(:name).uniq
  scope :by_name, lambda{ |name| where(name: name) }
end
