@GMap = ->

  initialize: ->
    _.bindAll(@, 'setUserDetails', 'render', 'renderMarker', 'loadMap', 'loadMarker', 'removeExistingMarker', 'loadOtherMarkers')

    @markers          = new Object
    @navigator        = navigator.geolocation
    @socket           = io.connect('http://' + window.location.hostname + ':9595')

    @setUserDetails()

    @socket.on 'data', @loadOtherMarkers


  setUserDetails: ->
    cookie                = document.cookie
    start_of_user_details = cookie.indexOf('user_details=')

    if cookie.indexOf(';', start_of_user_details) == -1
      end_of_user_details = cookie.length
    else
      end_of_user_details = cookie.indexOf(';', start_of_user_details)

    user_details = unescape(cookie.substring(start_of_user_details, end_of_user_details)).split('=')[1].split('_')
    @uniqId      = user_details[0]
    @channel     = user_details[1]
    @title       = user_details[2]


  loadMap: (position) ->
    latitude   = position.coords.latitude
    longitude  = position.coords.longitude
    mapOptions =
      zoom : 18
      center: new google.maps.LatLng(latitude, longitude)
      mapTypeId: google.maps.MapTypeId.ROADMAP

    @map = new google.maps.Map($('#map-container')[0], mapOptions)


  removeExistingMarker: (uniqId) ->
    if @markers[uniqId] then @markers[uniqId].setMap(null)


  renderMarker: (data) ->
    @removeExistingMarker(data.uniqId)

    latLng = new google.maps.LatLng(data.latitude, data.longitude)

    marker = new google.maps.Marker
      position: latLng
      map     : @map
      title   : data.title

    @markers[data.uniqId] = marker


  loadMarker: (position) ->
    latitude  = position.coords.latitude
    longitude = position.coords.longitude

    @renderMarker
      latitude : latitude
      longitude: longitude
      title    : @title
      uniqId   : @uniqId

    data =
      channel: @channel
      values:
        uniqId   : @uniqId
        latitude : latitude
        longitude: longitude
        title    : @title

    @socket.emit('send', data)


  loadOtherMarkers: (data) ->
    @renderMarker(data)


  render: ->
    if @navigator
      @socket.emit('subscribe', @channel)

      # Load and center the map
      @navigator.getCurrentPosition(@loadMap)

      @navigator.watchPosition(@loadMarker)
    else
      console.log('error')
