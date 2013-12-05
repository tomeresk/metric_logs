require 'open-uri'
require 'json'

namespace :import_metrics do
  desc "Import the metrics from the json file"
  task :import_json => :environment do
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

  desc "Import the metrics from the raw file"
  task :import_raw => :environment do
    mappings = {:n => "name", :v => "value", :t => "metric_type", :ts => "timestamp", :lat => "latitude", :lon => "longitude"}

    text = '[Metrics][3][{:n=>"network.api_duration.meter_report", :v=>"464", :lon=>34.838475, :t=>"t", :ts=>1352290120, :lat=>32.110303333333334}, {:n=>"network.api_duration.update_get", :v=>"631", :lon=>34.838475, :t=>"t", :ts=>1352290120, :lat=>32.110303333333334}]\n[Metrics][3][{:n=>"network.api_duration.meter_report", :v=>"447", :lon=>34.838370000000005, :t=>"t", :ts=>1352290180, :lat=>32.11018}, {:n=>"network.api_duration.update_get", :v=>"640", :lon=>34.838370000000005, :t=>"t", :ts=>1352290180, :lat=>32.11018}]\n[Metrics][7][{:n=>"network.reception_strength", :v=>"99", :lon=>0.0049496, :t=>"g", :ts=>1352487909, :lat=>51.5586811}, {:n=>"network.api_duration.update_get", :v=>"3950", :lon=>0.0090684, :t=>"t", :ts=>1352487968, :lat=>51.5576031}]'
    
    metrics_strings_array = text.split("[Metrics]")

    # remove the empty string at the start of the array
    metrics_strings_array.delete_at(0)

    metrics_strings_array.each do |current_metric_list|
      driver_id = current_metric_list[1]

      # remove the "\n" from the end of the string, except for in the last metric list that doesn't have it
      current_metric_list.slice!(current_metric_list.size-2,2) if current_metric_list[current_metric_list.size-1] == "n"

      #remove the driver id from the start of the metric list
      current_metric_list.slice!(0, 3)

      metrics_array = eval(current_metric_list)

      metrics_array.each do |metric_hash|
        metric_hash["driver_id"] = driver_id

        # rename the metric_hash keys to match their counterparts in the Metric model
        metric_hash.keys.each do |key|
          metric_hash[mappings[key]] = metric_hash.delete(key) if mappings[key]
        end

        Metric.create(metric_hash)
      end
    end
  end
end
