#= require vendor/jquery-1.7.2
#= require_tree ./vendor
#= require_tree ./templates
#= require libraries

class Library
  constructor: (data) ->
    {@name, @hours, @address, @phone} = data
  
  fullAddress: ->
    "#{@address.street}, Durham NC #{@address.zip}"

  isOpen: (date) ->
    day = date.format("dddd")
    time = date.format("HHmm")
    @hours[day].length == 2 and @hours[day][0] <= time <= @hours[day][1]

  openMessage: (date) ->
    if @isOpen(date)
      "until #{@hours[day][1]}"
    else
      dow = date.day()
      day = moment.weekdays[dow]
      time = date.format("HHmm")
      if @hours[day][0] > time
        "It will open at #{mt @hours[day][0]} today."
      else
        dow += 1
        day = moment.weekdays[dow % 7]
        while @hours[day].length != 2 
          dow += 1
          day = moment.weekdays[dow % 7]
        "It will open at #{mt @hours[day][0]} on #{day}."
   
Library.current = ->
  $(document).data('library')

Library.choose = (library) ->
  if (library isnt Library.current())
    monster.set 'library', library
    $(document).data('library', library);
    newLibrary = Library.all[library]
    $("#library-chooser .btn-text").text "the #{newLibrary.name}"
    @displayOpenInfo(library)
    $("#hours").html JST['templates/hours'] 
      name: newLibrary.name
      hours: newLibrary.hours
      mt: Library.formatMilTime
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

Library.displayOpenInfo = (library) ->
  library = @all[library]
  $("#open-info").html JST['templates/open']
    open: library.isOpen moment()
    message: library.openMessage moment()

Library.updateClock = () ->
  $("#now").html moment().format "dddd [at] h:mm a"
  if Library.current()
    Library.displayOpenInfo(Library.current())

Library.formatMilTime = (milTime) ->
  hours = milTime.slice(0, 2)
  minutes = milTime.slice(2, 4)
  am_pm = if hours < 12 then "AM" else "PM"
  printed_hours = hours % 12
  printed_hours += 12 if printed_hours == 12
  "#{printed_hours}:#{minutes} #{am_pm}"

this.mt = Library.formatMilTime

Library.initialize = () ->
  library = monster.get 'library'
  @choose library if library

Library.all = {}

for key, data of libraries
  Library.all[key] = new Library(data)

$(document).ready ->
  $libraryChooser = $("#library-chooser")
  Library.initialize()

  Library.updateClock()
  setInterval Library.updateClock, 1000 * 60
  
  $libraryChooser.find("a").click (event) ->
    Library.choose $(this).data('library')
    event.preventDefault()
