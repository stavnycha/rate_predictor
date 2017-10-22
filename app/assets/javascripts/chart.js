function PredictionChart(container, history, predicted){
  var data = {
    series: [
      history.concat(new Array(predicted.length)),
      new Array(history.length).concat(predicted)
    ]
  };

  var options = {
    showPoint: false,
    lineSmooth: false,
    height: 500
  };

  new Chartist.Line(container, data, options);
}
