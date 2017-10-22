function ping_status(id){
  var pending_statuses = [ 'requested' ]

  $.ajax({
    url: '/api/v1/predictions/' + id,
    dataType: "json",
    success: function (response) {
      if (pending_statuses.indexOf(response.prediction.status) > -1) {
        setTimeout(ping_status.bind(this, id), 1000);
      } else {
        location.reload();
      }
    }
  })
};
