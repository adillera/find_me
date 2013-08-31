app = require('http').createServer(handler)
io  = require('socket.io').listen(app)


app.listen(9595)


io.sockets.on 'connection', (socket) ->
  console.log('socket open')

handler = ->
  console.log('handler')
