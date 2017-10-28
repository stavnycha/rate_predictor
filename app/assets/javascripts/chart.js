function PredictionChart(container, labels, history, predicted){
  var green = 'rgb(75, 192, 192)'
  var blue = 'rgb(54, 162, 235)'

  var context = document.getElementById(container).getContext('2d');

  var options = {
    responsive: true,
    title:{
      display:true,
      text:'Exchange rate'
    },
    tooltips: {
      mode: 'index',
      intersect: false,
    },
    hover: {
      mode: 'nearest',
      intersect: true
    },
    scales: {
      xAxes: [{
        display: true,
        scaleLabel: {
          display: true,
          labelString: 'Date'
        }
      }],
      yAxes: [{
        display: true,
        scaleLabel: {
          display: true,
          labelString: 'Rate'
        }
      }]
    }
  };

  var data = {
    labels: labels,
    datasets: [{
      label: 'History rates',
      fill: false,
      backgroundColor: blue,
      borderColor: blue,
      data: history
    },{
      label: 'Predicted rates',
      fill: false,
      borderDash: [5, 5],
      backgroundColor: green,
      borderColor: green,
      data: new Array(history.length).fill(null).concat(predicted)
    }]
  };

  var chart = new Chart(context, {
    type: 'line',
    data: data,
    options: options
  })
}
