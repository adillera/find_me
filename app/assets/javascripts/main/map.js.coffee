@GMap = ->
  self = this

  initialize: ->
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
    self.uniqId  = user_details[0]
    self.channel = user_details[1]
    self.title   = user_details[2]


  loadMap: (position) ->
    latitude   = position.coords.latitude
    longitude  = position.coords.longitude
    mapOptions =
      zoom : 18
      center: new google.maps.LatLng(latitude, longitude)
      mapTypeId: google.maps.MapTypeId.ROADMAP

    self.map = new google.maps.Map($('#map-container')[0], mapOptions)


  loadMarker: (position) ->
    if self.markers[self.uniqId] then self.markers[self.uniqId].setMap(map: null)

    latitude  = position.coords.latitude
    longitude = position.coords.longitude
    latLng    = new google.maps.LatLng(latitude, longitude)

    marker = new google.maps.Marker
      position: latLng
      map:      self.map
      title:    self.title

    self.markers[self.uniqId] = marker

    data =
      channel: self.channel
      values:
        uniqId:    self.uniqId
        latitude:  latitude
        longitude: longitude
        title:     self.title

    self.socket.emit('send', data)


  loadOtherMarkers: (data) ->
    if self.markers[data.uniqId] then self.markers[data.uniqId].setMap(map: null)

    latLng = new google.maps.LatLng(data.latitude, data.longitude)

    marker = new google.maps.Marker
      position: latLng
      map:      self.map
      title:    data.title

    self.markers[data.uniqId] = marker


  render: ->
    if self.navigator
      self.socket.emit('subscribe', self.channel)

      # Load and center the map
      self.navigator.getCurrentPosition(@loadMap)

      self.navigator.watchPosition(@loadMarker)
    else
      console.log('error')
