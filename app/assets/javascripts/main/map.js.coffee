@GMap = ->
  self = this

  initialize: ->
    cookie                = document.cookie
    start_of_user_details = cookie.indexOf('user_details=')
    end_of_user_details   = cookie.indexOf(';', start_of_user_details)
    user_details          = unescape(document.cookie.substring(start_of_user_details, end_of_user_details)).split('=')[1].split('_')
    self.navigator        = navigator.geolocation
    self.channel          = user_details[0]
    self.title            = user_details[1]
    self.socket           = io.connect('http://' + window.location.hostname + ':9595')


  loadMap: (position) ->
    latitude   = position.coords.latitude
    longitude  = position.coords.longitude
    mapOptions =
      zoom : 18
      center: new google.maps.LatLng(latitude, longitude)
      mapTypeId: google.maps.MapTypeId.ROADMAP

    self.map = new google.maps.Map($('#map-container')[0], mapOptions)


  emitMarker: (position) ->
    latitude  = position.coords.latitude
    longitude = position.coords.longitude

    data =
      title:     self.title
      latitude:  latitude
      longitude: longitude

    console.log(self.socket.emit(self.channel, data))


  loadMarkers: (data) ->

    latLng    = new google.maps.LatLng(latitude, longitude)

    new google.maps.Marker(
      position: latLng
      map: self.map
      title: self.title
    )


  render: ->
    if self.navigator
      self.navigator.getCurrentPosition(@loadMap)
      self.navigator.watchPosition(@emitMarker)

      self.socket.on(self.channel, @loadMarkers)
    else
      console.log('error')
