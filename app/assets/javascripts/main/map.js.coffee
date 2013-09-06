@GMap = ->
  self = this

  initialize: ->
    self.uniqId           = new Date().utc(true).getTime()
    self.markers          = new Object
    self.navigator        = navigator.geolocation
    self.socket           = io.connect('http://' + window.location.hostname + ':9595')

    @setUserDetails()

    self.socket.on 'data', @loadOtherMarkers


  setUserDetails: ->
    cookie                = document.cookie
    start_of_user_details = cookie.indexOf('user_details=')

    if cookie.indexOf(';', start_of_user_details) == -1
      end_of_user_details = cookie.length
    else
      end_of_user_details = cookie.indexOf(';', start_of_user_details)

    user_details = unescape(cookie.substring(start_of_user_details, end_of_user_details)).split('=')[1].split('_')
    self.channel = user_details[0]
    self.title   = user_details[1]


  loadMap: (position) ->
    latitude   = position.coords.latitude
    longitude  = position.coords.longitude
    mapOptions =
      zoom : 18
      center: new google.maps.LatLng(latitude, longitude)
      mapTypeId: google.maps.MapTypeId.ROADMAP

    self.map = new google.maps.Map($('#map-container')[0], mapOptions)


  loadMarker: (position) ->
    latitude  = position.coords.latitude
    longitude = position.coords.longitude
    latLng    = new google.maps.LatLng(latitude, longitude)

    marker = new google.maps.Marker(
      position: latLng
      map: self.map
      title: self.title
    )

    data =
      channel: self.channel
      values:
        id:        self.uniqId
        latitude:  latitude
        longitude: longitude
        title:     self.title

    self.socket.emit('send', data)


  loadOtherMarkers: (data) ->
    console.log(data)


  render: ->
    if self.navigator
      self.socket.emit('subscribe', self.channel)

      # Load and center the map
      self.navigator.getCurrentPosition(@loadMap)

      self.navigator.watchPosition(@loadMarker)
    else
      console.log('error')
