class MetricsController < ApplicationController
  def map_display
    @distinct_metric_names = Metric.distinct_names.collect(&:name)
  end

  def metrics_by_name
    metrics = Metric.by_name(params[:name])

    hash = Gmaps4rails.build_markers(metrics) do |metric, marker|
      marker.lat metric.latitude
      marker.lng metric.longitude
      marker.infowindow metric_html_description(metric)
    end

    render json: hash.to_json
  end

  def metric_html_description(metric)
    %{
      driver_id: #{metric.driver_id}<br>
      value: #{metric.value}<br>
      type: #{metric.metric_type}<br>
      date: #{DateTime.strptime(metric.timestamp,'%s').strftime('%d-%m-%Y %H:%M:%S')}
    }
  end
end
