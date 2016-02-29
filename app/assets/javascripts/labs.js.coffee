window.labs = []
window.map = null
window.showingContacts = false

down = false

ready = ->


  options = {
    valueNames: [ 'name', 'year' ]
  }
  window.userList = new List('students', options)

  $('#students-filter a').click (e) ->
    e.preventDefault()
    $('#students-filter dd').removeClass('active')
    $(this).parents('dd').addClass('active')
    if $(this).data('year')
      window.userList.filter (item) =>
        return parseInt(item._values.year) == parseInt($(this).data('year'))
    else
      window.userList.filter()

  $('#check-labs').change ->
    alert("We already have '#{$(this).val()}' lab in our database, if it is not yet visible on the site it will be soon")

  $(document).mousedown ->
    down = true
  .mouseup ->
    down = false

  $('.opening-hours td').mouseover ->
    $(this).toggleClass 'active' if (down)
  .click ->
    $(this).toggleClass 'active'

# Start Laurie Code


# Back Buttons

  $('.two-back').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-two').removeClass 'active-field' 
    $('.field-one').addClass 'active-field' 

  $('.three-back').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-three').removeClass 'active-field'
    $('.field-two').addClass 'active-field' 

  $('.four-back').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-four').removeClass 'active-field'
    $('.field-three').addClass 'active-field' 

  $('.five-back').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-five').removeClass 'active-field'
    $('.field-four').addClass 'active-field' 

  $('.six-back').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-six').removeClass 'active-field'
    $('.field-five').addClass 'active-field' 

# Next Buttons

  $('.next-two').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-two').addClass 'active-field'
    $('.field-one').removeClass 'active-field'

  $('.next-three').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-three').addClass 'active-field'
    $('.field-two').removeClass 'active-field'

  $('.next-four').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-four').addClass 'active-field'
    $('.field-three').removeClass 'active-field' 

  $('.next-five').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-five').addClass 'active-field'
    $('.field-four').removeClass 'active-field'

  $('.next-six').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-six').addClass 'active-field'
    $('.field-five').removeClass 'active-field'

# Find Error Box, Display All Fields, Remove Buttons

  if $('#error-message').length > 0
    $('.field').addClass 'active-field '
    $('.next-two').addClass 'display-none'
    $('.next-three').addClass 'display-none'
    $('.next-four').addClass 'display-none'
    $('.next-five').addClass 'display-none'
    $('.next-six').addClass 'display-none'
    $('.two-back').addClass 'display-none'
    $('.three-back').addClass 'display-none'
    $('.four-back').addClass 'display-none'
    $('.five-back').addClass 'display-none'
    $('.six-back').addClass 'display-none'



# End Laurie Code

  $('[data-toggle=offcanvas]').click ->
    $('.row-offcanvas').toggleClass('active')

  if $('body').hasClass('c-labs a-show') and $('#lab-map').length > 0
    location = [$('#lab-map').data('latitude'), $('#lab-map').data('longitude')]

    L.mapbox.accessToken = 'pk.eyJ1IjoidG9tYXNkaWV6IiwiYSI6ImRTd01HSGsifQ.loQdtLNQ8GJkJl2LUzzxVg'
    labmap = L.mapbox.map('lab-map', 'mapbox.pencil', { scrollWheelZoom: false, zoomControl: false, loadingControl: true }).setView(location, 14 )

    new L.Control.Zoom({ position: 'topright' }).addTo(labmap)
    icon = L.icon({
      iconUrl: window.mapIcons[$('#lab-map').data('kind-name')]
      iconSize:     [35, 35]
      iconAnchor:   [17, 33]
      popupAnchor:  [0, -20]
    })
    labmap.addLayer(L.marker(location, {icon: icon})).invalidateSize()
    $(window).resize _.debounce((-> labmap.invalidateSize()),500)

  $('#lab_name').change ->
    unless $('#lab_slug').val()
      $('#lab_slug').val( $(this).val().toLowerCase().replace(/[^A-Za-z0-9]/g,''); )

  # $('.step-2').css(opacity: 0.5)
  $(".c-labs input#geocomplete").geocomplete
    map: "#location-picker-map"
    location: $('#geocomplete').data('latlng')
    details: ".c-labs.a-new .address"
    detailsAttribute: "data-geo"
    markerOptions:
      draggable: true
  .bind "geocode:dragged", (event, latLng) ->
    $("input#lab_latitude").val latLng.lat()
    $("input#lab_longitude").val latLng.lng()
  .bind "geocode:result", (event, result) ->
    $('.c-labs.a-new #lab_address_1').focus()
    $("input#lab_latitude").val result.geometry.location.lat()
    $("input#lab_longitude").val result.geometry.location.lng()

  if $('body').hasClass('c-labs a-map') or $('body').hasClass('a-embed')
    L.mapbox.accessToken = 'pk.eyJ1IjoidG9tYXNkaWV6IiwiYSI6ImRTd01HSGsifQ.loQdtLNQ8GJkJl2LUzzxVg'
    map = L.mapbox.map('map', 'mapbox.pencil', { scrollWheelZoom: true, zoomControl: false }).setView([
      50
      0
    ], 2)

    # removed for ios7 see: https://github.com/Leaflet/Leaflet.markercluster/issues/279
    if !navigator.userAgent.match(/(iPad|iPhone|iPod touch);.*CPU.*OS 7_\d/i)
      window.markers = new L.MarkerClusterGroup
        showCoverageOnHover: true
        spiderfyOnMaxZoom: false
        removeOutsideVisibleBounds: true
        zoomToBoundsOnClick: true
        maxClusterRadius: 50
        disableClusteringAtZoom: 14
    else
      window.markers = map

    new L.Control.Zoom({ position: 'topleft' }).addTo(map)
    navigator.geolocation.getCurrentPosition((position)->
      map.setView([position.coords.latitude, position.coords.longitude], 4)
    )

    $.get "/mapdata.json", (labs) ->
      for lab in labs.labs
        if lab.latitude and lab.longitude
          icon = L.icon({
            iconUrl: window.mapIcons[lab.kind_name]
            iconSize:     [35, 35]
            iconAnchor:   [17, 33]
            popupAnchor:  [0, -20]
          })
          lab.marker = L.marker([lab.latitude, lab.longitude], {icon: icon})
          lab.marker.bindPopup("<a href='#{lab.url}'>#{lab.name}</a>")
          window.markers.addLayer(lab.marker)
          window.labs.push(lab)
    map.addLayer(window.markers)

    windowHeight = ->
      $('#map').css('top', $('#main').offset().top).height($(window).height() - $('#main').offset().top)
      map.invalidateSize()
    $(window).resize _.debounce(windowHeight,100)

$(document).ready ready
# $(document).on "page:load", ready
