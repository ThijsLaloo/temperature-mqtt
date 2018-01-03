postId = 0

App.temperature = App.cable.subscriptions.create "TemperatureChannel",
  connected: ->
  	console.log 'connected to websocket'
    # Called when the subscription is ready for use on the server

  disconnected: ->
  	console.log 'disconnected from websocket'
    # Called when the subscription has been terminated by the server

  received: (data) ->
  	console.log "data is: " + data
  	# da = [data]
  	s = JSON.stringify(data.data)
  	console.log "s is: " + s
  	d = JSON.parse(s)
  	console.log "d is: " + d
  	window.myChart.config.data.labels.push 'Post ' + postId++
  	window.myChart.config.data.datasets[0].data.push d
  	window.myChart.update()
    # Called when theres incoming data on the websocket for this channel
