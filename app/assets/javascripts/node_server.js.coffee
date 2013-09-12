app  = require('http').createServer(handler)
io   = require('socket.io').listen(app)

app.listen(9595)

handler = (req, res) ->

io.sockets.on 'connection', (socket) ->
  socket.on 'subscribe', (channel) ->
    socket.join(channel)

  socket.on 'send', (data) ->
    console.log(data)
    socket.broadcast.to(data.channel).emit('data', data.values)
