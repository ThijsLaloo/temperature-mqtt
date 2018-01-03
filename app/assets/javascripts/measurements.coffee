# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

postId = 0
temparr = []


$ ->
  ctx = document.getElementById('myChart').getContext('2d')
  window.myChart = new Chart(ctx,
    type: 'line'
    data:
      datasets: [ {
        label: 'laatst gemeten temperaturen'
        backgroundColor : 'rgba(255, 128, 10, 0.1)'
        pointBackgroundColor: '#FF800A',
        borderColor: '#FF800A'
        pointBorderColor: '#D3D3D3'
        borderWidth: 1
      } ]
    options:
      legend: {
        labels: {
          fontColor: "white"
        }
      }
      scales:
        xAxes: [{
          ticks: {
            fontColor: "white"
            beginAtZero: true
          }
        }]
        yAxes: [{
          ticks: {
            fontColor: "white"
            beginAtZero: true
          }
        }])

ChartValAdd = ->
  window.myChart.config.data.labels.push 'Post ' + postId++
  window.myChart.config.data.datasets[0].data.push 6
  window.myChart.update()

Get = (yourUrl) ->
  Httpreq = new XMLHttpRequest
  # a new request
  Httpreq.open 'GET', yourUrl, false
  Httpreq.send null
  Httpreq.responseText

PutArray = ->
  json_obj = JSON.parse(Get("http://localhost:3000/measurements.json"))
  # alert json_obj.temperature
  for i of json_obj
    temparr.push json_obj[i].temperature
  alert temparr