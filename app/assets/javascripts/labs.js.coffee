window.labs = []
window.map = null
window.showingContacts = false

down = false

last_valid_selection = $('.referee_approval').val

$('.referee_approval').change (event) ->
  if $(this).val().length > 3
    $(this).val last_valid_selection
  else
    last_valid_selection = $(this).val()
  return

# function to redraw the map, and place the marker according to the current geocoder address
# added by Taco to fix issue that was introduced when hiding/showing the steps.
updateMap = ->
  map = $('#geocomplete').geocomplete('map')
  google.maps.event.trigger map, 'resize'
  $('input').trigger 'geocode'
  return

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
    window.scrollTo(0, 0)
    $('.crumb-two').removeClass 'crumb-active'
    $('.crumb-one').addClass 'crumb-active'

  $('.three-back').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-three').removeClass 'active-field'
    $('.field-two').addClass 'active-field'
    window.scrollTo(0, 0)
    $('.crumb-three').removeClass 'crumb-active'
    $('.crumb-two').addClass 'crumb-active'

  $('.four-back').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-four').removeClass 'active-field'
    $('.field-three').addClass 'active-field'
    window.scrollTo(0, 0)
    $('.crumb-four').removeClass 'crumb-active'
    $('.crumb-three').addClass 'crumb-active'

  $('.five-back').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-five').removeClass 'active-field'
    $('.field-four').addClass 'active-field'
    window.scrollTo(0, 0)
    $('.crumb-five').removeClass 'crumb-active'
    $('.crumb-four').addClass 'crumb-active'

  $('.six-back').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-six').removeClass 'active-field'
    $('.field-five').addClass 'active-field'
    window.scrollTo(0, 0)
    $('.crumb-six').removeClass 'crumb-active'
    $('.crumb-five').addClass 'crumb-active'

# Next Buttons

  $('.next-two').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-two').addClass 'active-field'
    $('.field-one').removeClass 'active-field'
    window.scrollTo(0, 0)
    $('.crumb-two').addClass 'crumb-active'
    $('.crumb-one').removeClass 'crumb-active'

  $('.next-three').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-three').addClass 'active-field'
    $('.field-two').removeClass 'active-field'
    window.scrollTo(0, 0)
    $('.crumb-three').addClass 'crumb-active'
    $('.crumb-two').removeClass 'crumb-active'

  $('.next-four').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-four').addClass 'active-field'
    $('.field-three').removeClass 'active-field'
    window.scrollTo(0, 0)
    $('.crumb-four').addClass 'crumb-active'
    $('.crumb-three').removeClass 'crumb-active'

  $('.next-five').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-five').addClass 'active-field'
    $('.field-four').removeClass 'active-field'
    window.scrollTo(0, 0)
    updateMap()
    $('.crumb-five').addClass 'crumb-active'
    $('.crumb-four').removeClass 'crumb-active'

  $('.next-six').mouseover ->
    $(this).toggleClass 'active-field' if (down)
  .click ->
    $('.field-six').addClass 'active-field'
    $('.field-five').removeClass 'active-field'
    window.scrollTo(0, 0)
    $('.crumb-six').addClass 'crumb-active'
    $('.crumb-five').removeClass 'crumb-active'

# Find Error Box, Display All Fields, Remove Buttons

  if $('#error-message').length > 0
    $('.field').addClass 'active-field'
    $('.crumb').addClass 'crumb-active'
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
    ], 4)

    # removed for ios7 see: https://github.com/Leaflet/Leaflet.markercluster/issues/279
    # if !navigator.userAgent.match(/(iPad|iPhone|iPod touch);.*CPU.*OS 7_\d/i)
    #   window.markers = new L.MarkerClusterGroup
    #     showCoverageOnHover: true
    #     spiderfyOnMaxZoom: false
    #     removeOutsideVisibleBounds: true
    #     zoomToBoundsOnClick: true
    #     maxClusterRadius: 50
    #     disableClusteringAtZoom: 14
    # else
    window.markers = map

    #check to see if we are embedded or not
    url = window.location.href
    lastPart = url.substr(url.lastIndexOf('/') + 1)
    embedded = (lastPart == "embed")
    # console.log("embedded: " + embedded)

    new L.Control.Zoom({ position: 'topleft' }).addTo(map)

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
          if embedded
            lab.marker.bindPopup("<a href='#{lab.url}' target='_new'>#{lab.name}</a>")
          else
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
