require 'open-uri'
require 'json'

namespace :import_metrics do
	desc "Import the metrics from the json file"
  task :import => :environment do
    mappings = {"n" => "name", "v" => "value", "t" => "metric_type", "ts" => "timestamp", "lat" => "latitude", "lon" => "longitude"}

    open("https://dl.dropboxusercontent.com/s/womadmxu5db629i/metrics_json.log").read.split(/\n/).each do |current_metric|
      metric_hash = JSON.parse(current_metric)

      # rename the metric_hash keys to match their counterparts in the Metric model
      metric_hash.keys.each do |key|
        metric_hash[mappings[key]] = metric_hash.delete(key) if mappings[key]
      end

      Metric.create(metric_hash)
    end
  end
end
