require 'open-uri'
require 'json'

namespace :import_metrics do
  @mappings = {:n => :name, :v => :value, :t => :metric_type, :ts => :timestamp, :lat => :latitude, :lon => :longitude}

  desc "Import the metrics from the json file"
  task :import_json => :environment do
    open("https://dl.dropboxusercontent.com/s/womadmxu5db629i/metrics_json.log").read.split(/\n/).each do |current_metric|
      metric_hash = JSON.parse(current_metric)

      rename_and_save_metric(metric_hash)
    end
  end

  desc "Import the metrics from the raw file"
  task :import_raw => :environment do    
    metrics_strings_array = open("https://dl.dropboxusercontent.com/s/hn8w1wlaxsybyoa/metrics.log").read.split("[Metrics]")

    # remove the empty string at the start of the array
    metrics_strings_array.delete_at(0)

    metrics_strings_array.each do |current_metric_list|
      # remove the driver id from the start of the metric list and save it
      current_metric_list.slice!(/^\[(\d*)\]/)
      driver_id = $1

      # remove the "\n" from the end of the string, except for in the last metric list that doesn't have it
      current_metric_list.slice!(current_metric_list.size-1) if current_metric_list[current_metric_list.size-1] == "\n"

      metrics_array = eval(current_metric_list)

      metrics_array.each do |metric_hash|
        metric_hash[:driver_id] = driver_id

        rename_and_save_metric(metric_hash)
      end
    end
  end

  def rename_and_save_metric(metric_hash)
    metric_hash.symbolize_keys!

    # rename the metric_hash keys to match their counterparts in the Metric model
    metric_hash.keys.each do |key|
      metric_hash[@mappings[key]] = metric_hash.delete(key) if @mappings[key]
    end

    Metric.create(metric_hash)
  end
end
