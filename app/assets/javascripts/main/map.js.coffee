@GMap = ->
  self = this

  initialize: ->
    self.navigator = navigator.geolocation
    self.title = 'You'
    self.channel = 0


  loadMap: (position) ->
    latitude   = position.coords.latitude
    longitude  = position.coords.longitude
    mapOptions =
      zoom : 24
      center: new google.maps.LatLng(latitude, longitude)
      mapTypeId: google.maps.MapTypeId.ROADMAP

    self.map = new google.maps.Map($('#map-container')[0], mapOptions)


  loadMarker: (position) ->
    latitude  = position.coords.latitude
    longitude = position.coords.longitude
    latLng    = new google.maps.LatLng(latitude, longitude)

    new google.maps.Marker(
      position: latLng
      map: self.map
      title: self.title
    )


  render: ->
    if self.navigator
      self.navigator.getCurrentPosition(@loadMap)
      self.navigator.watchPosition(@loadMarker)
    else
      console.log('error')
