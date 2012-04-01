#= require vendor/jquery-1.7.2
#= require_tree ./vendor
#= require_tree ./templates
#= require libraries

class Library
  constructor: (data) ->
    {@name, @hours, @address, @phone} = data
  
  fullAddress: ->
    "#{@address.street}, Durham NC #{@address.zip}"

Library.current = ->
  $(document).data('library')

Library.choose = (library) ->
  if (library isnt Library.current())
    monster.set 'library', library
    $(document).data('library', library);
    newLibrary = Library.all[library]
    $("#library-chooser .btn-text").text "the #{newLibrary.name}"
    $("#hours").html JST['templates/hours'] 
      name: newLibrary.name
      hours: newLibrary.hours
    $("#contact").html JST['templates/contact']
      name: newLibrary.name 
      address: newLibrary.address 
      phone: newLibrary.phone
    $("#map").gMap
      address: newLibrary.fullAddress()
      zoom: 16
      controls: ["GSmallZoomControl3D"]
      scrollwheel: false
      markers: [
        address: newLibrary.fullAddress()
        html: "#{newLibrary.name}<br><a target='_blank' href='http://maps.google.com/maps?q=#{newLibrary.fullAddress()}'>Google Map</a>"
      ]

Library.initialize = () ->
  library = monster.get 'library'
  Library.choose library if library

Library.all = []

for key, data of libraries
  Library.all[key] = new Library(data)

updateClock = () ->
  $("#now").html moment().format "dddd [at] h:mm a"

$(document).ready ->
  $libraryChooser = $("#library-chooser")
  Library.initialize()

  updateClock()
  setInterval updateClock, 1000 * 60
  
  $libraryChooser.find("a").click (event) ->
    Library.choose $(this).data('library')
    event.preventDefault()
