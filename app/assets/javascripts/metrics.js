// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

MMP = {
  setup: function() {
    $("#metric_name_select option:first").attr('disabled','disabled');

    $("#metric_name_select").change(function() {
      $.ajax({
        type: "POST",
        dataType: "json",
        url: "/metrics/by_name",
        data: { name: $(this).val() },
        success: function(metrics_array) {
          MMP.create_map(metrics_array);
        }
      });
    });
  },
  create_map: function(metrics_array) {
    handler = Gmaps.build('Google');
    handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
      markers = handler.addMarkers(metrics_array);
      handler.bounds.extendWith(markers);
      handler.fitMapToBounds();
    });
  }
}